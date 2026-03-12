000100 ID DIVISION.     
      * ZCODESCAN RULES FOR THE PGM NAME IN EFFECT
      * SEE conf\openEditor\zcodescan\sam-rules.yaml
      * RENAME THE RULES SAM-RULES-HOLD FILE TO DISABLE
      * RULES ARE NAME CAN BE GREATER THAN 4 BYTE AND MUST          
      * START WITH SAM                                    
000200 PROGRAM-ID. ASAMPLE.
000300 ENVIRONMENT DIVISION.                              
000400 DATA DIVISION.                                     
000500 WORKING-STORAGE SECTION.   
      * 
000600 COPY DATVARS.                                      
000700 PROCEDURE DIVISION.                                
000800
000900     DISPLAY 'Demo Z Devops demo v9-2 test'            
001000     STOP RUN.   