#!/bin/sh

# Get V2/X2 binary and decompress binary
mkdir /tmp/xray
curl --retry 10 --retry-max-time 60 -L -H "Cache-Control: no-cache" -fsSL github.com/XTLS/Xray-core/releases/latest/download/Xray-linux-64.zip -o /tmp/xray/xray.zip
busybox unzip /tmp/xray/xray.zip -d /tmp/xray
install -m 755 /tmp/xray/xray /usr/local/bin/xray
install -m 755 /tmp/xray/geosite.dat /usr/local/bin/geosite.dat
install -m 755 /tmp/xray/geoip.dat /usr/local/bin/geoip.dat
xray -version
rm -rf /tmp/xray

# Get CoreDNS and decompress binary
mkdir /tmp/coredns
curl --retry 10 --retry-max-time 60 -L -H "Cache-Control: no-cache" -fsSL github.com/coredns/coredns/releases/download/v1.9.3/coredns_1.9.3_linux_amd64.tgz -o /tmp/coredns/coredns.tgz
tar -zxvf /tmp/coredns/coredns.tgz -C /tmp/coredns
install -m 755 /tmp/coredns/coredns /usr/local/bin/coredns
coredns -version
rm -rf /tmp/coredns

# V2/X2 new configuration
install -d /usr/local/etc/xray
cat << EOF > /usr/local/etc/xray/config.json
{
    "log": {
        "loglevel": "none"
    },
    "inbounds": [
        {
            "port": ${PORT},
            "protocol": "vless",
            "settings": {
                "clients": [
                    {
                        "id": "$ID",
                        "level": 0,
                        "email": "love@v2fly.org"
                    }
                ],
                "decryption": "none"
            },
            "streamSettings": {
                "network": "ws",
                "allowInsecure": false,
                "wsSettings": {
                  "path": "/$ID-vless"
                }
            },
            "sniffing": {
                "enabled": true,
                "destOverride": [
                     "http",
                     "tls"
                ]
            }
        },
        {
            "port": ${PORT},
            "protocol": "trojan",
            "settings": {
                "clients": [
                    {
                        "password":"$ID",
                        "level": 0,
                        "email": "love@v2fly.org"
                    }
                ],
                "decryption": "none"
            },
            "streamSettings": {
                "network": "ws",
                "allowInsecure": false,
                "wsSettings": {
                  "path": "/$ID-trojan"
                }
            },
            "sniffing": {
                "enabled": true,
                "destOverride": [
                     "http",
                     "tls"
                ]
            }
        }
    ],
    "routing": {
        "domainStrategy": "IPIfNonMatch",
        "domainMatcher": "mph",
        "rules": [
           {
              "type": "field",
              "protocol": [
                 "bittorrent"
              ],
              "domains": [
                  "geosite:cn",
                  "geosite:category-ads-all"
              ],
              "outboundTag": "blocked"
           }
        ]
    },
    "outbounds": [
        {
            "protocol": "freedom",
            "settings": {
               "domainStrategy": "UseIPv4",
               "userLevel": 0
            }
        },
        {
            "protocol": "blackhole",
            "tag": "blocked"
        }
    ],
    "dns": {
        "servers": [
            {
                "address": "127.0.0.1",
                "port": 5653,
                "skipFallback": true
            }
        ],
        "queryStrategy": "UseIPv4",
        "disableCache": true,
        "disableFallbackIfMatch": true
    }
}
EOF

# CoreDNS new configuration
install -d /usr/local/etc/coredns
cat << EOF > /usr/local/etc/coredns/config.json
.:5653 {
    bind 127.0.0.1
    forward . 8.8.8.8 8.8.4.4 {
        protocol https_google
    }
}
EOF

# Run V2/X2
/usr/local/bin/xray -config /usr/local/etc/xray/config.json & /usr/local/bin/coredns -conf /usr/local/etc/coredns/config.json
