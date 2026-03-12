# Wazi Deploy (WD) basics (ver 3.0.6.1 IDZee V17 & V16)

These notes describe how to configure and test a **simple Wazi Deploy model** using **static deployment mode**, **Python** to process artifacts built by **DBB zBuilder** and stored in **Artifactory**.

General Refs: 
   - https://www.ibm.com/docs/en/developer-for-zos/17.0.x?topic=deployment-static-python-translator 
   - https://www.ibm.com/docs/en/adffz/dbb/3.0.x?topic=zbuilder-key-concepts


## Flow
After a CI DBB build, the basic Wazi Deployment flow consists of these steps:
- CI - Package:  Prepare DBB build artifacts for publishing to Artifactory.
- CD - Generate: Download an artifact package by version # and create a deployment plan using a deployment-method template.
- CD - Deploy:   Deploy artifacts using a deployment plan and a target zOS environment file.  

---

## The Configuration
### Environment variables 
   - add the following to /etc/profile or .profile and change the values to reference your artifactory server url and acct. Note Nexus is also supported:
   ```
      export DEPLOY_ARTIFACT_REPOSITORY_TYPE="artifactory"
      export DEPLOY_ARTIFACT_REPOSITORY_URL="https://???.com:$PORT/artifactory/"
      export DEPLOY_ARTIFACT_REPOSITORY_USER="$Functional-User-Acct"
      export DEPLOY_ARTIFACT_REPOSITORY_PASSWORD=$Functional-User-TOKEN
      export DEPLOY_ARTIFACT_REPOSITORY_VERIFY="False"
   ```

 ### Config Files and Scripts 
 Wazi Deploy uses the configuration files below. They should be added to a git repo to centralize all Z DevOps configuration files like DBB zBuilder yaml files.  Lets call this repo zdevops.  

In your zdevops, create a folder called 'deploy' and add these files: 
   - [deployment-method.yml](./deploy-method.yml)
   - [Dev-zOS.env](./Dev-zOS.env)

   _Follow the instructions provided in each file._


In zdevops, add these files to a scripts folder: 
   - [dbb_prepare_local_folder.py](./sample-scripts/dbb_prepare_local_folder.py)  
   - [package.sh](./sample-scripts/package.sh) 

   _Dont forget to chmod 755 the scripts_

> _Note_: The **wazi-deploy package** command requires a pre-processor Python utility.  
> The **IDzEE V16** product guide provides the source for this utility, called **dbb_prepare_local_folder.py**.
>
> A sample **package.sh** script is provided to invoke the utility and run the **wazi-deploy package** command.
>
> In **IDzEE V17**, **DBB 3.0.4 zBuilder** introduces a new **package** step that can 
replace the Python utility and simplify the packaging step.

Also included in this sample is a [buildlist.txt](./ivp/buildlist.txt) file.    
Copy it to your 'zdevops/conf/deploy/ivp' directory and use it to test your configuration as described in the following section.

---

## Test your configuration 
The USS CLI cmds below will help you setup a simple test of your new configuration.   

1. **Refresh** your zdevops configuration files 

   Pull your zdevops repo onto it's central location on USS or a personal working dir for testing as defined by the $DBB_BUILD env var.  If its the first time, perform a clone instead of a pull. 

>   ``` cd zdevops; git pull; git status ```

2. **DBB build**

  In the **zDevOps** repository, there is typically a folder containing sample source code testing. Ideally, three types of programs should be included - a simple COBOL batch program, a COBOL batch program with **Db2**, a **CICS** program.
  
   Edit the [buildlist.txt](./ivp/buildlist.txt) file to match with source paths of your repo. Start with the simple COBOL batch program and then progress by adding the more complex examples.

   - Clone your zdevops repo into a USS temp folder  

>  ``` mkdir -p tmp/wd-test; cd tmp/wd-test; git clone --depth 1 git@github.com:nlopez59/zdevops.git ```
   
   - Run a DBB build

>  ```  cd tmp/wd-test-full/zdevops; dbb  build file conf/deploy/ivp/buildlist.txt -hlq IBMUSER.WDTEST2 ``` 

3. **Package and publish** 

The package script calls the prepare python utility and wazi-deploy package to tar and publish DBB artifact(s) in Artifactory. 

   Change ? vars to match your artifactory application dir name, the top level zdevops repo source folder name and a version # for the package. 
>  ``` zdevops/scripts/package.sh    tmp/wd-test/zdevops  ?artifactory_app_dir ?myRepoSourceDir ?aVer#;   ls -l  tmp/wd-test ```

 4. **Generate a deployment-plan**

 This command uses the deployment-method, and artifactory package url to generate a deployment plan.  Change the ? vars to march your env. 

>  ``` . /global/opt/pyenv/gdp/bin/activate; wazideploy-generate --deploymentMethod  tmp/wd-test/zdevops/conf/deploy/deploy-method.yml  --deploymentPlan  ?/u/ibmuser/tmp/wazi-AppPlan --packageInputFile ?https://eu.artifactory.swg-devops.com:443/artifactory/sys-dat-team-generic-local/wazi-deploy-packages/source/2000/ManiName.1.0.0.tar --packageOutputFile ?/u/ibmuser/tmp/package.tar --deploymentPlanReport ?/u/ibmuser/tmp/wd-test/zdevops/wazi-deploymentPlanReport-001 --workingFolder ?/u/ibmuser/tmp/wd-test; deactivate; ```

 5. **Deploy the artifacts**

  The final step is to deploy the artifacts based on the generated plan.
  The `-e` CLI variables show how application-specific variables can be passed to the deploy process, such as the default DBA package list.
  The `--envFile` option defines the system-specific settings used during deployment, including the target PDS libraries and other CICS and Db2 configuration values.

>  ``` . /global/opt/pyenv/gdp/bin/activate; wazideploy-deploy  -e 'app_pklist=?myColl' --deploymentPlan  ?/u/ibmuser/tmp/wazi-AppPlan   --packageInputFile  ?/u/ibmuser/tmp/package.tar  --envFile ?/u/ibmuser/zdevops/conf/deploy/Dev-zOS.env --evidencesFileName ?/u/ibmuser/tmp/wd-test/evidence.yaml    --workingFolder  ?/u/ibmuser/tmp/wd-test;  deactivate ```

---
Once the IVP test pass, use the above CLI cmds to model you CD pipeline.

--- 
old notes ??
Added a new  DBB DBRMP DeplyType to drive a separate plan bind - passed all tests
Files Impacted by this change:    
- dbb:  dbb-app.yaml     - new forfile rule to override the default dbrm deploytype($dp) in cobol.yaml
- dbb:  cobol.yaml       - and allow dev to override it for a plan bind in the dbrm DD 
- wd:   deployment Method - added support for pack vs plan and fix current bind action      
- wd:   dbb-packaging     - added support for new dp dbrmp V16 dbbd prepar py script       
- testing:                - see cong/deploy for readme and IVP    A
