#!/bin/bash
#
# Auto format all code changes by:
# 1. Get the staged swift files that have been modified, added or moved
# 2. For each file, check if it needs to be formatted
# 3. Format the file if needed
# 4. If any formatting has occurred, exit 1
#
################################################################################

# Parse options
while [[ "$#" -gt 0 ]]; do
    case $1 in
        -c|--changed) changed=1 ;;
        -h|--help) help=1 ;;
        *) echo "Unknown parameter passed: $1"; exit 1 ;;
    esac
    shift
done

if [[ $help -eq 1 ]]; then
  echo "usage: format_swift_code.sh [--changed] [--help]"
  echo ""
  echo "-c|--changed     Include all changed files, this essentially means changed and untracked files."
  echo "-h|--help        Show this help."
  exit
fi

function swiftformat {
  scripts/swiftformat --indent 2 --disable redundantSelf --wraparguments beforeFirst --swiftversion 5.0 --quiet "$@"
}

echo "Formatting swift code staged in Git..."

if [[ $changed -eq 1 ]]; then
  files=$(git diff HEAD --name-only --diff-filter=d | grep '\.swift$' & git ls-files . --exclude-standard --others)
else
  # Get the staged swift files that have been modified, added or moved (ignore those that have been deleted)
  files=$(git diff --cached --name-only --diff-filter=d | grep '\.swift$')
fi

while IFS= read -r staged_file; do
  # Check if file needs formatting (false/non-zero == needs formatting)
  if ! swiftformat "${staged_file}" --lint >/dev/null 2>&1; then
    # Format the file
    swiftformat "${staged_file}"
    export formatted=1
  fi
done < <(printf '%s\n' "${files}")

if [[ $formatted ]]; then
  echo -e "\nSome files were formatted, please stage the format update to rid this warning.\n"
  exit 1
fi

echo "Done."
