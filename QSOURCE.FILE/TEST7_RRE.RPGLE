000100080419      *  Demonstration of using RRE to create a Jasper Report
000101080416      *
000102080416      *  To compile:
000103080419      *      Make sure you've already created RRE. See the instructions
000104080416      *      on that source member for details.
000105080416      *
000106080419      *
000107100511      *      CRTBNDRPG PGM(TEST7_RRE) SRCFILE(RRE/QSOURCE) DBGVIEW(*LIST)
000108080416      *
000109080416      *
000114080415
000115080415     H DFTACTGRP(*NO)
000116080415     H OPTION(*SRCSTMT: *NODEBUGIO: *NOSHOWCPY)
000117080415     H THREAD(*SERIALIZE)
000118080419     H BNDDIR('RRE')
000119080415
000120080419      /copy qsource,rre_h
000121080415
000138100423     D   Sender        s           1024A   varying
000139100423     D   Recipient     s           1024A   varying
000140100423     D   ReportName    s           1024A   varying
000141100423     D   ReportOut     s           1024A   varying
000142100423     D  lReParam       s                   like(jMap)
000143100423     D  lTempMap       s                   like(jMap)
000144100423     D   OutFormat     s           1024A   varying
000146100423     D  lCompile       s               N
000147100423     D success         s               N
000148100423     D  lkey           s                   like(jString)
000149100423     D  lvalue         s                   like(jString)
000150100423     D OutputType      S              4A
000151080416      *-------------------------------------------------
000152080416      *     Test the report generator
000153080416      *
000154090109      *     See the readme.pdf file for details on the classpath
000155090109      *     requirements to run the RPG Report Generator
000156080416      *
000157080416      *     These parameters will be passed:
000158080421      *
000159080422      *     key  - Name of Parameter being passed
000160080421      *
000161080422      *     Value - Actual value of parameter being passed
000162080416      *
000163080416      *     ReportName - Report Template Name - FULL PATH and either the compiled jasper
000164080416      *                    file name OR the jrxml file name (if compiling)
000165080416      *     ReportOut  - Report Output Name - FULL path and file name (extension will
000166080416      *                    be added by output routine)
000167080416      *     reportParameters = A hashmap will key/value pairs for any parameters that are passed
000168080416
000169080416      *     OutFormat  - Extension (basically) PDF, HTML, XLS, RTF, TXT, CSV, ODT
000170080416
000171080419     C     *ENTRY        PLIST
000172080419     C                   PARM                    OutputType
000173080415
000174080415      /free
000175080422       rre_begin_object_group(100);
000176100423
000193180516       ReportName=
000194221220         '/reports/report_templates/Employee_Listing_with_Parms.jasper';
000195180516
000196180516       ReportOut='/reports/report_output/employee_listing_with_parms_test7';
000197100423        lReParam = new_jMap();
000198100423        lTempMap = new_jMap();
000199180516        lkey = new_String('selectZip');
000200180516        lvalue = new_String('84035');
000201180516        lTempMap = rre_jmap_put(lReParam:lkey:lvalue);
000202100423        OutFormat = %trim(OutputType);
000203100423        lCompile= *OFF;
000204100423
000205080422       success = rre_iPrintCompiledReport(
000206100423                              ReportName :ReportOut
000207180516                              :lReParam
000208180509                              :OutFormat );
000209080415
000210080419        rre_end_object_group();
000211080415        *inlr = *on;
000212080415      /end-free
