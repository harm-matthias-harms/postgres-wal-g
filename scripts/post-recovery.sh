#!/usr/bin/env bash

set -e

if [ "$(id -u)" == "0" ] ; then
  echo "This script must be run as the postgres user"
  exit 1
fi

PG_VERSION=$(ls /usr/lib/postgresql/)

echo "Disabling recover mode and re enabling archive mode and connections..."
mv "$PGDATA"/postgresql.conf.orig "$PGDATA"/postgresql.conf

echo "Recovery completed, restarting..."
bash -c "sleep 3 && /usr/lib/postgresql/$PG_VERSION/bin/pg_ctl restart -D $PGDATA" &
