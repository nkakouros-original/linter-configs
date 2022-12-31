#!/usr/bin/env bash

source /linter-configs/vendor/python/bin/activate

mkdir -p ~/.ssh
ssh-keyscan -t rsa github.com > ~/.ssh/known_hosts 2>/dev/null

cp -nr /linter-configs/configs/* /repo/
cp -rn /linter-configs/configs/.* /repo/
export PATH=${PATH}:`go env GOPATH`/bin

if [[ "$#" -gt 0 ]]; then
  "$@"
  exit
fi

/linter-configs/bin/run-linters
