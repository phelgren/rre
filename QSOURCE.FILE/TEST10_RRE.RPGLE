000100080419      *  Demonstration of using RRE to create a Jasper Report
000101080416      *
000102080416      *  To compile:
000103080419      *      Make sure you've already created RRE. See the instructions
000104080416      *      on that source member for details.
000105080416      *
000106080419      *
000107210717      *      CRTBNDRPG PGM(TEST10_RRE) SRCFILE(RRE/QSOURCE) DBGVIEW(*LIST)
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
000138100423     D   Sender        s           1024A   varying
000139100423     D   Recipient     s           1024A   varying
000140100423     D   Subject       s           1024A   varying
000141100423     D   BodyText      s           1024A   varying
000142100423     D   ReportName    s           1024A   varying
000143100423     D   ReportOut     s           1024A   varying
000145100423     D   OutFormat     s           1024A   varying
000147100423     D   lReParam      s                   like(jMap)
000148100423     D success         s               N
000151100423     D OutputType      S              4A
000152100423
000153080416      *-------------------------------------------------
000154080426      *     Test the report engine
000155080416      *
000156080416      *
000157080416      *     These parameters will be passed:
000158080421      *
000159080421      *     Sender  - Email Address of Sender
000160080421      *
000161080421      *     Recipient - Email Address of Recipient (who you are sending to)
000162080416      *
000163090109      *     Subject - A subject line for email
000164090109      *
000165090109      *     BodyText - Text for the body of the email
000166090109      *
000167080416      *     ReportName - Report Template Name - FULL PATH and either the compiled jasper
000168080416      *                    file name OR the jrxml file name (if compiling)
000169080416      *     ReportOut  - Report Output Name - FULL path and file name (extension will
000170080416      *                    be added by output routine)
000171080416      *     reportParameters = A hashmap will key/value pairs for any parameters that are passed
000172080416
000173080416      *     OutFormat  - Extension (basically) PDF, HTML, XLS, RTF, TXT, CSV, ODT
000174080416
000175080419     C     *ENTRY        PLIST
000176080419     C                   PARM                    OutputType
000177080415
000178080415      /free
000179080419       rre_begin_object_group(16);
000189080416
000190100423         Sender = 'pete@valadd.com';
000191100423         Recipient = 'pete@opensource4i.com';
000192100423         Subject = 'The report $reportOutput is ready';
000193221220         BodyText = 'Please see attached Report: $reportOutput';
000194221220         ReportName = '/reports/report_templates/Employee_Listing.jrxml';
000195210717         ReportOut = '/reports/report_output/employee_listing_test10';
000198100423         lReParam = new_jMap();
000199100423         OutFormat = %trim(OutputType);
000202100423
000203090107       success = rre_iEmailUnCompiledReportAlt(
000204100423                              Sender : Recipient
000205100423                              :Subject :BodyText
000206100423                              :ReportName :ReportOut
000208080416                              :lReParam
000209180509                              :OutFormat );
000210080415
000211080419        rre_end_object_group();
000212080415        *inlr = *on;
000213080415      /end-free
