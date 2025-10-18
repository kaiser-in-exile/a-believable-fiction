#!/usr/bin/env bash
set -e  # exit on error

YEAR=$(date +%Y)
WEEK=$(date +%U)
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
  touch "$FILE_PATH"
fi

echo "[INFO] done"
