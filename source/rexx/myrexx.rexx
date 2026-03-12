/* REXX EXEC to call a generic program with input and output datasets */


say "sample PreProc rexx ..."
/* Define dataset names */
inputDS  = "'USERID.INPUT.DATA'"
outputDS = "'USERID.OUTPUT.DATA'"
progName = "MYPGM"        /* Load module name, must be in STEPLIB or LINKLIST */

say "Allocating DDs..."
/* address TSO
*/
"ALLOC FI(INPUT)  DA("inputDS")  SHR REUSE"
"ALLOC FI(OUTPUT) DA("outputDS") SHR REUSE"

say "Calling program: " progName
address LINKPGM progName

rc = rc
say "Program returned RC="rc

say "Freeing DDs..."
"FREE FI(INPUT)"
"FREE FI(OUTPUT)"

exit rc









/* eof */