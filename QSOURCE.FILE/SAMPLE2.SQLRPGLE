000001100419     H DFTACTGRP(*NO) ACTGRP(*NEW)
000003100419     H OPTION(*SRCSTMT: *NODEBUGIO: *NOSHOWCPY)
000004100419     H THREAD(*SERIALIZE)
000005100419     H BNDDIR('RRE_ITXT')
000006100419
000007100419      /copy qsource,rre_h
000008100419      /copy qsource,rre_itxt_h
000009100419      *********************************************************
000100100419      *  Demonstration of creating an itext report in SQLRPG
000102100419      *
000103100419      * Basic demo to be used as iText example
000105100419      *
000106100419      * Copyright 2010 Pete Helgren
000107100419      *                Value Added Software, Inc
000108100419      *                1511 East Harvard Ave
000109100419      *                Salt Lake City, UT 84105
000110100419      *                (801) 581-1154
000111100419      ********************************************************
000114100419     D SQLStmnt        S           2048A   Varying
000115100419     D PrepSQLGetRS    PR             5A
000116100419     D FetchNextRow    PR             5A
000117100419     D CloseSQLCursor  PR             5A
000118100419     D WriteLine       PR
000119100419     D WriteHeader     PR
000120100419     D SQLSuccess      S              5A   Inz('00000')
000121100419     D  lHeading       s                   like(jString)
000122100419     D  lColumns       s                   like(jString)
000124100419     D  lFileName      s                   like(jString)
000125100419     D  iTextReport    s                   like(jReportView)
000126100419     D  lColView       s                   like(jReportColumnView)
000127100419     D  counter        S             10I 0
000128100419
000129100419     D  ename          s             40A
000131100419     D  emadd1         s             30A
000132100419     D  emcity         s             25A
000133100419     D  emst           s              2A
000134100419     D  emzip1         S              5S 0
000135100419     D  emzip2         S              5S 0
000138100419
000139100419     D colEmp          S                   like(jString)
000140100419     D colAddr         S                   like(jString)
000141100419     D colCity         S                   like(jString)
000142100419     D colState        S                   like(jString)
000143100419     D colZip1         S                   like(jString)
000144100419     D colZip2         S                   like(jString)
000145100419     D results         S               N
000146100419     D lRows           s             10I 0
000147100419
000148100419     C/free
000149100419        rre_begin_object_group(16);
000150100419        // Initial Object creation
000151100419       lHeading =  new_String('Sample Report using iText and RPG');
000152100419       lColumns = new_jArrayList();
000153100430       lReportName = new_String('Sample iText Report (Sample 2) ');
000154100430       lFileName =  new_String('/reports/output/Sample_2_iText_Report.pdf');
000155100419
000156100419       WriteHeader();
000157100419
000158100419       iTextReport = new_RREReportView(lHeading:lColumns:lReportName:lFileName);
000159100419
000160100419       rreRV_initialize(iTextReport); // Creates the report shell
000161100419       counter = 1;
000162100419        // Prep the SQL statement
000163100419         If PrepSQLGetRS() = SQLSuccess;
000164100419            // Read the employee file
000165100419            Dow FetchNextRow() = SQLSuccess;
000166100419
000167100419               counter = counter + 1;
000168100419
000169100419               WriteLine();
000170100419
000171100419            enddo;
000172100419            // Close the cursor opened in prep
000173100419            CloseSQLCursor();
000174100419            lrows = rreRV_finalize(iTextReport:counter);
000175100419          endif;
000176100511
000177100511        rre_end_object_group();
000178100511
000179100419          *inlr = *on;
000180100419      /end-free
000181100419     p*********************************************************
000182100419     p* Prepare and open the SQL Statement
000183100419     p*********************************************************
000184100419     P PrepSQLGetRS    B
000185100419     D PrepSQLGetRS    PI             5A
000186100419     D/free
000187100419       SQLStmnt = 'select ' +
000188100419        'emfnam || '' '' || substr(emmnam,1,1) || '' ''|| emlnam as ename, ' +
000189100419        'emadd1,emcity, emst, emzip1,emzip2 from employee ' +
000190100419        'order by emlnam,emfnam';
000191100419
000192100419       EXEC SQL
000193100419         PREPARE S1 FROM :SQLStmnt;
000194100419
000195100419       EXEC SQL
000196100419         DECLARE C1 CURSOR FOR S1;
000197100419
000198100419       EXEC SQL
000199100419         OPEN C1;
000200100419
000201100419         RETURN SQLSTT;
000202100419      /end-free
000203100419     P PrepSQLGetRS    E
000204100419     p*********************************************************
000205100419     p* Fetch a row at a time
000206100419     p*********************************************************
000207100419     P FetchNextRow    B
000208100419     D FetchNextRow    PI             5A
000209100419      /free
000210100419       EXEC SQL
000211100419        FETCH FROM C1 INTO :ename, :emadd1, :emcity, :emst, :emzip1, :emzip2 ;
000212100419
000213100419        RETURN SQLSTT;
000214100419      /end-free
000215100419     P FetchNextRow    E
000216100419     C*********************************************************
000217100419     C* Close the Open Cursor
000218100419     C*********************************************************
000219100419     P CloseSQLCursor  B
000220100419     D CloseSQLCursor  PI             5A
000221100419      /free
000222100419       EXEC SQL
000223100419        CLOSE C1;
000224100419
000225100419       RETURN SQLSTT;
000226100419      /end-free
000227100419     P CloseSQLCursor  E
000228100419     C*********************************************************
000229100419     C* Write the header
000230100419     C*********************************************************
000231100419     P WriteHeader     B
000232100419     D WriteHeader     PI
000233100419      /free
000234100419        // Not so much a write as it is a CREATE
000235100419        // Before creating the ReportView, add heading columns to the array
000236100419        // The pattern here is to construct and then add to the ArrayList
000237100419        //Column Headings MUST Total to 100%
000238100419        colEmp = new_String('Employee Name');
000239100419        colAddr= new_String('Address');
000240100419        colCity = new_String('City');
000241100419        colState= new_String('State');
000242100419        colZip1 = new_String('Zip');
000243100419        colZip2= new_String('Zip + 4');
000244100419
000245100419        lColView = new_RREReportColumnView(colEmp:30);
000246100419          rre_jArrayList_add(lColumns:lColView);
000247100419
000248100419        lColView = new_RREReportColumnView(colAddr:20);
000249100419          rre_jArrayList_add(lColumns:lColView);
000250100419
000251100419        lColView = new_RREReportColumnView(colCity:20);
000252100419          rre_jArrayList_add(lColumns:lColView);
000253100419
000254100419        lColView = new_RREReportColumnView(colState:10);
000255100419          rre_jArrayList_add(lColumns:lColView);
000256100419
000257100419        lColView = new_RREReportColumnView(colZip1:10);
000258100419          rre_jArrayList_add(lColumns:lColView);
000259100419
000260100419        lColView = new_RREReportColumnView(colZip2:10);
000261100419          rre_jArrayList_add(lColumns:lColView);
000262100419
000263100419      /end-free
000264100419     P WriteHeader     E
000265100419     C*********************************************************
000266100419     C* Write the detail
000267100419     C*********************************************************
000268100419     P WriteLine       B
000269100419     D WriteLine       PI
000270100419      /free
000271100419        if %REM(counter: 2) = 1;
000272100419             RRERV_SetGrayFill(iTextReport:.9);
000273100419        endif;
000274100419
000275100419         rreRV_addCell(iTextReport:ename);
000276100419         rreRV_addCell(iTextReport:emadd1);
000277100419         rreRV_addCell(iTextReport:emcity);
000278100419         rreRV_addCell(iTextReport:emst);
000279100419         rreRV_addCell(iTextReport:%char(emzip1));
000280100419         rreRV_addCell(iTextReport:%char(emzip2));
000281100419
000282100419        if %REM(counter: 2) = 1;
000283100419             RRERV_SetGrayFill(iTextReport:1);
000284100419        endif;
000285100419
000286100419      /end-free
000287100419     P WriteLine       E
