000100080419      *  Demonstration of using RRE to create a Jasper Report
000101080416      *
000102080416      *  To compile:
000103080419      *      Make sure you've already created RRE. See the instructions
000104080416      *      on that source member for details.
000105080416      *
000106080419      *
000107090109      *      CRTBNDRPG PGM(TEST6_RRE) SRCFILE(RRE/QSOURCE) DBGVIEW(*LIST)
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
000139100423     D   Sender        s           1024A   varying
000140100423     D   Recipient     s           1024A   varying
000141100423     D   ReportName    s           1024A   varying
000142100423     D   ReportOut     s           1024A   varying
000143100423     D  lReParam       s                   like(jMap)
000144100423     D   OutFormat     s           1024A   varying
000147100423     D success         s               N
000148100423     D   key           s           1024A   varying
000149100423     D   value         s           1024A   varying
000150100423     D OutputType      S              4A
000151080416      *-------------------------------------------------
000152080426      *     Test the report engine
000153080416      *
000154090109      *     See the readme.pdf file for details on the classpath
000155090109      *     requirements to run the RPG Report Generator
000156080416      *
000157080416      *     These parameters will be passed:
000158080421      *
000159080421      *     Sender  - Email Address of Sender
000160080421      *
000161080421      *     Recipient - Email Address of Recipient (who you are sending to)
000162080416      *
000163080416      *     ReportName - Report Template Name - FULL PATH and either the compiled jasper
000164080416      *                    file name OR the jrxml file name (if compiling)
000165080416      *     ReportOut  - Report Output Name - FULL path and file name (extension will
000166080416      *                    be added by output routine)
000167080416      *     reportParameters = A hashmap will key/value pairs for any parameters that are passed
000168080416
000169080416      *     OutFormat  - Extension (basically) PDF, HTML, XLS, RTF, TXT, CSV, ODT
000170080416
000171080419     C     *ENTRY        PLIST
000172080419     C                   PARM                    OutputType
000173080415
000174080415      /free
000175080419       rre_begin_object_group(16);
000176100423
000188100423         Sender = 'pete@valadd.com';
000189221220         Recipient = 'pete@petesworkshop.com';
000190221220         ReportName = '/reports/report_templates/Employee_Listing.jrxml';
000191180516         ReportOut = '/reports/report_output/employee_listing_test6';
000192100423         key = 'empLName';
000193100423         value = 'Smith';
000194100423        lReParam = new_jMap();
000195100423        OutFormat = %trim(OutputType);
000198100423
000199080421       success = rre_iEmailUnCompiledReport(
000200100423                              Sender :Recipient
000202100423                              :ReportName :ReportOut
000203080416                              :lReParam
000204180509                              :OutFormat);
000205080415
000206080419        rre_end_object_group();
000207080415        *inlr = *on;
000208080415      /end-free
