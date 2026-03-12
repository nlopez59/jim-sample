      ******************************************************************
      * DCLGEN TABLE(Q.ORG)                                            *
      *        LIBRARY(NLOPEZ.IDZ.COPY(ORG))                           *
      *        ACTION(REPLACE)                                         *
      *        LANGUAGE(COBOL)                                         *
      *        STRUCTURE(ORG)                                          *
      *        APOST                                                   *
      *        LABEL(YES)                                              *
      *        DBCSDELIM(NO)                                           *
      *        COLSUFFIX(YES)                                          *
      *        INDVAR(YES)                                             *
      * ... IS THE DCLGEN COMMAND THAT MADE THE FOLLOWING STATEMENTS   *
      ******************************************************************
           EXEC SQL DECLARE Q.ORG TABLE
           ( DEPTNUMB                       SMALLINT NOT NULL,
             DEPTNAME                       VARCHAR(14),
             MANAGER                        SMALLINT,
             DIVISION                       VARCHAR(10),
             LOCATION                       VARCHAR(13)
           ) END-EXEC.
      ******************************************************************
      * COBOL DECLARATION FOR TABLE Q.ORG                              *
      ******************************************************************
       01  ORG.
      *    *************************************************************
           10 DEPTNUMB             PIC S9(4) USAGE COMP.
      *    *************************************************************
           10 DEPTNAME.
              49 DEPTNAME-LEN      PIC S9(4) USAGE COMP.
              49 DEPTNAME-TEXT     PIC X(14).
      *    *************************************************************
           10 MANAGER              PIC S9(4) USAGE COMP.
      *    *************************************************************
           10 O_DIVISION.
              49 DIVISION-LEN      PIC S9(4) USAGE COMP.
              49 DIVISION-TEXT     PIC X(10).
      *    *************************************************************
           10 LOCATION.
              49 LOCATION-LEN      PIC S9(4) USAGE COMP.
              49 LOCATION-TEXT     PIC X(13).
      ******************************************************************
      * INDICATOR VARIABLE STRUCTURE                                   *
      ******************************************************************
       01  IORG.
           10 INDSTRUC           PIC S9(4) USAGE COMP OCCURS 5 TIMES.
      ******************************************************************
      * THE NUMBER OF COLUMNS DESCRIBED BY THIS DECLARATION IS 5       *
      ******************************************************************