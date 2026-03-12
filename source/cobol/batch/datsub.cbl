       IDENTIFICATION DIVISION.
       PROGRAM-ID. DATSUB.
       DATA DIVISION.

      * API Linkage section is the area captured by EDT recordings. 
       LINKAGE SECTION.
       COPY DATVARS.


       PROCEDURE DIVISION USING WS-API-PARAMETERS.
       MAINLINE.
           
           Display 'DATSUB - Started. Input Linkage Section:'
           Display '  WS-API-RULE-IN     >'WS-API-RULE-IN'<'.
           Display '  WS-API-RESP-OUT    >'WS-API-RESP-OUT'<'.
           

      * Simplified Business logic section 
           EVALUATE WS-API-RULE-IN              
              WHEN '1'     PERFORM RULE-1-Get-Date
              WHEN '2'     PERFORM RULE-2-Check-Acct
              WHEN OTHER   PERFORM NON-SUPPORTED-RULE
           END-EVALUATE.


           Display 'DATSUB - Ended. RC and Ouptut Linkage Section:' 
           Display '  WS-API-RULE-IN     >'WS-API-RULE-IN'<'.
           Display '  WS-API-RESP-OUT    >'WS-API-RESP-OUT'<'.
           Display '  RETURN-CODE        >'RETURN-CODE'<'.    

           GOBACK.  
    
      *
       RULE-1-Get-Date.
           MOVE FUNCTION CURRENT-DATE TO WS-API-RESP-OUT.
           MOVE 0  TO RETURN-CODE. 

       RULE-2-Check-Acct.
           MOVE 'ACCT is Active' TO WS-API-RESP-OUT.
           MOVE 0  TO RETURN-CODE.            
     
      *
       NON-SUPPORTED-RULE.
           MOVE 'ERROR-998: Non-Supported-Rule!' TO WS-API-RESP-OUT.
           MOVE 12  TO RETURN-CODE.  

      