000100180523      *  Demonstration of using RRE to create a Jasper Report
000101180523      *
000102180523      *  To compile:
000103180523      *      Make sure you've already created RRE. See the instructions
000104180523      *      on that source member for details.
000105180523      *
000106180523      *
000107210720      *      CRTBNDRPG PGM(TEST4_RRE) SRCFILE(RRE/QSOURCE) DBGVIEW(*LIST)
000108180523      *
000109180523      *
000110180523
000111180523     H DFTACTGRP(*NO)
000112180523     H OPTION(*SRCSTMT: *NODEBUGIO: *NOSHOWCPY)
000113180523     H THREAD(*SERIALIZE)
000114180523     H BNDDIR('RRE')
000115180523
000116180523      /copy qsource,rre_h
000117180523
000118180523
000119180523     D   ReportName    s           1024A   varying
000120180523     D   ReportOut     s           1024A   varying
000121180523     D  lReParam       s                   like(jMap)
000122180523     D   OutFormat     s           1024A   varying
000123180523     D success         s               N
000124180523     D OutputType      S              4A
000125180523      *-------------------------------------------------
000126180523      *     Test the report generator
000127180523      *
000128180523      *     See the readme.pdf file for details on the classpath
000129180523      *     requirements to run the RPG Report Generator
000130180523      *
000131180523      *     These parameters will be passed:
000132180523      *
000133180523      *     ReportName - Report Template Name - FULL PATH and either the compiled jasper
000134180523      *                    file name OR the jrxml file name (if compiling)
000135180523      *     ReportOut  - Report Output Name - FULL path and file name (extension will
000136180523      *                    be added by output routine)
000137180523      *     reportParameters = A hashmap will key/value pairs for any parameters that are passed
000138180523
000139180523      *     OutFormat  - Extension (basically) PDF, HTML, XLS, RTF, TXT, CSV, ODT
000140180523
000141180523     C     *ENTRY        PLIST
000142180523     C                   PARM                    OutputType
000143180523
000144180523      /free
000145180523       rre_begin_object_group(16);
000146180523
000147210717       ReportName = '/reports/report_templates/Employee_Listing.jrxml';
000148210717         ReportOut = '/reports/report_output/Employee_Listing_Test4';
000149180523        lReParam = new_jMap();
000150180523        OutFormat = %trim(OutputType);
000151180523
000152210720       success = rre_iPrintUnCompiledReport(
000153180523                               ReportName : ReportOut
000154180523                              :lReParam
000155180523                              : OutFormat );
000156180523
000157180523        rre_end_object_group();
000158180523        *inlr = *on;
000159180523      /end-free
