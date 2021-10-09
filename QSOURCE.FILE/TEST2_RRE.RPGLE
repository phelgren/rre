      *  Demonstration of using RRE to create a Jasper Report
      *
      *  To compile:
      *      Make sure you've already created RRE. See the instructions
      *      on that source member for details.
      *
      *
      *      CRTBNDRPG PGM(TEST2_RRE) SRCFILE(RRE/QSOURCE) DBGVIEW(*LIST)
      *
      *

     H DFTACTGRP(*NO)
     H OPTION(*SRCSTMT: *NODEBUGIO: *NOSHOWCPY)
     H THREAD(*SERIALIZE)
     H BNDDIR('RRE')

      /include qsource,rre_h

     D   Host          s           1024A   varying
     D   LibList       s           1024A   varying
     D   UserID        s           1024A   varying
     D   Password      s           1024A   varying
     D   ReportName    s           1024A   varying
     D   ReportOut     s           1024A   varying
     D  lReParam       s                   like(jMap)
     D   OutFormat     s           1024A   varying
     D  lCompile       s               N
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
      *     Host       - IP Address or Hostname for JDBC Connection
      *     LibList    - Library List for Connection
      *     UserID     - User ID for connection
      *     Password   - Password for connection
      *     ReportName - Report Template Name - FULL PATH and either the compiled jasper
      *                    file name OR the jrxml file name (if compiling)
      *     ReportOut  - Report Output Name - FULL path and file name (extension will
      *                    be added by output routine)
      *     reportParameters = A hashmap will key/value pairs for any parameters that are passed

      *     OutFormat  - Extension (basically) PDF, HTML, XLS, RTF, TXT, CSV, ODT
      *     Compile    - If you are passing a jrxml file, if this is set to true (1) will
      *                    compile it prior to creating the output.  This can be helpful
      *                    to resolve Jasper version issues.

     C     *ENTRY        PLIST
     C                   PARM                    OutputType

      /free
       rre_begin_object_group(16);

         ReportName = '/reports/report_templates/Employee_Listing_new.jasper';
         ReportOut = '/reports/report_output/employee_listing_test2';
         lReParam = new_jMap();
         OutFormat = %trim(OutputType);

       success = rre_iPrintCompiledReport(ReportName :ReportOut
                              :lReParam
                              :OutFormat);

        rre_end_object_group();
        *inlr = *on;
      /end-free
