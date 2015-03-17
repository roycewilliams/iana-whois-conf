#!/bin/bash

# get-iana-whois.sh
# Created: 2014-07-30
# Author: Royce Williams, royce@techsolvency.com
# Purpose: Download IANA HTML for all TLDs.
# License: Public domain

BASE_HOST=www.iana.org
BASE_URL="https://${BASE_HOST}"
BASE_DB_URL="${BASE_URL}/domains/root/db"

# Fetch main DB page from IANA.
# Will save old copies.
wget --no-clobber --no-check-certificate ${BASE_DB_URL}

# Build URL list
FILE_LIST=`egrep "/domains/root/db/.*.html" db | cut -d\" -f4`

OS=$(uname -s)
ARCH=$(uname -m)
VER=$(uname -r)

case ${OS} in
    FreeBSD)
        # Use cperciva's phttpget (HTTP 1.1 pipelining support).
        echo "Will try to fetch ${FILE_LIST}" ...
        /usr/libexec/phttpget ${BASE_HOST} ${FILE_LIST}
        ;;
    *)
        for suburl in `egrep "/domains/root/db/.*.html" db | cut -d\" -f4`; do
            wget -nd ${BASE_URL}/${suburl}
        done
        ;;
esac

