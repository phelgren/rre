000100100430      *  Demonstration of using RRE to create a Birt Report
000101100430      *
000102100430      *  To compile:
000103100430      *      Make sure you've already created RRE. See the instructions
000104100430      *      on that source member for details.
000105100430      *
000106100430      *
000107100430      *      CRTBNDRPG PGM(Sample3) SRCFILE(RRE/QSOURCE) DBGVIEW(*LIST)
000108100430      *
000109100430      *
000110100430
000111100430     H DFTACTGRP(*NO)
000112100430     H OPTION(*SRCSTMT: *NODEBUGIO: *NOSHOWCPY)
000113100430     H THREAD(*SERIALIZE)
000114100430     H BNDDIR('RRE')
000115100430
000116100430      /copy qsource,rre_h
000117100430
000118100430     D   Sender        s           1024A   varying
000119100430     D   Recipient     s           1024A   varying
000120100430     D   ReportName    s           1024A   varying
000121100430     D   ReportOut     s           1024A   varying
000122100430     D  lReParam       s                   like(jMap)
000124100430     D   OutFormat     s           1024A   varying
000125180509
000127100430     D success         s               N
000130100430     D OutputType      S              4A
000131100430      *-------------------------------------------------
000132100430      *     Test the report generator
000133100430      *
000134100430      *     See the readme.pdf file for details on the classpath
000135100430      *     requirements to run the RPG Report Generator
000136100430      *
000143100430      *     ReportName - Report Template Name - FULL PATH and either the compiled jasper
000144100430      *                    file name OR the jrxml file name (if compiling)
000145100430      *     ReportOut  - Report Output Name - FULL path and file name (extension will
000146100430      *                    be added by output routine)
000147100430      *     reportParameters = A hashmap will key/value pairs for any parameters that are passed
000148100430      *                   passed as a null value when not used
000149100430      *     OutFormat  - Extension (basically) PDF, HTML, XLS, DOC  (for Birt)
000150100430
000151100430     C     *ENTRY        PLIST
000152100430     C                   PARM                    OutputType
000153100430
000154100430      /free
000155100430       rre_begin_object_group(10);
000156100430
000159100430         ReportName = '/reports/templates/Employee_List_Birt.rptdesign';
000160100430         ReportOut = '/reports/output/Employee_List_Birt';
000161100430         lReParam = new_jMap();
000166100430         OutFormat = %trim(OutputType);
000169100430
000170100430         success = rre_iPrintCompiledReport(
000171100430                              ReportName :ReportOut
000172100430                              :lReParam
000173180509                              :OutFormat );
000174100430
000175100430        rre_end_object_group();
000176100430        *inlr = *on;
000177100430      /end-free
