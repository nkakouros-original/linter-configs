#!/usr/bin/env bash

function usage() {
  cat <<'HERE'
A script to check the style of bash scripts. The supported rules are not covered
by existing linting tools such as `shfmt` and `shellcheck`. For a list of the
available rules see the bottom of this file.

It accepts a list of files to check for compliance. These should be bash
scripts. The script does not verify this in any way.

To disable a rule for a line append a comment like:

    # extra-lint-bash disable=ELB-1001

Alternatively, you can add this comment in the line immediately above.

# NEEDS more WORK, it still misses a bunch of corner cases...
HERE
}

while [[ "${1::2}" == '--' ]]; do
  case "${1:2}" in
    version)
      echo 'Pro version'
      ;;
    help)
      usage
      ;;
    *)
      echo "unsupported option: $1"
      exit 1
      ;;
  esac
  exit
done

result=0

function check_rule() {
  id="$1"
  message="$2"
  pattern="$3"
  read -ra files <<<"${@:4}"

  local file lineno line wholefile

  while read -r line; do
    if [[ -z "$line" ]]; then
      return
    fi

    # If a single file is passed to grep, `-n` will not output the path to the
    # file.
    [[ "${#files[@]}" -eq 1 ]] && file="${files[0]}" || file="${line%%:*}"
    [[ "${#files[@]}" -eq 1 ]] || lineno="${line#*:}"
    lineno="${lineno%%:*}"
    [[ "${#files[@]}" -eq 1 ]] && line="${line#*:}" || line="${line/$file:$lineno:/}"

    readarray -t wholefile <"$file"

    if [[ "$((lineno - 2))" -gt 0 ]] \
      && [[ "${wholefile[$((lineno - 2))]}" =~ ^[\ ]*\#\ extra-lint-bash\ disable=ELB-$id ]] \
      || [[ "$line" =~ \#\ extra-lint-bash\ disable=ELB-$id$ ]]; then
      continue
    fi

    printf '%s\n    %s\n        %s\n\n' \
      "$file:$lineno" \
      "ELB-$id: $message" \
      "$line"
  done <<<"$(grep -rnP "$pattern" "${files[@]}" || :)"

  result=1
}

check_rule '1003' 'use double equals for equality checking' '\[\[? .+ = .+ \]?\]' "$@"
check_rule '1004' 'no multiple assignments in one line' '^[a-zA-Z_]+=[^ ]+ [a-zA-Z_]+=[^ ]+' "$@"

exit "$result"
