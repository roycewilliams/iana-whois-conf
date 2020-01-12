iana-whois-conf
==============

This is an ugly hack to harvest the official list of WHOIS servers from IANA for all TLDs, and build a unified whois.conf, inspired by [this SuperUser question](http://superuser.com/questions/758647), which was prompted by the recent huge surge in new non-country TLDs.

It's also a convenience repository to hold the data when I run the script myself once in a while (the `*.baseline` files, especially `whois.conf.baseline`).

Be nice
-------

Be polite - don't run this too often (once a month is probably fine). TLDs are released or changed infrequently (though more frequently than they used to be!). Unfortunately, since at this writing the iana.org web server doesn't send Last-Modified headers, there's no way to be automatically more polite.

Share. Let me know when you notice a significant change.

[This question](http://superuser.com/questions/758647) used to have the entire list, but someone decided that an answer to the question was dynamic enough that it probably shouldn't be maintained in a Stack Exchange answer (which is somewhat fair).

**Please only send pull requests for the scripts - not for the data (updates to the cache or the baselines, etc.)** Run the scripts themselves for your own updates. That being said, I pushed the baselines for general use and for people who can't run these scripts themselves for some reason, so if I'm being lazy and haven't updated in a while, ping me at royce@techsolvency.com, and I'll update when I can.

Howto
----

1. Run `get-iana-whois.sh`

This will download IANA's master list of TLDs, and then download the page for each one.  I pull the entire page to enable other kinds of analysis, but it's overkill for this purpose.

2. Run `build-whois.sh`

This generates output in `whois.conf` and `jwhois.conf`-compatible syntax.

3. Optionally run `get-whois-ips.sh`

This bonus script builds a current list of IPs used by the WHOIS servers (so that you can add them to outbound IP whitelists on your firewall, etc.)

4. Set baseline files as needed.

These *scripts* do not presume to know when you want to set your baseline files. You can set them in bulk with `./set-baselines.sh`.

However, this *repo* also serves as a way for me to publish my own baselines for public reference. This should probably be separated out into a `.local` concept.

Notes
-----
Some domains appear to have lost their WHOIS for some reason over time.  I have not had time to investigate why for each one, so I just keep the old ones by using  `sdiff -o mergedfile oldfile newfile`.

It would be really great if IANA would publish a current whois.conf themselves.

Note that de-facto TLDs - where users can register names, but it's more than one level deep (.co.uk, etc.) - are not currently included. Eventually, I'd like to bring in info from [the Public Suffix List](https://publicsuffix.org/) and merge known WHOIS info for those as well. The `whois.conf` and `jwhois.conf` files in various distros already include some of these.

Example
-------

Here's an example of a run where only one new TLD (.irish) was found.

```
$ ./get-iana-whois.sh
- Fetching latest db.html ...
- Checking for differences from last db.html fetch ...
--- db.html.baseline	2019-05-05 09:52:03.747642612 -0800
+++ db.html	2019-05-05 09:52:45.883541561 -0800
@@ -5868,6 +5868,15 @@
     <tr>
         <td>

+            <span class="domain tld"><a href="/domains/root/db/irish.html">.irish</a></span></td>
+
+        <td>generic</td>
+        <td>Binky Moon, LLC</td>
+    </tr>
+
+    <tr>
+        <td>
+
             <span class="domain tld"><a href="/domains/root/db/is.html">.is</a></span></td>

         <td>country-code</td>
- Refreshing list of TLDs ...

- Record count:
1578 tld.list

- Sample of tld.list contents:
aaa
aarp
abarth
abb
abbott

- Checking for tld.list diff vs baseline ...
--- tld.list.baseline	2019-05-05 09:52:16.679611596 -0800
+++ tld.list	2019-05-05 09:52:48.207535987 -0800
@@ -641,6 +641,7 @@
 ipiranga
 iq
 ir
+irish
 is
 iselect
 ismaili

- Fetching any new TLD pages ...
- (Note: iana.org HTTP server does not set Last-Modified headers)
................................................................
[snip]

- Note: To set tld.list baseline:
cp -p tld.list tld.list.baseline

- Generate new whois config file with:
./build-whois.sh


$ ./build-whois.sh
- Building whois.conf ...
1209 whois.conf

- Checking for differences from baseline ...
499a500
> \.irish$ whois.nic.irish

- To set baseline:
cp -p whois.conf whois.conf.baseline

- Building jwhois.conf ...
1209 jwhois.conf

- Checking for differences from baseline ...
499a500
> "\\.irish$" = "whois.nic.irish"

- To set baseline:
cp -p jwhois.conf jwhois.conf.baseline

```
