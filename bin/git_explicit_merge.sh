#!/bin/bash

from=$1
to=$2

echo "Merged from $from to $to"

mergebase=$( git merge-base --all $from $to )

echo "Merge base at $mergebase"

git diff --find-renames ${mergebase} $from > from.log 
git diff --find-renames ${mergebase} $to > to.log

