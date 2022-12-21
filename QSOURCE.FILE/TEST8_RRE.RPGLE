000100080419      *  Demonstration of using RRE to create a Jasper Report
000101080416      *
000102080416      *  To compile:
000103080419      *      Make sure you've already created RRE. See the instructions
000104080416      *      on that source member for details.
000105080416      *
000106080419      *
000107090103      *      CRTBNDRPG PGM(TEST8_RRE) SRCFILE(RRE/QSOURCE) DBGVIEW(*LIST)
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
000126100423     D   Sender        s           1024A   varying
000127100423     D   Recipient     s           1024A   varying
000128100423     D   ReportName    s           1024A   varying
000129100423     D   ReportOut     s           1024A   varying
000130100423     D  lReParam       s                   like(jMap)
000131100423     D  lTempMap       s                   like(jMap)
000132100423     D   OutFormat     s           1024A   varying
000135100423     D success         s               N
000136100423     D  lkey           s                   like(jString)
000137100423     D  lvalue         s                   like(jInteger)
000138100423     D OutputType      S              4A
000139080416      *-------------------------------------------------
000140080416      *     Test the report generator
000141080416      *
000158080416      *
000159080416      *     These parameters will be passed:
000160080421      *
000161080422      *     key  - Name of Parameter being passed
000162080421      *
000163080422      *     Value - Actual value of parameter being passed
000164080416      *
000165080416      *     ReportName - Report Template Name - FULL PATH and either the compiled jasper
000166080416      *                    file name OR the jrxml file name (if compiling)
000167080416      *     ReportOut  - Report Output Name - FULL path and file name (extension will
000168080416      *                    be added by output routine)
000169080416      *     reportParameters = A hashmap will key/value pairs for any parameters that are passed
000170080416
000171080416      *     OutFormat  - Extension (basically) PDF, HTML, XLS, RTF, TXT, CSV, ODT
000172080416
000173080419     C     *ENTRY        PLIST
000174080419     C                   PARM                    OutputType
000175080415
000176080415      /free
000177080422       rre_begin_object_group(100);
000189080416
000192180516         ReportName =
000193221220            '/reports/report_templates/Employee_Listing_with_Parms.jrxml';
000194180516         ReportOut =
000195210717            '/reports/report_output/employee_listing_with_parms_test8';
000196180516
000197100423        lReParam = new_jMap();
000198100423        lTempMap = new_jMap();
000199100423        lkey = new_String('selectZip');
000200100426        // Maybe this should be a BigDecimal
000201210720        lvalue = new_jInteger(84035);
000202100423        lTempMap = rre_jmap_put(lReParam:lkey:lvalue);
000203100423        OutFormat = %trim(OutputType);
000204100423
000205210717       success = rre_iPrintUnCompiledReport(
000206100423                              ReportName :ReportOut
000207080416                              :lReParam
000208180509                              :OutFormat);
000209080415
000210080419        rre_end_object_group();
000211080415        *inlr = *on;
000212080415      /end-free
