# NTDS.d1t_3xtr-ct0r
A program to install necessary tool to extract and crack NTDS.dit hash file. For this to work you must know the Metasploit option of; RHOST, SMBDomain, SMBUser and SMBPass details for the Admin user.

TESTED ON WINDOWS SERVER 2012R2 VIRTUAL MACHINE

# Usage
git clone https://github.com/BrandedCha0s/NTDS.d1t_3xtr-ct0r.git

cd NTDS.d1t_3xtr-ct0r

chmod +x Extractor.sh

./Extractor.sh

# Tools Needed

To successfully crack .dit and .bin files with this script the following tools must be installed.

John (Hash Cracker)

Metasploit (Optional; Other methods of obtaining the .dit & .bin files can be used)

#Changelog

v1.0: initial release
v1.1: Added output and installed tools check.

