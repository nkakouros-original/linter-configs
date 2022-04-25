#!/usr/bin/env bash

function usage() {
  cat <<'HERE'
A script to check the style of bash scripts. The supported rules are not covered
by existing linting tools such as `shfmt` and `shellcheck`. For a list of the
available rules see the bottom of this file.

It accepts a list of files to check for compliance. These should be bash
scripts. The script does not verify this in any way.

To disable a rule for a line append a comment like:

    # twmn-lint-bash disable=TWMN-1001

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

    file="${line%%:*}"
    lineno="${line#*:}"
    lineno="${lineno%%:*}"
    line="${line/$file:$lineno:/}"

    readarray -t wholefile <"$file"

    if [[ "${wholefile[$((lineno - 2))]}" =~ ^[\ ]*\#\ twmn-lint-bash\ disable=TWMN-$id ]] \
      || [[ "$line" =~ \#\ twmn-lint-bash\ disable=TWMN-$id$ ]]; then
      continue
    fi

    printf '%s\n    %s\n        %s\n\n' \
      "$file:$lineno" \
      "TWMN-$id: $message" \
      "$line"
  done <<<"$(grep -rnP "$pattern" "${files[@]}" || :)"

  result=1
}

check_rule '1001' "use bash's double brackets for testing" '^\s*(if )?(! )?\[ [^[\]]+ \]' "$@"
check_rule '1002' 'use double quotes to avoid trouble (in the future or now)' '^[^"=]+=([^" ]*)(("[^"]*")*)([^" ]*)(\$\w+)[^"]*$' "$@"
check_rule '1003' 'use double equals for equality checking' '\[\[? .+ = .+ \]?\]' "$@"
check_rule '1004' 'no multiple assignments in one line' '^[a-zA-Z_]+=[^ ]+ [a-zA-Z_]+=[^ ]+' "$@"

exit "$result"
