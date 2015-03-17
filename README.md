iana-whois-conf
==============

This is an ugly hack to harvest the official list of WHOIS servers from IANA for all TLDs, and build a unified whois.conf, inspired by [this SuperUser question](http://superuser.com/questions/758647).

Be nice
-------

Be polite - don't run this very often. TLDs are released or changed infrequently.

Share. Update [the question](http://superuser.com/questions/758647) if you notice a significant change.

Howto
----

1. Run `get-iana-whois.sh`. 

This will download IANA's master list of TLDs, and then download the page for each one.  I pull the entire page to enable other kinds of analysis, but it's overkill.

2. Run `build-whois.sh`

This generates `whois.conf`.

Notes
-----
Some domains appear to have lost their WHOIS for some reason over time.  I have not had time to investigate why for each one, so I just keep the old ones by using  `sdiff -o mergedfile oldfile newfile`.

To format for SuperUser formatting (shift over by 4 for pre-formatted text), use `cat list-superset.txt | sed 's/^/    /g'`

