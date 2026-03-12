#!/bin/sh
# Package & Publish dbb artifacts in Artifactory
## njl 2-26-26 mods - new localworkdir testing 

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
    ## The copy of LOAD modules are in binary which also supports load module "alias names" (CP -XI) as of zOS 2.4.
    ## This script also assigns the DBB artifact's Deploy Type to each file name as a file extension. 
    ## 
    ## For example, a load module named 'mypgm' tha calls DB2, will be assigned a Deploy Type of 'DBRM' by DBB. 
    ## This script appends the extension '.dbrm' to that file.  WD generate uses extensions as a 'type' property to  
    ## assign a building block actoions/steps like DB2 Bind or CICS newcopy.   

    ## Ref: https://www.ibm.com/docs/en/developer-for-zos/17.0?topic=deployment-static-python-translator
    

    prepare=$zScripts/util/dbb_prepare_local_folder.py
    ## echo [package.sh] Prepare Phase: DBB artifacts for $MyApp in DBB ciWorkDir $ciWorkDir  ...           
    ## python $prepare --dbbBuildResult $ciWorkDir/logs/BuildReport.json --workingFolder $ciWorkDir

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

    # Notes: Ensure there are no trailing blanks after the \                 
    # added load dir by prep step 
    
    # how to stage the tar for access in CI?

# v17 Notes: 
## WD supports NOT creating a jfrog build record by not providing a buildName. However that throws the following error:
##      File "<wazideploy-3.0.6.1>/wazideploy/package/artifactory_utilities.py", line 82, in upload
##      TypeError: can only concatenate str (not "NoneType") to str
#  So buildName is required for now.  
  

# Also, WD appends to the URL env var this path 'api/build' to create a build record.  
# HOwever the url env var must point to a valid project folder to avoid unauthorized errors.
 
# Append the app's project folder to the URL env as below (BTW - that was hard to do in the v16 config.yaml implementation but exposes pats)
# This is also compatible with WD Gen which expects an absolute URL path - without project folder (note the env end with a /)  

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
