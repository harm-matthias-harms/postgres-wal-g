#!/usr/bin/env bash

set -e

if [ -z ${RECOVERY+x} ]; then
  echo "RECOVERY is unset, starting normally..."
  docker-entrypoint.sh postgres
else
  echo "RECOVERY is set, starting in recovery mode..."
  /scripts/setup-recovery.sh
  docker-entrypoint.sh postgres
fi
