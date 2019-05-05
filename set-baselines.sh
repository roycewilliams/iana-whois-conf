#!/bin/bash

echo "Setting baselines ..."

for file in db.html tld.list whois.conf whois-ips-raw.list whois-ips-whitelist.list; do

    echo "- Baselining ${file} ..."

    diff -u ${file}.baseline ${file}

    cp -pv  ${file}.baseline ${file}

    ls -la ${file}.baseline ${file}

    echo ""

done

echo ""

