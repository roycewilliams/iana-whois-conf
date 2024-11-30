#!/bin/bash

CACHEDIR=./cache/
BASELINEDIR=./cache.baseline/

echo " - Setting cache baselines ..."

for file in cache/*.html; do

    IS_DIFFERENT=

    BASENAME=$(basename "${file}")

    diff -u "${BASELINEDIR}/${BASENAME}" "${CACHEDIR}/${BASENAME}" || IS_DIFFERENT=1
    if [ -n "${IS_DIFFERENT}" ]; then

        echo ""
        echo "- Baselining ${file} ..."
        echo ""
        cp -pv "${CACHEDIR}/${BASENAME}" "${BASELINEDIR}/${BASENAME}"
        ls -la "${BASELINEDIR}/${BASENAME}" "${CACHEDIR}/${BASENAME}"
    else
        echo -n '.'
    fi

done

echo ""

