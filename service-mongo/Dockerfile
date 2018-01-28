FROM alpine:3.6
COPY run.sh .
RUN apk add --no-cache mongodb dumb-init && \
    rm /usr/bin/mongoperf
VOLUME /data/db
EXPOSE 27017 27017
ENTRYPOINT [ "dumb-init" ]
CMD [ "./run.sh" ]