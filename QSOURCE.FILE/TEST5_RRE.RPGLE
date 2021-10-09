      *  Demonstration of using RRE to create a Jasper Report
      *
      *  To compile:
      *      Make sure you've already created RRE. See the instructions
      *      on that source member for details.
      *
      *
      *      CRTBNDRPG PGM(TEST5_RRE) SRCFILE(RRE/QSOURCE) DBGVIEW(*LIST)
      *
      *

     H DFTACTGRP(*NO)
     H OPTION(*SRCSTMT: *NODEBUGIO: *NOSHOWCPY)
     H THREAD(*SERIALIZE)
     H BNDDIR('RRE')

      /copy qsource,rre_h


     D   Sender        s           1024A   varying
     D   Recipient     s           1024A   varying
     D   ReportName    s           1024A   varying
     D   ReportOut     s           1024A   varying
     D  lReParam       s                   like(jMap)
     D   OutFormat     s           1024A   varying
     D success         s               N
     D   key           s           1024A   varying
     D   value         s           1024A   varying
     D OutputType      S              4A
      *-------------------------------------------------
      *     Test the report generator
      *
      *     See the readme.pdf file for details on the classpath
      *     requirements to run the RPG Report Generator
      *
      *     These parameters will be passed:
      *
      *     Sender  - Email Address of Sender
      *
      *     Recipient - Email Address of Recipient (who you are sending to)
      *
      *     ReportName - Report Template Name - FULL PATH and either the compiled jasper
      *                    file name OR the jrxml file name (if compiling)
      *     ReportOut  - Report Output Name - FULL path and file name (extension will
      *                    be added by output routine)
      *     reportParameters = A hashmap will key/value pairs for any parameters that are passed

      *     OutFormat  - Extension (basically) PDF, HTML, XLS, RTF, TXT, CSV, ODT

     C     *ENTRY        PLIST
     C                   PARM                    OutputType

      /free
       rre_begin_object_group(16);

         Sender = 'pete@valadd.com';
         Recipient = 'pete@opensource4i.com';
         ReportName = '/reports/report_templates/employee_listing.jasper';
         ReportOut = '/reports/report_output/employee_listing_test5';
        lReParam = new_jMap();
        OutFormat = %trim(OutputType);

       success = rre_iEmailCompiledReport(
                              Sender :Recipient
                              :ReportName :ReportOut
                              :lReParam
                              :OutFormat );

        rre_end_object_group();
        *inlr = *on;
      /end-free
