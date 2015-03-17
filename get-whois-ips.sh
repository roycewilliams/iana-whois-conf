#!/bin/bash
#-----------------------------------------------------------------------
# get-whois-ips.sh
# Created: 2014-07-30
# Author: Royce Williams, royce@techsolvency.com
# Purpose: Generate list of WHOIS server IPs for whitelisting, etc.
# License: Public domain
#-----------------------------------------------------------------------

ipsort () { sort -t . -k 1,1n -k 2,2n -k 3,3n -k 4,4n $*; }

#-----------------------------------------------------------------------

for host in `cat list-superset.txt  | awk '{print $2}' | sort -u`; do 
    host -t A -4 $host 2>&1 | grep 'has address'; 
done | tee whois-ips-raw.txt

cat whois-ips-raw.txt | awk '{print $4}' | sort -u | ipsort >whois-ips-whitelist.txt 
wc -l whois-ips-whitelist.txt

#-----------------------------------------------------------------------
