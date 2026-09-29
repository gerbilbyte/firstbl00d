# firstbl00d
A script to combine several AD commands to be run in one fell swoop.

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
```git clone https://github.com/gerbilbyte/firstbl00d.git```  
```cd firstbl00d```  
```chmod 755 firstbl00d.sh```  

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

