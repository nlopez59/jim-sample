       IDENTIFICATION DIVISION.
       PROGRAM-ID. DB2PGM.
       ENVIRONMENT DIVISION.
       INPUT-OUTPUT SECTION.
       FILE-CONTROL.
       DATA DIVISION.


       WORKING-STORAGE SECTION.     

       01  WS-TIMESTAMP        PIC X(26).
       01  WS-TIMESTAMP-IND    PIC S9(4) COMP.
       01  WS-SQLCODE-DISP     PIC -999999.  
       
           EXEC SQL
               INCLUDE SQLCA
           END-EXEC.

       PROCEDURE DIVISION.    
           DISPLAY 'Demo Db2 Pgm bound as a plan v2'.

        
           EXEC SQL
               SELECT CURRENT TIMESTAMP
                 INTO :WS-TIMESTAMP :WS-TIMESTAMP-IND
               FROM SYSIBM.SYSDUMMY1
           END-EXEC.

           MOVE SQLCODE TO WS-SQLCODE-DISP

             IF SQLCODE = 0
               IF WS-TIMESTAMP-IND < 0
                  DISPLAY 'TIMESTAMP IS NULL'
               ELSE
                  DISPLAY 'TIMESTAMP = ' WS-TIMESTAMP
               END-IF
             END-IF

        
           DISPLAY 'End of DB2PGM.'
           STOP RUN.
