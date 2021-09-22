#!/bin/bash

# build-whois.sh
# Created: 2014-07-30
# Author: Royce Williams, royce@techsolvency.com
# Purpose: Build whois.conf from downloaded IANA HTML.
# License: Public domain

echo "- Building whois.conf ..."

for item in $(ls cache/*.html | sed 's/\.html//g;s~cache/~~g'); do
    MYWHOIS=$(egrep -i 'Whois Server' cache/${item}.html | cut -d\> -f3)
    if [ -n "${MYWHOIS}" ]; then
        echo "\.${item}\$${MYWHOIS}"
    fi
done > whois.conf

wc -l whois.conf
echo ""

echo "- Checking for differences from baseline ..."
diff whois.conf.baseline whois.conf
echo ""
echo "- To set baseline:"
echo "cp -p whois.conf whois.conf.baseline"
echo ""

echo "- Building jwhois.conf ..."
cat whois.conf | sed 's~\\~\\\\~g;s/ /" = "/g;s/$/"/g;s/^/"/g' > jwhois.conf
wc -l jwhois.conf
echo ""

echo "- Checking for differences from baseline ..."
diff jwhois.conf.baseline jwhois.conf
echo ""
echo "- To set baseline:"
echo "cp -p jwhois.conf jwhois.conf.baseline"
echo ""
