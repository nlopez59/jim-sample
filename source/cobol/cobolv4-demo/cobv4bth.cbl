       IDENTIFICATION DIVISION.  
       PROGRAM-ID. COBV4BTH.  
      * Batch Cobol ver4/DB2.                    
       ENVIRONMENT DIVISION.                                           
       DATA DIVISION.    
       WORKING-STORAGE SECTION.
           EXEC SQL INCLUDE ORG   END-EXEC.
           EXEC SQL INCLUDE SQLCA END-EXEC.
       PROCEDURE DIVISION.
           EXEC SQL
              SELECT DEPTNAME INTO :DEPTNAME
               FROM  Q.org
               WHERE DEPTNUMB = 15
           END-EXEC.
           DISPLAY 'COBV4BTCH - v3   '.
           DISPLAY 'Selected  Dept 10 from Org value=' DEPTNAME-TEXT.
           STOP RUN.           
                                                 
                                                                       