FROM alpine:edge
ADD config.sh /config.sh
RUN apk update
RUN apk add --no-cache --virtual .build-deps ca-certificates curl tar openntpd \
    && chmod +x /config.sh
ENV TZ Asia/Shanghai
RUN rm -rf /var/cache/apk/*
RUN apk del .build-deps
CMD /config.sh
