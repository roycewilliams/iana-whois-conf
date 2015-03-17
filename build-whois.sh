#!/bin/bash

# build-whois.sh
# Created: 2014-07-30
# Author: Royce Williams, royce@techsolvency.com
# Purpose: Build whois.conf from downloaded IANA HTML.
# License: Public domain

for item in `ls *.html | sed 's/\.html//g'`; do
    MYWHOIS=`egrep -i 'Whois Server' ${item}.html | cut -d\> -f3`
    if [ -n "${MYWHOIS}" ]; then
        echo "\.${item}\$${MYWHOIS}"
    fi
done | tee whois.conf
