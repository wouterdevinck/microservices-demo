#!/bin/sh
CMD='mongod --bind_ip "0.0.0.0"'
chown -R mongodb /data/db
exec su -s /bin/sh -c "exec $CMD" mongodb