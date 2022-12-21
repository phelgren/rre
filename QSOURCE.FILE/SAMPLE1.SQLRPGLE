000001100419     H DFTACTGRP(*NO) ACTGRP(*NEW)
000100100419      *  Demonstration of creating a standard report in SQLRPG
000102100419      *
000103100419      * Basic demo to be used as a baseline for iText example
000105100419      *
000106100419      * Copyright 2010 Pete Helgren
000107100419      *                Value Added Software, Inc
000108100419      *                1511 East Harvard Ave
000109100419      *                Salt Lake City, UT 84105
000110100419      *                (801) 581-1154
000111100419      ********************************************************
000112100419     FOEMPRPT   O    E             PRINTER OFLIND(Overflow)
000113100419     D Overflow        s               n
000114100419     D SQLStmnt        S           2048A   Varying
000115100419     D PrepSQLGetRS    PR             5A
000116100419     D FetchNextRow    PR             5A
000117100419     D CloseSQLCursor  PR             5A
000118100419     D WriteLine       PR
000119100419     D WriteHeader     PR
000120100419     D SQLSuccess      S              5A   Inz('00000')
000122100419     C/free
000123100419
000124100419        // Prep the SQL statement
000125100419         If PrepSQLGetRS() = SQLSuccess;
000126100419            // Read the employee file
000127100419            WriteHeader();
000128100419            Dow FetchNextRow() = SQLSuccess;
000129100419               WriteLine();
000130100419            enddo;
000131100419            // Close the cursor opened in prep
000132100419            CloseSQLCursor();
000133100419          endif;
000134100419
000135100419          *inlr = *on;
000136100419      /end-free
000137100419     p*********************************************************
000138100419     p* Prepare and open the SQL Statement
000139100419     p*********************************************************
000140100419     P PrepSQLGetRS    B
000141100419     D PrepSQLGetRS    PI             5A
000142100419     D/free
000143100419       SQLStmnt = 'select ' +
000144100419        'emfnam || '' '' || substr(emmnam,1,1) || '' ''|| emlnam as ename, ' +
000145100419        'emadd1,emcity, emst, emzip1,emzip2 from employee ' +
000146100419        'order by emlnam,emfnam';
000147100419
000148100419       EXEC SQL
000149100419         PREPARE S1 FROM :SQLStmnt;
000150100419
000151100419       EXEC SQL
000152100419         DECLARE C1 CURSOR FOR S1;
000153100419
000154100419       EXEC SQL
000155100419         OPEN C1;
000156100419
000157100419         RETURN SQLSTT;
000158100419      /end-free
000159100419     P PrepSQLGetRS    E
000160100419     p*********************************************************
000161100419     p* Fetch a row at a time
000162100419     p*********************************************************
000163100419     P FetchNextRow    B
000164100419     D FetchNextRow    PI             5A
000165100419      /free
000166100419       EXEC SQL
000167100419        FETCH FROM C1 INTO :ename, :emadd1, :emcity, :emst, :emzip1, :emzip2 ;
000168100419
000169100419        RETURN SQLSTT;
000170100419      /end-free
000171100419     P FetchNextRow    E
000172100419     C*********************************************************
000173100419     C* Close the Open Cursor
000174100419     C*********************************************************
000175100419     P CloseSQLCursor  B
000176100419     D CloseSQLCursor  PI             5A
000177100419      /free
000178100419       EXEC SQL
000179100419        CLOSE C1;
000180100419
000181100419       RETURN SQLSTT;
000182100419      /end-free
000183100419     P CloseSQLCursor  E
000184100419     C*********************************************************
000185100419     C* Write the header
000186100419     C*********************************************************
000187100419     P WriteHeader     B
000188100419     D WriteHeader     PI
000189100419      /free
000190100419            write header;
000191100419      /end-free
000192100419     P WriteHeader     E
000193100419     C*********************************************************
000194100419     C* Write the detail
000195100419     C*********************************************************
000196100419     P WriteLine       B
000197100419     D WriteLine       PI
000198100419      /free
000199100419            write detail;
000200100419            if Overflow ;
000201100419               write header;
000202100419               reset Overflow;
000203100419            endif;
000204100419      /end-free
000205100419     P WriteLine       E
