Run from USS CLI on my zOS env

:: seed/refresh my config files on USS 
  git clone --depth 1 git@github.com:nlopez59/zdevops.git
  :: or pull 
  cd zdevops; git pull; git status 


:: Clone test App - setup the app build test 
  rm -rf tmp/wd-test-full;  mkdir -p tmp/wd-test-full; cd tmp/wd-test-full; git clone --depth 1 git@github.com:nlopez59/zdevops.git; ls -l

:: DBB build   
  cd tmp/wd-test-full/zdevops; dbb  -DBB_DAEMON_PORT 8180   build file /u/ibmuser/zdevops/scripts/util/Wazi-Deploy-learn/buildlist.txt -hlq IBMUSER.WDFULL
  
:: WD pre-process, Package art's  and Publish  to artifactory  Build# 001 
  chmod 755 zdevops/scripts/util/*.sh
  zdevops/scripts/util/package-v17.sh    tmp/wd-test-full/zdevops  sys-dat-team-generic-local source 2000; ls -l  tmp/wd-test-full

:: Gen a plan   new DM for dbrmP NEED WORK  path ??? 
   . /global/opt/pyenv/gdp/bin/activate; wazideploy-generate --deploymentMethod  /u/ibmuser/zdevops/conf/deploy/deploy-method.yml  --deploymentPlan  /u/ibmuser/tmp/wazi-AppPlan-full --packageInputFile https://eu.artifactory.swg-devops.com:443/artifactory/sys-dat-team-generic-local/wazi-deploy-packages/source/2000/ManiName.1.0.0.tar --packageOutputFile /u/ibmuser/tmp/package-full.tar --deploymentPlanReport /u/ibmuser/tmp/wd-test-full/zdevops/wazi-deploymentPlanReport-001 --workingFolder /u/ibmuser/tmp/wd-test-full --logConfigFile /u/ibmuser/zdevops/conf/deploy/logging.yml; tar -tvf /u/ibmuser/tmp/package-full.tar; deactivate;
     

:: Deploy   All phases passed 
  . /global/opt/pyenv/gdp/bin/activate; wazideploy-deploy  -e 'app_pklist=myColl' --deploymentPlan  /u/ibmuser/tmp/wazi-AppPlan-full   --packageInputFile  /u/ibmuser/tmp/package-full.tar  --envFile /u/ibmuser/zdevops/conf/deploy/Dev-zOS.env --evidencesFileName /u/ibmuser/tmp/wd-test-full/evidence-full.yaml    --workingFolder  /u/ibmuser/tmp/wd-test-full;  deactivate


:: IVP  CMCI - CURL on USS.  passed
        
    curl -v -k -u ibmuser:jeep0924 -H 'Content-Type:application/json' -d "<request><action name='NEWCOPY'/></request>"   -X PUT "https://zos:8154/CICSSystemManagement/CICSProgram/CICSTS63?CRITERIA=(PROGRAM=EPSMLIS)"


    Sample response   ^^ are my marks for point of interest   1024 means OK!
    * upload completely sent off: 43 bytes
    < HTTP/1.1 200 OK
    < Cache-Control: no-store
    < Date: Mon, 09 Mar 2026 21:45:04 GMT
    < Server: IBM_CICS_Transaction_Server/6.3.0(zOS)
    < Content-Type: application/xml; charset=UTF-8
    < Transfer-Encoding: chunked
    <
    <?xml version="1.0" encoding="UTF-8"?>
    <response xmlns="http://www.ibm.com/xmlns/prod/CICS/smw2int" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" 
            xsi:schemaLocation="http://www.ibm.com/xmlns/prod/CICS/smw2int https://zos:8154/CICSSystemManagement/schema/CICSSystemManagement.xsd" version="3.0" connect_version="0630">
           
            <resultsummary api_response1="1024" api_response2="0" 
                 ^^       api_response1_alt="OK" 
                          api_response2_alt="" recordcount="1" displayed_recordcount="1" />
            <records>
                    <cicsprogram _keydata="C5D7E2D4D3C9E240" 
                    aloadtime="00:00:00.000000" apist="CICSAPI" application="" applmajorver="-1" applmicrover="-1" applminorver="-1" basdefinever="0" cedfstatus="NOTAPPLIC" changeagent="CSDBATCH" 
                    changeagrel="0760" changetime="2026-02-21T10:59:50.000000+00:00" changeusrid="IBMUSER" coboltype="NOTAPPLIC" concurrency="QUASIRENT" copy="NOTREQUIRED" currentloc="NOCOPY" 
                    datalocation="NOTAPPLIC" definesource="EPSMTM" definetime="2026-02-21T10:59:50.000000+00:00" dynamstatus="NOTDYNAMIC" entrypoint="FF000000" execkey="NOTAPPLIC" 
                    executionset="NOTAPPLIC" eyu_cicsname="CICSTS63" eyu_cicsrel="E760" eyu_reserved="0" fetchcnt="0" fetchtime="00:00:00.000000" holdstatus="NOTAPPLIC" installagent="CSDAPI" 
                    installtime="2026-02-21T11:00:58.000000+00:00" installusrid="IBMUSER" jvmclass="" jvmserver="" language="NOTAPPLIC" length="2760" 
                ^^  library="EPSRPL" librarydsn="IBMUSER.VSCODE.LOAD" 
                    loadpoint="FF000000" lpastat="NOTAPPLIC" 
                ^^  newcopycnt="2" 
                    operation="" pgrjusecount="0" platform="" 
                ^^  program="EPSMLIS" progtype="MAP" 
                    remotename="" remotesystem="" removecnt="0" rescount="0" residency="NONRESIDENT" rloading="0.000" rplid="0" rremoval="0.000" runtime="NOTAPPLIC" ruse="0.000" sharestatus="PRIVATE" 
                    status="ENABLED" transid="" useagelstat="0" usecount="0" usefetch="0.000" />
            </records>
    </response>* Connection #0 to host zos:8154 left intact