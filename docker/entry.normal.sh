#!/usr/bin/env bash

source /linter-configs/.python/bin/activate

cp -r /linter-configs/configs/* /repo/

cd /repo

if [[ "$#" -gt 0 ]]; then
  "$@"
  exit
fi

/linter-configs/run-linters
