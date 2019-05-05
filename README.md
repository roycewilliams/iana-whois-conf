iana-whois-conf
==============

This is an ugly hack to harvest the official list of WHOIS servers from IANA for all TLDs, and build a unified whois.conf, inspired by [this SuperUser question](http://superuser.com/questions/758647).

Be nice
-------

Be polite - don't run this too often. TLDs are released or changed infrequently (though more frequently than they used to be!)

Share. Let me know you notice a significant change.

[This question](http://superuser.com/questions/758647) used to have the entire list, but someone decided that an answer to the question was dynamic enough that it probably shouldn't be maintained in a Stack Exchange answer (which is somewhat fair).

Howto
----

1. Run `get-iana-whois.sh`

This will download IANA's master list of TLDs, and then download the page for each one.  I pull the entire page to enable other kinds of analysis, but it's overkill for this purpose.

2. Run `build-whois.sh`

This generates `whois.conf`.

3. Set baseline files as needed.

This script doesn't presume to know when you want to set your baseline files.

You can set them in buld with `./set-baselines.sh`.

Notes
-----
Some domains appear to have lost their WHOIS for some reason over time.  I have not had time to investigate why for each one, so I just keep the old ones by using  `sdiff -o mergedfile oldfile newfile`.

To format for SuperUser formatting (shift over by 4 for pre-formatted text), use `sed 's/^/    /g' whois.conf`

It would be really great if IANA would publish a current whois.conf themselves.

Bonus script `get-whois-ips` builds a current list of IPs used by the WHOIS servers, so that you can add them to outbound IP whitelists on your firewall, etc.

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
