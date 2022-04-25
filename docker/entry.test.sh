#!/usr/bin/env bash

set -euo pipefail

root_dir="$(realpath "$(dirname "$0")")/.."

git clone https://github.com/bats-core/bats-core /tmp/bats
git clone https://github.com/bats-core/bats-support /tmp/bats-support
git clone https://github.com/bats-core/bats-assert /tmp/bats-assert

cd "$root_dir"

/tmp/bats/bin/bats test/test.bats
