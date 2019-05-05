#!/bin/bash

echo " - Setting baselines ..."
cp -pvr cache/                   cache.baseline/
cp -pv  db.html                  db.html.baseline
cp -pv  tld.list                 tld.list.baseline
cp -pv  whois.conf               whois.conf.baseline
cp -pv  whois-ips-raw.list       whois-ips-raw.list.baseline
cp -pv  whois-ips-whitelist.list whois-ips-whitelist.list.baseline

echo ""

