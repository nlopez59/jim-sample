//IBMUSERD JOB CLASS=A,MSGCLASS=H,MSGLEVEL=(1,1),REGION=0M
//*
//* Debug demo for vsCode or IDz with CC RDS Mode
//* ---
//DBG    EXEC PGM=DATBATCH,PARM='1'
//* suppres WD PDS for now use DBB libs in Dev Env 
//*STEPLIB  DD  DISP=SHR,DSN=ZDEV.DEV.LOAD          PIPELINE WD LIB
//STEPLIB  DD  DISP=SHR,DSN=IBMUSER.ZBUILDER.LOAD   PIPELINE DBB LIB
//         DD  DISP=SHR,DSN=IBMUSER.VSCODE.LOAD     VSC USER BUILD LIB
//SYSOUT    DD  SYSOUT=*
//*
//* CC Mode 
//* https://www.ibm.com/docs/en/developer-for-zos/17.0.x?topic=applications-specifying-code-coverage-options-in-startup-key#tasktccstartup__context__1
//CEEOPTS DD *
TEST(,,,RDS:*)
ENVAR("EQA_STARTUP_KEY=CC,,e=PDF")
/*
//* OUTPUT IS IN /u/stcdbg/CC/IBMUSER/*.pdf


