#!/bin/sh
# Package & Publish dbb artifacts in Artifactory
## njl 2-26-26 mods - adapted new localworkdir  and DBRMP type

 echo Wazi-Deploy: [package.sh] started v17a  ciWorkDir:$1  MyArtRepo:$2  MyApp:$3  buildID:$4

##
# Check for required Env Vars (just one) (stored in /etc/profile)
    if [ -z "$DEPLOY_ARTIFACT_REPOSITORY_URL" ]; then
      echo "[package.sh] ERROR: The require env var DEPLOY_ARTIFACT_REPOSITORY_URL is not defined. Check /etc/profile or .profile"
      exit 1
    fi


# Script vars:    
    ## args passed from pipeline. ciWorkDir is the DBB folder with the results of the build     
    ciWorkDir=$1    
    MyArtRepo=$2
    MyApp=$3
    buildID=$4

    # make a working dir with the buildID - this is a transient dir 
    ciWorkDir_wd=$ciWorkDir"_waziPackage_buildID_$buildID"
    mkdir -p $ciWorkDir_wd

    
##
# Prepare Phase:     
    ## In this phase, each artifact in DBB's BuildReport is copied from DBB's PDS(s) to a working USS dir in binary or text mode.     
    ## This script also assigns the DBB artifact's Deploy Type to each file name as a file extension. 
    
    prepare=zdevops/scripts/dbb_prepare_local_folder.py
    echo [package.sh v2] Prepare Phase: DBB artifacts for $MyApp in DBB ciWorkDir $ciWorkDir_wd  ...           
    python $prepare --dbbBuildResult $ciWorkDir/logs/BuildReport.json --workingFolder $ciWorkDir_wd



##
# Package and Publish Phase:
# ref: https://www.ibm.com/docs/en/developer-for-zos/17.0?topic=commands-wazi-deploy-packager-command
    # Notes: 
    # Inputs         
        ## --localFolder        Transient workdir above 
        ## /etc/profile         a set of WD Env vars   (See above ref)

        ## These args are used to construct an Artifactory path where the tar file/package is published
        ## --buildName          a top level artifactory folder passed from $arg2 (ie sys-dat-team-generic-local)
        ## --repository         a subfolder hardcoded  (wazi-deploy-packages)        
        ## --buildNumber        a subfolder using the pipeline buildID for traceability   
        
        ## --manifestName       a hardcoded tar file name   
        ## --manifestVersion    a hardcode ver of the tar file 

    # Outputs
        ## A tar file in a default published to Artifactory  
        ## ie - https://eu.artifactory.swg-devops.com/artifactory/sys-dat-team-generic-local/wazi-deploy-packages/source/336/ManiName.1.0.0.tar
        ## A manifest
    
    echo [package.sh] Package Phase:  Package and Publish DBB artifacts with build# $buildID in Artifactory using Env Vars ...
    . /global/opt/pyenv/gdp/bin/activate 

    DEPLOY_ARTIFACT_REPOSITORY_URL=$DEPLOY_ARTIFACT_REPOSITORY_URL$MyArtRepo

#  
##. . . Remove all trailing spaces after the \
## 

     wazideploy-package\
        --uploadType        archive\
        --repository        "wazi-deploy-packages"\
        --buildName         $MyApp\
        --buildNumber       $buildID\
        --manifestName      "ManiName"\
        --manifestVersion   "1.0.0"\
        --localFolder       $ciWorkDir_wd\
        --manifest          ./wazideploy_manifest.yml
