     H DFTACTGRP(*NO) ACTGRP(*NEW)
     H OPTION(*SRCSTMT: *NODEBUGIO: *NOSHOWCPY)
     H THREAD(*SERIALIZE)
     H BNDDIR('RRE_ITXT')

      /copy qsource,rre_h
      /copy qsource,rre_itxt_h
      *********************************************************
      *  Demonstration of creating an itext report in SQLRPG
      *
      * Basic demo to be used as iText example
      *
      * Copyright 2010 Pete Helgren
      *                Value Added Software, Inc
      *                1511 East Harvard Ave
      *                Salt Lake City, UT 84105
      *                (801) 581-1154
      ********************************************************
     D SQLStmnt        S           2048A   Varying
     D PrepSQLGetRS    PR             5A
     D FetchNextRow    PR             5A
     D CloseSQLCursor  PR             5A
     D WriteLine       PR
     D WriteHeader     PR
     D SQLSuccess      S              5A   Inz('00000')
     D  lHeading       s                   like(jString)
     D  lColumns       s                   like(jString)
     D  lFileName      s                   like(jString)
     D  iTextReport    s                   like(jReportView)
     D  lColView       s                   like(jReportColumnView)
     D  counter        S             10I 0

     D  ename          s             40A
     D  emadd1         s             30A
     D  emcity         s             25A
     D  emst           s              2A
     D  emzip1         S              5S 0
     D  emzip2         S              5S 0

     D colEmp          S                   like(jString)
     D colAddr         S                   like(jString)
     D colCity         S                   like(jString)
     D colState        S                   like(jString)
     D colZip1         S                   like(jString)
     D colZip2         S                   like(jString)
     D results         S               N
     D lRows           s             10I 0

     C/free
        rre_begin_object_group(16);
        // Initial Object creation
       lHeading =  new_String('Sample Report using iText and RPG');
       lColumns = new_jArrayList();
       lReportName = new_String('Sample iText Report (Sample 2) ');
       lFileName =  new_String('/reports/output/Sample_2_iText_Report.pdf');

       WriteHeader();

       iTextReport = new_RREReportView(lHeading:lColumns:lReportName:lFileName);

       rreRV_initialize(iTextReport); // Creates the report shell
       counter = 1;
        // Prep the SQL statement
         If PrepSQLGetRS() = SQLSuccess;
            // Read the employee file
            Dow FetchNextRow() = SQLSuccess;

               counter = counter + 1;

               WriteLine();

            enddo;
            // Close the cursor opened in prep
            CloseSQLCursor();
            lrows = rreRV_finalize(iTextReport:counter);
          endif;

        rre_end_object_group();

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
        // Not so much a write as it is a CREATE
        // Before creating the ReportView, add heading columns to the array
        // The pattern here is to construct and then add to the ArrayList
        //Column Headings MUST Total to 100%
        colEmp = new_String('Employee Name');
        colAddr= new_String('Address');
        colCity = new_String('City');
        colState= new_String('State');
        colZip1 = new_String('Zip');
        colZip2= new_String('Zip + 4');

        lColView = new_RREReportColumnView(colEmp:30);
          rre_jArrayList_add(lColumns:lColView);

        lColView = new_RREReportColumnView(colAddr:20);
          rre_jArrayList_add(lColumns:lColView);

        lColView = new_RREReportColumnView(colCity:20);
          rre_jArrayList_add(lColumns:lColView);

        lColView = new_RREReportColumnView(colState:10);
          rre_jArrayList_add(lColumns:lColView);

        lColView = new_RREReportColumnView(colZip1:10);
          rre_jArrayList_add(lColumns:lColView);

        lColView = new_RREReportColumnView(colZip2:10);
          rre_jArrayList_add(lColumns:lColView);

      /end-free
     P WriteHeader     E
     C*********************************************************
     C* Write the detail
     C*********************************************************
     P WriteLine       B
     D WriteLine       PI
      /free
        if %REM(counter: 2) = 1;
             RRERV_SetGrayFill(iTextReport:.9);
        endif;

         rreRV_addCell(iTextReport:ename);
         rreRV_addCell(iTextReport:emadd1);
         rreRV_addCell(iTextReport:emcity);
         rreRV_addCell(iTextReport:emst);
         rreRV_addCell(iTextReport:%char(emzip1));
         rreRV_addCell(iTextReport:%char(emzip2));

        if %REM(counter: 2) = 1;
             RRERV_SetGrayFill(iTextReport:1);
        endif;

      /end-free
     P WriteLine       E
