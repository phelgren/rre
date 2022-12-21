000100080419      *  Demonstration of using RRE to create a Jasper Report
000101080416      *
000102080416      *  To compile:
000103080419      *      Make sure you've already created RRE. See the instructions
000104080416      *      on that source member for details.
000105080416      *
000106080419      *
000107090109      *      CRTBNDRPG PGM(TEST2_RRE) SRCFILE(RRE/QSOURCE) DBGVIEW(*LIST)
000108080416      *
000109080416      *
000114080415
000115080415     H DFTACTGRP(*NO)
000116080415     H OPTION(*SRCSTMT: *NODEBUGIO: *NOSHOWCPY)
000117080415     H THREAD(*SERIALIZE)
000118080419     H BNDDIR('RRE')
000119080415
000120180509      /include qsource,rre_h
000121080415
000136100423     D   Host          s           1024A   varying
000137100423     D   LibList       s           1024A   varying
000138100423     D   UserID        s           1024A   varying
000139100423     D   Password      s           1024A   varying
000140100423     D   ReportName    s           1024A   varying
000141100423     D   ReportOut     s           1024A   varying
000142100423     D  lReParam       s                   like(jMap)
000143100423     D   OutFormat     s           1024A   varying
000145100423     D  lCompile       s               N
000146100423     D success         s               N
000147100423     D   key           s           1024A   varying
000148100423     D   value         s           1024A   varying
000149100423     D OutputType      S              4A
000150080416      *-------------------------------------------------
000151080416      *     Test the report generator
000152080416      *
000153090109      *     See the readme.pdf file for details on the classpath
000154090109      *     requirements to run the RPG Report Generator
000155080416      *
000156080416      *     These parameters will be passed:
000157080416      *
000158080416      *     Host       - IP Address or Hostname for JDBC Connection
000159080416      *     LibList    - Library List for Connection
000160080416      *     UserID     - User ID for connection
000161080416      *     Password   - Password for connection
000162080416      *     ReportName - Report Template Name - FULL PATH and either the compiled jasper
000163080416      *                    file name OR the jrxml file name (if compiling)
000164080416      *     ReportOut  - Report Output Name - FULL path and file name (extension will
000165080416      *                    be added by output routine)
000166080416      *     reportParameters = A hashmap will key/value pairs for any parameters that are passed
000167080416
000168080416      *     OutFormat  - Extension (basically) PDF, HTML, XLS, RTF, TXT, CSV, ODT
000169080416      *     Compile    - If you are passing a jrxml file, if this is set to true (1) will
000170080416      *                    compile it prior to creating the output.  This can be helpful
000171080416      *                    to resolve Jasper version issues.
000172080416
000173080419     C     *ENTRY        PLIST
000174080419     C                   PARM                    OutputType
000175080415
000176080415      /free
000177080419       rre_begin_object_group(16);
000178080415
000183210717         ReportName = '/reports/report_templates/Employee_Listing_new.jasper';
000184180516         ReportOut = '/reports/report_output/employee_listing_test2';
000187180516         lReParam = new_jMap();
000188180516         OutFormat = %trim(OutputType);
000191100423
000192210717       success = rre_iPrintCompiledReport(ReportName :ReportOut
000194100423                              :lReParam
000195180523                              :OutFormat);
000196080415
000197080419        rre_end_object_group();
000198080415        *inlr = *on;
000199080415      /end-free
