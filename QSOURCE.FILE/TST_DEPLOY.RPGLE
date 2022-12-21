000100221007      *  Demonstration of using RRE to create a Jasper Report
000101221007      *
000102221007      *  To compile:
000103221007      *      Make sure you've already created RRE. See the instructions
000104221007      *      on that source member for details.
000105221007      *
000106221007      *
000107221105      *      CRTBNDRPG PGM(TST_DEPLOY) SRCFILE(RRE/QSOURCE) DBGVIEW(*LIST)
000108221007      *
000109221007      *
000110221007
000111221007     H DFTACTGRP(*NO)
000112221007     H OPTION(*SRCSTMT: *NODEBUGIO: *NOSHOWCPY)
000113221007     H THREAD(*SERIALIZE)
000114221007     H BNDDIR('RRE')
000115221007
000116221007      /include QSOURCE,RRE_H
000117221007
000118221007     D   ReportName    s           1024A   varying
000119221007     D   ReportOut     s           1024A   varying
000120221007     D   lReParam      s                   like(jMap)
000121221007     D   OutFormat     s           1024A   varying
000122221007     D   success       s               N
000123221007     D   OutputType    S              4A
000124221007      *-------------------------------------------------
000125221007      *     Test the report generator
000126221007      *
000127221007      *     See the readme.pdf file for details on the classpath
000128221007      *     requirements to run the RPG Report Generator
000129221007      *
000130221007      *     These parameters will be passed:
000131221007      *
000132221007      *     Host       - IP Address or Hostname for JDBC Connection
000133221007      *     LibList    - Library List for Connection
000134221007      *     UserID     - User ID for connection
000135221007      *     Password   - Password for connection
000136221007      *     ReportName - Report Template Name - FULL PATH and either the compiled jasper
000137221007      *                    file name OR the jrxml file name (if compiling)
000138221007      *     ReportOut  - Report Output Name - FULL path and file name (extension will
000139221007      *                    be added by output routine)
000140221007      *     reportParameters = A hashmap will key/value pairs for any parameters that are passed
000141221007
000142221007      *     OutFormat  - Extension (basically) PDF, HTML, XLS, RTF, TXT, CSV, ODT
000143221007      *     Compile    - If you are passing a jrxml file, if this is set to true (1) will
000144221007      *                    compile it prior to creating the output.  This can be helpful
000145221007      *                    to resolve Jasper version issues.
000146221007
000147221007     C     *ENTRY        PLIST
000148221007     C                   PARM                    OutputType
000149221007
000150221007      /free
000151221007       rre_begin_object_group(16);
000152221007
000153221105         ReportName = '/reports/report_templates/Employee_Listing_bold.jrxml';
000154221105         ReportOut = '/reports/report_output/Employee_Listing_bold';
000155221007        lReParam = new_jMap();
000156221007        OutFormat = %trim(OutputType);
000157221007
000158221105       success = rre_iPrintCompiledReport(ReportName :ReportOut
000159221007                              :lReParam
000160221007                              :OutFormat );
000161221007
000162221007        rre_end_object_group();
000163221007        *inlr = *on;
000164221007      /end-free
