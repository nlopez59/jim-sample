      * This is a manually created map/CPYBk for IDz & vsCode
       01  DATMLISI.
           02  FILLER PIC X(12).
           02  HIL    COMP  PIC  S9(4).
           02  HIF    PICTURE X.
           02  FILLER REDEFINES HIF.
             03 HIA    PICTURE X.
           02  FILLER   PICTURE X(2).
           02  HII  PIC X(30).
       01  DATMLISO REDEFINES DATMLISI.
           02  FILLER PIC X(12).
           02  FILLER PICTURE X(3).
           02  HIC    PICTURE X.
           02  HIH    PICTURE X.
           02  HIO  PIC X(30).