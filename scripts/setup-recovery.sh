#!/usr/bin/env bash

set -e

if [ "$(id -u)" == "0" ] ; then
  echo "This script must be run as the postgres user"
  exit 1
fi

export PG_VERSION=$(ls /usr/lib/postgresql/)

echo "Restoring latest backup..."
rm -rf $PGDATA/*
wal-g backup-fetch $PGDATA LATEST

echo "Enabling recovery mode and disabling archive mode and connections..."
cp $PGDATA/postgresql.conf $PGDATA/postgresql.conf.orig
cat /scripts/recovery.conf >> $PGDATA/postgresql.conf
touch $PGDATA/recovery.signal
