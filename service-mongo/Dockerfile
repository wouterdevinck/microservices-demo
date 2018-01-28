FROM alpine:3.6
RUN apk add --no-cache mongodb dumb-init && \
    rm /usr/bin/mongoperf
VOLUME /data/db
EXPOSE 27017 28017
ENTRYPOINT [ "dumb-init" ]
CMD [ "mongod", "--bind_ip", "0.0.0.0" ]