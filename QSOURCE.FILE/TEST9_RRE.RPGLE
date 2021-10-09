      *  Demonstration of using RRE to create a Jasper Report
      *
      *  To compile:
      *      Make sure you've already created RRE. See the instructions
      *      on that source member for details.
      *
      *
      *      CRTBNDRPG PGM(TEST9_RRE) SRCFILE(RRE/QSOURCE) DBGVIEW(*LIST)
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
     D   OutFormat     s           1024A   varying
     D   lReParam      s                   like(jMap)
     D success         s               N
     D OutputType      S              4A

      *-------------------------------------------------
      *     Test the report engine
      *
      *
      *     These parameters will be passed:
      *
      *     Sender  - Email Address of Sender
      *
      *     Recipient - Email Address of Recipient (who you are sending to)
      *
      *     Subject - A subject line for email
      *
      *     BodyText - Text for the body of the email
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
         ReportName = '/reports/report_templates/employee_listing.jrxml';
         ReportOut = '/reports/report_output/employee_listing';
         lReParam = new_jMap();
         OutFormat = %trim(OutputType);

       success = rre_iEmailUnCompiledReport(
                              Sender : Recipient
                              :ReportName :ReportOut
                              :lReParam
                              :OutFormat );

        rre_end_object_group();
        *inlr = *on;
      /end-free
