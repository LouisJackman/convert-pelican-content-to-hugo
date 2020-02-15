#!/bin/sh

set -o errexit
set -o nounset

if [ ! -d content ]
then
    echo 'Content directory not found.' >&2
    echo 'Ensure the current directory is a Pelican site.' >&2
    exit 1
fi

find content -iname '*.md' | while read f
do
    {
        awk -f convert-post.awk "$f" >"$f".tmp
        mv "$f".tmp "$f"
    } &
done
wait

