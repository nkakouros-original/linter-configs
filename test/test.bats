#!/usr/bin/env bats

load /tmp/bats-support/load.bash
load /tmp/bats-assert/load.bash

setup() {
  source /linter-configs/.python/bin/activate
}

@test "run black and fail" {
  run black --check --diff --quiet . 2>&1

  assert_failure
  assert_line --index 8  -- '-'
  assert_line --index 9 -- 'would reformat test/fixtures/python.py'
  assert_line --index 11 -- '1 file would be reformatted.'
}

@test "run isort and fail" {
  :  # todo
}
