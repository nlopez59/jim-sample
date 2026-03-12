* This sample demonstrates how IBM's  OpenEdit and DBB process hlasm 
* source.  Definitions in zapp.yaml and DBB Assembler.yaml  define 
* HLASM copy files and user written macros.  As well as the hover over 
* option for system level macros like WTO.

MYWTO    CSECT   *                  Demo by Nelson Lopez 
         PRINT NOGEN   

         COPY  myRegs               * my copy code 
         
         USING MYWTO,R15
         STM   R14,R12,12(R13)

Start    EQU   *

* Note: Make sure the macro has no parse errors and the ext is defined
*       in "zopeneditor.datasets.hlasmDatasets" and dbb 

         mymac R5,=F'0922'           * my local macro

         WTO   'IBM DevOps Sample v3'

End      LM    R14,R12,12(R13)         
         BR    R14           
   
**  Working Storage area 
         DS    0D              
WORKAREA DS    D        
         END
