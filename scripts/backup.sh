#!/usr/bin/env bash

set -e

if [ $(id -u) == "0" ] ; then
  echo "This script must be run as the postgres user"
  exit 1
fi

wal-g backup-push "$PGDATA"
