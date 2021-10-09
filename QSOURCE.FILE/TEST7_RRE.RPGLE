      *  Demonstration of using RRE to create a Jasper Report
      *
      *  To compile:
      *      Make sure you've already created RRE. See the instructions
      *      on that source member for details.
      *
      *
      *      CRTBNDRPG PGM(TEST7_RRE) SRCFILE(RRE/QSOURCE) DBGVIEW(*LIST)
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
     D  lTempMap       s                   like(jMap)
     D   OutFormat     s           1024A   varying
     D  lCompile       s               N
     D success         s               N
     D  lkey           s                   like(jString)
     D  lvalue         s                   like(jString)
     D OutputType      S              4A
      *-------------------------------------------------
      *     Test the report generator
      *
      *     See the readme.pdf file for details on the classpath
      *     requirements to run the RPG Report Generator
      *
      *     These parameters will be passed:
      *
      *     key  - Name of Parameter being passed
      *
      *     Value - Actual value of parameter being passed
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
       rre_begin_object_group(100);

       ReportName=
         '/reports/report_templates/employee_listing_with_Parms.jasper';

       ReportOut='/reports/report_output/employee_listing_with_parms_test7';
        lReParam = new_jMap();
        lTempMap = new_jMap();
        lkey = new_String('selectZip');
        lvalue = new_String('84035');
        lTempMap = rre_jmap_put(lReParam:lkey:lvalue);
        OutFormat = %trim(OutputType);
        lCompile= *OFF;

       success = rre_iPrintCompiledReport(
                              ReportName :ReportOut
                              :lReParam
                              :OutFormat );

        rre_end_object_group();
        *inlr = *on;
      /end-free
