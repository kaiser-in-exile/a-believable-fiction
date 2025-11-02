#!/usr/bin/env bash
set -e  # exit on error

# we need this because our template directory is defined relative to the script
script_dir=$(dirname "${BASH_SOURCE[0]}")

export YEAR=$(date +%Y)
export WEEK=$(date +%U)

export WEEK_ORDINAL=$(echo $WEEK | sed -E '
s/([0-9]*1)$/\1st/
s/([0-9]*2)$/\1nd/
s/([0-9]*3)$/\1rd/
s/([0-9]*[04-9])$/\1th/
s/([0-9]*1[1-3])$/\1th/
')

# TODO: verify if this works on linux machines
export EXPECTED_PUBLISH_DATE=$(date -v +1w -v sun -v 10H -v 0M -v 0S -R)
BRANCH_NAME="weeknotes-$YEAR-week-$WEEK"
FILE_PATH="src/posts/weeknotes/${YEAR}-${WEEK}.md"

git fetch origin main:main --update-head-ok

# Check if branch exists locally or remotely
if git show-ref --quiet refs/heads/$BRANCH_NAME || git ls-remote --exit-code origin $BRANCH_NAME >/dev/null 2>&1; then
  echo "[INFO] opening weeknotes for week $WEEK of $YEAR"
  git switch $BRANCH_NAME
else
  echo "[INFO] creating weeknote for week $WEEK of $YEAR"
  git switch main
  git pull origin main
  git switch -c $BRANCH_NAME
fi

# Ensure directory exists
mkdir -p weeknotes

# Create the file if it doesn’t exist
if [ ! -f "$FILE_PATH" ]; then
  echo "[INFO] creating new weeknote: $FILE_PATH"
  TEMPLATE_PATH="$script_dir/templates/weeknotes.template.md"
  envsubst < $TEMPLATE_PATH > $FILE_PATH
fi

echo "[INFO] done"
