       ID DIVISION.
       PROGRAM-ID. DATBATCH.
       ENVIRONMENT DIVISION.
       DATA DIVISION.
       WORKING-STORAGE SECTION.
      * This program accepts a parm via JCL and passes it to a
      * subprogram DATSUB (API) which returns a result simulating some 
      * business rule. This is used to demonstrate how TAZ/EDT 
      * record and replay work in VS Code and Pipelines. 

      * Setup the sub pgm(api) as a dynamic call    v2.0.3-v6 WD ON'
       01 WS-SUBPGM  PIC X(8) VALUE 'DATSUB'.

       COPY DATVARS.

      * EDT recordings capture the linkage section of APIS. This  
      * includes Batch PARM areas used in JCL. EDT's Validation Type 
      * "PROGRAM" records this area to create a default assertion.
       LINKAGE SECTION.
       01  LK-PARM.
           05 LK-PARM-LEN  PIC S9(4)  COMP.
           05 LK-PARM-TEXT PIC X(1)  VALUE SPACES.

       PROCEDURE DIVISION USING LK-PARM.      
           IF LK-PARM-LEN = 1  Move LK-PARM-TEXT  TO WS-API-RULE-IN. 


      * A COBOL Display sends text output to the SYSOUT DD in the JCL
           Display 'DATBATCH - Started. JCL Parm-in >'LK-PARM-TEXT'<'.
                  
      
      * Break TC01: Change the API Input data to simulate how a 
      * programming error would cause an prior recorded test to fail.

      *     Move 8 to WS-API-RULE-IN.

           Display 'DATBATCH - DYN-Call to ' WS-SUBPGM ' using:'.           
           Display '  WS-API-RULE-IN     >'WS-API-RULE-IN'<'.
           Display '  WS-API-RESP=OUT    >'WS-API-RESP-OUT'<'.
           Display ' '.
           
                     
      * Note: TAZ/EDT replay does not really call api`s.  Instead it 
      * intercepts calls in real-time and passes inputs(mock) data 
      * and asserting(compare) outputs(? what output?)
      * as recorded in the pgms .zdata
      * or manually defined in its .ztest file.  
      
           CALL WS-SUBPGM USING WS-API-PARAMETERS.           
           
      * This seems to break EDT? 
      *     Move 'BREAK'  TO  WS-API-RESP-OUT
      *    

           Display ' '.
           Display 'DATBATCH - COMM area and RC after call:'.
           Display '  WS-API-RULE-IN     >'WS-API-RULE-IN'<'.
           Display '  WS-API-RESP-OUT    >'WS-API-RESP-OUT'<'.
           Display '  RETURN-CODE        >'RETURN-CODE'<'.                  
                

      * break test- chg the lk-text to some value 
      * assume recording captured this value 
      *    Move 'BREAK' TO LK-PARM-TEXT.

           Display ' '.
           Display 'DATBATCH - Ended'.
           STOP RUN.













      * Ref Notes:
      * Shared copybooks are defined in:
      *  zBuilder conf/build/dbb-build.yaml start task      sourceDirs:
      *  zBuilder conf/build/Cobol.yaml           dependencySearchPath:
      *  vsCode IBM Open Editor zapp.yaml for each repo propertyGroups:
      *  NOTE: when chg's build options use Full Upload OpenEd opt
      *COPY datshare.
      *     DISPLAY shared-f1.
