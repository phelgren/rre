      *  Demonstration of using RRE to create a Jasper Report
      *
      *  To compile:
      *      Make sure you've already created RRE. See the instructions
      *      on that source member for details.
      *
      *
      *      CRTBNDRPG PGM(TEST8_RRE) SRCFILE(RRE/QSOURCE) DBGVIEW(*LIST)
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
     D success         s               N
     D  lkey           s                   like(jString)
     D  lvalue         s                   like(jInteger)
     D OutputType      S              4A
      *-------------------------------------------------
      *     Test the report generator
      *
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

         ReportName =
            '/reports/report_templates/employee_listing_with_Parms.jrxml';
         ReportOut =
            '/reports/report_output/employee_listing_with_parms_test8';

        lReParam = new_jMap();
        lTempMap = new_jMap();
        lkey = new_String('selectZip');
        // Maybe this should be a BigDecimal
        lvalue = new_jInteger(84035);
        lTempMap = rre_jmap_put(lReParam:lkey:lvalue);
        OutFormat = %trim(OutputType);

       success = rre_iPrintUnCompiledReport(
                              ReportName :ReportOut
                              :lReParam
                              :OutFormat);

        rre_end_object_group();
        *inlr = *on;
      /end-free
