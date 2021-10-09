      *  Demonstration of using RRE to create a Birt Report
      *
      *  To compile:
      *      Make sure you've already created RRE. See the instructions
      *      on that source member for details.
      *
      *
      *      CRTBNDRPG PGM(Sample3) SRCFILE(RRE/QSOURCE) DBGVIEW(*LIST)
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
     D OutputType      S              4A
      *-------------------------------------------------
      *     Test the report generator
      *
      *     See the readme.pdf file for details on the classpath
      *     requirements to run the RPG Report Generator
      *
      *     ReportName - Report Template Name - FULL PATH and either the compiled jasper
      *                    file name OR the jrxml file name (if compiling)
      *     ReportOut  - Report Output Name - FULL path and file name (extension will
      *                    be added by output routine)
      *     reportParameters = A hashmap will key/value pairs for any parameters that are passed
      *                   passed as a null value when not used
      *     OutFormat  - Extension (basically) PDF, HTML, XLS, DOC  (for Birt)

     C     *ENTRY        PLIST
     C                   PARM                    OutputType

      /free
       rre_begin_object_group(10);

         ReportName = '/reports/templates/Employee_List_Birt.rptdesign';
         ReportOut = '/reports/output/Employee_List_Birt';
         lReParam = new_jMap();
         OutFormat = %trim(OutputType);

         success = rre_iPrintCompiledReport(
                              ReportName :ReportOut
                              :lReParam
                              :OutFormat );

        rre_end_object_group();
        *inlr = *on;
      /end-free
