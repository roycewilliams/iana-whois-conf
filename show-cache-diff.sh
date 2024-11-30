#!/bin/bash

CACHEDIR=./cache/
BASELINEDIR=./cache.baseline/

echo " - Showing cache differences ..."

for file in cache/*.html; do

    IS_DIFFERENT=

    BASENAME=$(basename "${file}")

    diff -u "${BASELINEDIR}/${BASENAME}" "${CACHEDIR}/${BASENAME}" >/dev/null|| IS_DIFFERENT=1
    if [ -n "${IS_DIFFERENT}" ]; then
        echo ""
        echo "- Found difference: ${file}:"
        ls -la "${BASELINEDIR}/${BASENAME}" "${CACHEDIR}/${BASENAME}"
        diff -u "${BASELINEDIR}/${BASENAME}" "${CACHEDIR}/${BASENAME}"
    else
        echo -n '.'
    fi

done

echo ""

