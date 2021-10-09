     H DFTACTGRP(*NO)

     D putenv          PR            10i 0 extproc('putenv')
     D   envvar                        *   value options(*string)
     D InputString     S           3100A

     C     *ENTRY        PLIST
     C                   PARM                    InputString

      /free

        putenv(%TRIM(InputString));

        *inlr = *on;

      /end-free
