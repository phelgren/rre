000100080419      *  Demonstration of using RRE to create a Jasper Report
000101080416      *
000102080416      *  To compile:
000103080419      *      Make sure you've already created RRE. See the instructions
000104080416      *      on that source member for details.
000105080416      *
000106080419      *
000107090109      *      CRTBNDRPG PGM(TEST5_RRE) SRCFILE(RRE/QSOURCE) DBGVIEW(*LIST)
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
000136100423
000137100423     D   Sender        s           1024A   varying
000138100423     D   Recipient     s           1024A   varying
000139100423     D   ReportName    s           1024A   varying
000140100423     D   ReportOut     s           1024A   varying
000141100423     D  lReParam       s                   like(jMap)
000142100423     D   OutFormat     s           1024A   varying
000145100423     D success         s               N
000146100423     D   key           s           1024A   varying
000147100423     D   value         s           1024A   varying
000148100423     D OutputType      S              4A
000149080416      *-------------------------------------------------
000150080416      *     Test the report generator
000151080416      *
000152090109      *     See the readme.pdf file for details on the classpath
000153090109      *     requirements to run the RPG Report Generator
000154080416      *
000155080416      *     These parameters will be passed:
000156080421      *
000157080421      *     Sender  - Email Address of Sender
000158080421      *
000159080421      *     Recipient - Email Address of Recipient (who you are sending to)
000160080416      *
000161080416      *     ReportName - Report Template Name - FULL PATH and either the compiled jasper
000162080416      *                    file name OR the jrxml file name (if compiling)
000163080416      *     ReportOut  - Report Output Name - FULL path and file name (extension will
000164080416      *                    be added by output routine)
000165080416      *     reportParameters = A hashmap will key/value pairs for any parameters that are passed
000166080416
000167080416      *     OutFormat  - Extension (basically) PDF, HTML, XLS, RTF, TXT, CSV, ODT
000168080416
000169080419     C     *ENTRY        PLIST
000170080419     C                   PARM                    OutputType
000171080415
000172080415      /free
000173080419       rre_begin_object_group(16);
000174100423
000185100423         Sender = 'pete@valadd.com';
000186221220         Recipient = 'pete@petesworkshop.com';
000187221220         ReportName = '/reports/report_templates/Employee_Listing.jasper';
000188210717         ReportOut = '/reports/report_output/employee_listing_test5';
000191100423        lReParam = new_jMap();
000192100423        OutFormat = %trim(OutputType);
000195100423
000196080421       success = rre_iEmailCompiledReport(
000197100423                              Sender :Recipient
000198100423                              :ReportName :ReportOut
000199080416                              :lReParam
000200180509                              :OutFormat );
000201080415
000202080419        rre_end_object_group();
000203080415        *inlr = *on;
000204080415      /end-free
