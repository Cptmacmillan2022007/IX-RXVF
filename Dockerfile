FROM alpine:edge
ADD config.sh /config.sh
ENV TZ Asia/Shanghai
RUN apk update
RUN apk add --no-cache --virtual .build-deps ca-certificates curl tar openntpd tzdata \
    && cp /usr/share/zoneinfo/${TZ} /etc/localtime \
    && echo ${TZ} > /etc/timezone \
    && chmod +x /config.sh
RUN rm -rf /var/cache/apk/*
RUN apk del .build-deps tzdata
CMD /config.sh
