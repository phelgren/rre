000100080419      *  Demonstration of using RRE to create a Jasper Report
000101080416      *
000102080416      *  To compile:
000103080419      *      Make sure you've already created RRE. See the instructions
000104080416      *      on that source member for details.
000105080416      *
000106080419      *
000107090109      *      CRTBNDRPG PGM(TEST3_RRE) SRCFILE(RRE/QSOURCE) DBGVIEW(*LIST)
000108080416      *
000109080416      *
000114080415
000115080415     H DFTACTGRP(*NO)
000116080415     H OPTION(*SRCSTMT: *NODEBUGIO: *NOSHOWCPY)
000117080415     H THREAD(*SERIALIZE)
000118080419     H BNDDIR('RRE')
000119080415
000120080419      /copy qsource,rre_h
000121080415
000135100423
000140100423     D   ReportName    s           1024A   varying
000141100423     D   ReportOut     s           1024A   varying
000142100423     D  lReParam       s                   like(jMap)
000143100423     D   OutFormat     s           1024A   varying
000146100423     D success         s               N
000149100423     D OutputType      S              4A
000150080416      *-------------------------------------------------
000151080416      *     Test the report generator
000152080416      *
000153090109      *     See the readme.pdf file for details on the classpath
000154090109      *     requirements to run the RPG Report Generator
000155080416      *
000156080416      *     These parameters will be passed:
000157080416      *
000158080416      *     ReportName - Report Template Name - FULL PATH and either the compiled jasper
000159080416      *                    file name OR the jrxml file name (if compiling)
000160080416      *     ReportOut  - Report Output Name - FULL path and file name (extension will
000161080416      *                    be added by output routine)
000162080416      *     reportParameters = A hashmap will key/value pairs for any parameters that are passed
000163080416
000164080416      *     OutFormat  - Extension (basically) PDF, HTML, XLS, RTF, TXT, CSV, ODT
000167080416
000168080419     C     *ENTRY        PLIST
000169080419     C                   PARM                    OutputType
000170080415
000171080415      /free
000172080419       rre_begin_object_group(16);
000173080415
000178221220         ReportName = '/reports/report_templates/Employee_Listing.jasper';
000179180516         ReportOut = '/reports/report_output/employee_listing_test3';
000182100423        lReParam = new_jMap();
000183100423        OutFormat = %trim(OutputType);
000186080416
000187080419       success = rre_iPrintCompiledReport(
000188100423                               ReportName : ReportOut
000189080416                              :lReParam
000190180509                              : OutFormat );
000191080415
000192080419        rre_end_object_group();
000193080415        *inlr = *on;
000194080415      /end-free
