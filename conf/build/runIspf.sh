#!/bin/sh

echo "[runIspf.sh] Started v2"
#---
# njl mod - fixed shebang - no space after the !
## My ISPZXENV defines the steplib to DB2 loadlib on in my system. It allows DBB language steps with TSO or ISPF step types to invoke db2-based processes. 
## My conf path is added to $DBB_CONF before calling this script. 

## Notes: 
##    - VS Code sets the wkdir to the repo's root folder. This CD allows the ISPZXMF to pick up my version of the ISPXENV rexx exec. 
##    - When using the DBB Daemon, its uses the /etc/profileDBB_HOME and DBB_CONF.  
###      But runs under its home! And its does not pickup etc/profile!
##  
echo "[runIspf.sh-mod] setup"
set -x 
. /etc/profile
## This script also includes IHS and ISPF bins path used but the ISP GW and missing in /etc/profile.
export PATH=/usr/lpp/ihsa_zos/bin:$PATH:/usr/lpp/ispf/bin:$PATH


cd $DBB_CONF
pwd 


echo "[runIspf.sh-mod] chmod +x ISP * SH files "
chmod +x $DBB_CONF/ISP* 
chmod +x $DBB_CONF/*.sh 
ls -lasT

echo "[runIspf.sh-mod]  INPUT_FILE=" $1
cat $1

echo "[runIspf.sh-mod] calling ISPZXML with above input file"
#--- 

cat $1 | ISPZXML

#set 

echo "[runIspf.sh-mod] Return from ISPZXML RC" $?