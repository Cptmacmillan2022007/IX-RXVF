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

# V2/X2 new configuration
install -d /usr/local/etc/xray
cat << EOF > /usr/local/etc/xray/config.json
{
    "log": {
        "loglevel": "none"
    },
    "inbounds": [
        {
            "listen": "0.0.0.0",
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
                "tlsSettings": {
                    "rejectUnknownSni": true,
                    "allowInsecure": false,
                    "fingerprint": "randomized"
                },
                "wsSettings": {
                  "path": "/$ID-vless"
                }
            },
            "mux": {
                "enabled": true,
                "concurrency": 8
            }
        },
        {
            "listen": "0.0.0.0",
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
                "tlsSettings": {
                    "rejectUnknownSni": true,
                    "allowInsecure": false,
                    "fingerprint": "randomized"
                },
                "wsSettings": {
                  "path": "/$ID-trojan"
                }
            },
            "mux": {
                "enabled": true,
                "concurrency": 8
            }
        }
    ],
    "routing": {
        "domainStrategy": "IPIfNonMatch",
        "domainMatcher": "hybrid",
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
              "outboundTag": "block"
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
            "tag": "block"
        }
    ],
    "dns": {
        "servers": [
            {
                "address": "https://dns.google/dns-query",
                "address": "https://cloudflare-dns.com/dns-query",
                "skipFallback": true
            }
        ],
        "queryStrategy": "UseIPv4",
        "disableCache": true,
        "disableFallback": true
    }
}
EOF

# Run V2/X2
/usr/local/bin/xray -config /usr/local/etc/xray/config.json
