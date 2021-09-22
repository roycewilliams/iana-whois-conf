#!/bin/bash
#-----------------------------------------------------------------------------
# get-iana-whois.sh
# Created: 2014-07-30
# Author: Royce Williams, royce@techsolvency.com
# Purpose: Download IANA HTML for all TLDs.
# License: Public domain
#-----------------------------------------------------------------------------

BASE_HOST=www.iana.org
BASE_URL="https://${BASE_HOST}"
BASE_DB_URL="${BASE_URL}/domains/root/db"
CACHE_DIR=./cache/

OS=$(uname -s)
ARCH=$(uname -m)
VER=$(uname -r)

#-----------------------------------------------------------------------------
# Fetch main DB page from IANA.
echo "- Fetching latest db.html ..."
wget --quiet -O db.html -N --no-check-certificate ${BASE_DB_URL}
echo "- Checking for differences from last db.html fetch ..."
diff -u db.html.baseline db.html

# Build URL list
FILE_LIST=$(egrep "/domains/root/db/.*.html" db.html | cut -d\" -f4)


echo "- Refreshing list of TLDs ..."
#echo "# TLD list derived from iana.org - $(date)" >tld.list.new
echo ""
for suburl in ${FILE_LIST}; do
    TLD=$(basename $suburl | cut -d\. -f1)
    echo ${TLD}
done | sort -u >tld.list
echo "- Record count:"
wc -l tld.list
echo ""
echo "- Sample of tld.list contents:"
head -n 5 tld.list
echo ""

echo "- Checking for tld.list diff vs baseline ..."
diff -u tld.list.baseline tld.list
echo ""


echo "- Fetching any new TLD pages ..."
echo "- (Note: iana.org HTTP server does not set Last-Modified headers)"
case ${OS} in
    FreeBSD)
        # Use cperciva's phttpget (HTTP 1.1 pipelining support).
        echo "Will try to fetch ${FILE_LIST}" ...
        /usr/libexec/phttpget ${BASE_HOST} ${FILE_LIST}
        ;;
    *)
        # TODO - move list processing outside of fetch loop
        # TODO - skip if already exists
        for suburl in ${FILE_LIST}; do
            TLD=$(basename $suburl | cut -d\. -f1)
            TLDFILE=cache/${TLD}.html
            if [ ! -f ${TLDFILE} ]; then
                echo ""
                pushd ${CACHE_DIR};
                wget -N -nd ${BASE_URL}/${suburl};
                popd
            else
                echo -n '.'
                #echo -n "${TLD} "
                #ls -la ${TLDFILE}
            fi
        done
        echo ""
        ;;
esac

echo ""
echo "- Note: To set tld.list baseline:"
echo "cp -p tld.list tld.list.baseline"
echo ""

echo "- Generate new whois config file with:"
echo "./build-whois.sh"
echo ""

#-----------------------------------------------------------------------------
