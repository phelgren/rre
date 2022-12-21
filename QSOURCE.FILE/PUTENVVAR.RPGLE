000100100424     H DFTACTGRP(*NO)
000101100424
000102100424     D putenv          PR            10i 0 extproc('putenv')
000103100424     D   envvar                        *   value options(*string)
000104100424     D InputString     S           3100A
000105100424
000106100424     C     *ENTRY        PLIST
000107100424     C                   PARM                    InputString
000108100424
000109100424      /free
000110100424
000111100424        putenv(%TRIM(InputString));
000125100424
000126100424        *inlr = *on;
000127100424
000128100424      /end-free
