#!/bin/bash
#-----------------------------------------------------------------------
# get-whois-ips.sh
# Created: 2014-07-30
# Author: Royce Williams, royce@techsolvency.com
# Purpose: Generate list of WHOIS server IPs for whitelisting, etc.
# License: Public domain
#-----------------------------------------------------------------------

ipsort () { sort -t . -k 1,1n -k 2,2n -k 3,3n -k 4,4n $*; }

# Set this to a specific nameserver if needed.
#NAMESERVER=8.8.8.8
#NAMESERVER=1.1.1.1
NAMESERVER=

#-----------------------------------------------------------------------

for host in $(awk '{print $2}' whois.conf | sort -u); do
    MYIPS=$(host -t A -4 $host "${NAMESERVER}" 2>&1 | grep 'has address' | awk '{print $4}')
    for ip in ${MYIPS}; do
        echo "$host ${ip}"
    done
done | tee whois-ips-raw.list
wc -l whois-ips-raw.list
diff -u whois-ips-raw.list.baseline whois-ips-raw.list

awk '{print $2}' whois-ips-raw.list| sort -u | ipsort >whois-ips-whitelist.list
wc -l whois-ips-whitelist.list
diff -u whois-ips-whitelist.list.baseline whois-ips-whitelist.list
echo "To commit:"
echo cp -p whois-ips-whitelist.list whois-ips-whitelist.list.baseline

#-----------------------------------------------------------------------
