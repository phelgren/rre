     H DFTACTGRP(*NO) ACTGRP(*NEW)
      *  Demonstration of creating a standard report in SQLRPG
      *
      * Basic demo to be used as a baseline for iText example
      *
      * Copyright 2010 Pete Helgren
      *                Value Added Software, Inc
      *                1511 East Harvard Ave
      *                Salt Lake City, UT 84105
      *                (801) 581-1154
      ********************************************************
     FOEMPRPT   O    E             PRINTER OFLIND(Overflow)
     D Overflow        s               n
     D SQLStmnt        S           2048A   Varying
     D PrepSQLGetRS    PR             5A
     D FetchNextRow    PR             5A
     D CloseSQLCursor  PR             5A
     D WriteLine       PR
     D WriteHeader     PR
     D SQLSuccess      S              5A   Inz('00000')
     C/free

        // Prep the SQL statement
         If PrepSQLGetRS() = SQLSuccess;
            // Read the employee file
            WriteHeader();
            Dow FetchNextRow() = SQLSuccess;
               WriteLine();
            enddo;
            // Close the cursor opened in prep
            CloseSQLCursor();
          endif;

          *inlr = *on;
      /end-free
     p*********************************************************
     p* Prepare and open the SQL Statement
     p*********************************************************
     P PrepSQLGetRS    B
     D PrepSQLGetRS    PI             5A
     D/free
       SQLStmnt = 'select ' +
        'emfnam || '' '' || substr(emmnam,1,1) || '' ''|| emlnam as ename, ' +
        'emadd1,emcity, emst, emzip1,emzip2 from employee ' +
        'order by emlnam,emfnam';

       EXEC SQL
         PREPARE S1 FROM :SQLStmnt;

       EXEC SQL
         DECLARE C1 CURSOR FOR S1;

       EXEC SQL
         OPEN C1;

         RETURN SQLSTT;
      /end-free
     P PrepSQLGetRS    E
     p*********************************************************
     p* Fetch a row at a time
     p*********************************************************
     P FetchNextRow    B
     D FetchNextRow    PI             5A
      /free
       EXEC SQL
        FETCH FROM C1 INTO :ename, :emadd1, :emcity, :emst, :emzip1, :emzip2 ;

        RETURN SQLSTT;
      /end-free
     P FetchNextRow    E
     C*********************************************************
     C* Close the Open Cursor
     C*********************************************************
     P CloseSQLCursor  B
     D CloseSQLCursor  PI             5A
      /free
       EXEC SQL
        CLOSE C1;

       RETURN SQLSTT;
      /end-free
     P CloseSQLCursor  E
     C*********************************************************
     C* Write the header
     C*********************************************************
     P WriteHeader     B
     D WriteHeader     PI
      /free
            write header;
      /end-free
     P WriteHeader     E
     C*********************************************************
     C* Write the detail
     C*********************************************************
     P WriteLine       B
     D WriteLine       PI
      /free
            write detail;
            if Overflow ;
               write header;
               reset Overflow;
            endif;
      /end-free
     P WriteLine       E
