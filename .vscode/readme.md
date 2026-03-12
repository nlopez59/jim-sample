updates 2/2026 (IBM/NJL) 
---

settings.json is used by VS Code to configure certain features and tools
You can define these setting in 3 locations with the followign concatenation order: 
1️⃣ User settings (settings.json)
Applies everywhere, all projects

2️⃣ Workspace settings (.vscode/settings.json)
Overrides user settings for that workspace only

3️⃣ Workspace folder settings (multi-root workspaces)
Overrides both user + workspace

--- 

This demo repo is designed to define all common team vars in the workspace settings to show how they can be easily shared across the dev team. 

Personal settings like MVS HLQ and working dirs should be in the User Settings!
However, this example workspace includes them for demo purposed only.  
!During configuration, move the entries shown below from the workspace settings file to your user settings. Its a move not a copy!


dbbHLQ  is used to allocate persoanl PDS for user builds. 
dbbWorkspace and logDirt are paths under the user USS home folder.  
dbbDefaultZappProfile points to the zapp.yaml profile used during dbb user builds 

    "zopeneditor.userbuild.userSettings": {
      "dbbWorkspace": "/u/ibmuser/dbb_stageGit_zwksp",
      "dbbLogDir": "/u/ibmuser/dbb_stageGit_zwksp",
      "dbbHlq": "IBMUSER.VSCODE",
      "dbbDefaultZappProfile": "dbb-userbuild"       
    },