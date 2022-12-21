000100080419      *  Demonstration of using RRE to create a Jasper Report
000101080416      *
000102080416      *  To compile:
000103080419      *      Make sure you've already created RRE. See the instructions
000104080416      *      on that source member for details.
000105080416      *
000106080419      *
000107090109      *      CRTBNDRPG PGM(TEST1_RRE) SRCFILE(RRE/QSOURCE) DBGVIEW(*LIST)
000108080416      *
000109080416      *
000114080415
000115080415     H DFTACTGRP(*NO)
000116080415     H OPTION(*SRCSTMT: *NODEBUGIO: *NOSHOWCPY)
000117080415     H THREAD(*SERIALIZE)
000118080419     H BNDDIR('RRE')
000119080415
000120180523      /include QSOURCE,RRE_H
000121080415
000126100423     D   ReportName    s           1024A   varying
000127100423     D   ReportOut     s           1024A   varying
000128210717     D   lReParam      s                   like(jMap)
000129210717     D   OutFormat     s           1024A   varying
000132210717     D   success       s               N
000135210717     D   OutputType    S              4A
000136080416      *-------------------------------------------------
000137080416      *     Test the report generator
000138080416      *
000139090109      *     See the readme.pdf file for details on the classpath
000140090109      *     requirements to run the RPG Report Generator
000150080416      *
000151080416      *     These parameters will be passed:
000152080416      *
000153080416      *     Host       - IP Address or Hostname for JDBC Connection
000154080416      *     LibList    - Library List for Connection
000155080416      *     UserID     - User ID for connection
000156080416      *     Password   - Password for connection
000157080416      *     ReportName - Report Template Name - FULL PATH and either the compiled jasper
000158080416      *                    file name OR the jrxml file name (if compiling)
000159080416      *     ReportOut  - Report Output Name - FULL path and file name (extension will
000160080416      *                    be added by output routine)
000161080416      *     reportParameters = A hashmap will key/value pairs for any parameters that are passed
000162080416
000163080416      *     OutFormat  - Extension (basically) PDF, HTML, XLS, RTF, TXT, CSV, ODT
000164080416      *     Compile    - If you are passing a jrxml file, if this is set to true (1) will
000165080416      *                    compile it prior to creating the output.  This can be helpful
000166080416      *                    to resolve Jasper version issues.
000167080416
000168080419     C     *ENTRY        PLIST
000169080419     C                   PARM                    OutputType
000170080415
000171080415      /free
000172080419       rre_begin_object_group(16);
000173080415
000178210717         ReportName = '/reports/report_templates/Employee_Listing_new.jrxml';
000179180516         ReportOut = '/reports/report_output/employee_listing_test1';
000182080416        lReParam = new_jMap();
000183100423        OutFormat = %trim(OutputType);
000186100423
000187210717       success = rre_iPrintUnCompiledReport(ReportName :ReportOut
000189080416                              :lReParam
000190180523                              :OutFormat );
000191180523
000196080419        rre_end_object_group();
000197080415        *inlr = *on;
000198080415      /end-free
