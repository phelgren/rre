000100180509      /if not defined(RRE_ITXT_H)
000101100420      /define OS400_JVM_12
000102180509      /INCLUDE QSYSINC/QRPGLESRC,JNI
000103180509      /INCLUDE qsource,java_std_h
000107100420      ********************************************************************
000108100420      *                                                                  *
000109100420      *  Product of - Value Added Software, Inc                          *C
000110100420      *               1511 East Harvard Ave                              *C
000111100420      *               Salt Lake City, UT  84105                          *C
000112100420      *               (801) 581-1154                                     *C
000113100420      *                                                                  *C
000114100420      *  Copyright Notice                                                *C
000115100420      *                                                                  *C
000117100420      *  All rights, including copyrights reserved.                      *C
000118100420      *  Created: 2010                                                   *C
000119100420      *                                                                  *
000120100420      ********************************************************************
000121100420      * Original version written:    04/20/10  By: P. Helgren                  *
000122100420      * Modifications:                                                         *
000123100420      *       ________________________________________________________________ *
000124100420      **************************************************************************
000125100420      ******************************************************************
000126100420      *  RRE_ITEXT Data Types   PROCEDURE PROTOTYPES
000127100420      *                         PROCEDURE INTERFACES ARE IN RRE_ITXT.RPGLE
000128100420      ******************************************************************
000129100420      *
000130100420      *  iText Classes
000131100420      ******************************************************************
000137100420
000138100420     D RREReportView   S               O   CLASS(*JAVA
000139100420     D                                     :'com.valadd.report.views-
000140100420     D                                     .ReportView')
000141100420
000142100420     D jReportView     S               O   CLASS(*JAVA
000143100420     D                                     :'com.valadd.report.views-
000144100420     D                                     .ReportView')
000145100420
000146100420      *+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
000147100420      *  new_RREReportView
000148100420      *      Create a new RPG Report Engine ReportView Object
000149100420      *
000150100420      *   Returns the new RPG Report Engine ReportView Object
000151100420      *+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
000152100420     D new_RREReportView...
000153100420     D                 PR                  like(RREReportView)
000154100420     D                                     ExtProc(*JAVA:
000155100420     D                                     'com.valadd.report.views-
000156100420     D                                     .ReportView':
000157100420     D                                     *CONSTRUCTOR)
000158100420     D heading                             like(jString)
000159100420     D columns                             like(jArrayList)
000160100420     D reportname                          like(jString)
000161100420     D filename                            like(jString)
000162100420
000163100420     D new_RREReportViewEmpty...
000164100420     D                 PR                  like(RREReportView)
000165100420     D                                     ExtProc(*JAVA:
000166100420     D                                     'com.valadd.report.views-
000167100420     D                                     .ReportView':
000168100420     D                                     *CONSTRUCTOR)
000169100420      *++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
000170100420      * RRE_ReportColumnView    Used to hold column contents for the
000171100420      * report
000172100420      *
000173100420      *++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
000174100420     D RREReportColumnView...
000175100420     D                 S               O   CLASS(*JAVA
000176100420     D                                     :'com.valadd.report.views-
000177100420     D                                     .ReportColumnView')
000178100420     D jReportColumnView...
000179100420     D                 S               O   CLASS(*JAVA
000180100420     D                                     :'com.valadd.report.views-
000181100420     D                                     .ReportColumnView')
000182100420
000183100420
000184100420      *+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
000185100420      *  new_RREReportColumnView
000186100420      *      Create a new RPG Report Engine ReportColumnView Object
000187100420      *
000188100420      *   Returns the new RPG Report Engine ReportColumnView Object
000189100420      *+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
000190100420     D new_RREReportColumnView...
000191100420     D                 PR                  like(RREReportColumnView)
000192100420     D                                     ExtProc(*JAVA:
000193100420     D                                     'com.valadd.report.views-
000194100420     D                                     .ReportColumnView':
000195100420     D                                     *CONSTRUCTOR)
000196100420     D    peTitle                          like(jString)
000197100422     D    pePCTWidth                 10I 0 value
000198100420      *+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
000199100420      *
000200100420      * The initialize method takes the constructed ReportView object and sets up
000201100420      * variables and properties to be used in subsequent steps
000202100420      *
000203100420      *+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
000204100420     D RREReportView_initialize...
000205100420     D                 PR                  EXTPROC(*JAVA
000206100420     D                                     :'com.valadd.report.views-
000207100420     D                                     .ReportView'
000208100420     D                                     :'initialize')
000209100420      *
000210100420      *----------------------------------------------------------------
000211100420      *
000212100420      *   RPG Wrapper Prototype for RREReportView_initialize
000213100420      *
000214100420      *-----------------------------------------------------------------
000215100420     D rreRV_initialize...
000216100420     D                 PR
000217100420     D   prReportView                      like(jReportView)
000218100420      *+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
000219100420      *
000220100420      *The finalize method checks to see if there will be any rows to print in the report
000221100420      * if so, it will output them
000222100420      *
000223100420      *+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
000224100420     D RREReportView_finalize...
000226100422     D                 PR            10I 0 EXTPROC(*JAVA
000227100420     D                                     :'com.valadd.report.views-
000228100420     D                                     .ReportView'
000229100420     D                                     :'finalize')
000230100420     D    peRows                     10I 0 value
000231100420      *
000232100420      *----------------------------------------------------------------
000233100420      *
000234100420      *   RPG Wrapper Prototype for RREReportView_finalize
000235100420      *
000236100420      *-----------------------------------------------------------------
000237100420     D rreRV_finalize...
000238100422     D                 PR            10I 0
000239100420     D   prReportView                      like(jReportView)
000240100420     D    peRows                     10I 0 value
000241100420      *+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
000242100420      *
000243100420      * The setGrayFill sets the background GrayFill so that you can create
000244100420      * a "greenbar" effect
000245100420      *
000246100420      *+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
000247100420     D RREReportView_setGrayFill...
000248100420     D                 PR                  EXTPROC(*JAVA
000249100420     D                                     :'com.valadd.report.views-
000250100420     D                                     .ReportView'
000251100420     D                                     :'setGrayFill')
000252100420     D    peFill                      4F   value
000253100420      *
000254100420      *----------------------------------------------------------------
000255100420      *
000256100420      *   RPG Wrapper Prototype for RREReportView_setGrayFill
000257100420      *
000258100420      *-----------------------------------------------------------------
000259100420     D rreRV_setGrayFill...
000260100420     D                 PR
000261100420     D   prReportView                      like(jReportView)
000262100420     D    peRows                      4F   value
000263100420      *+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
000264100420      *
000265100420      * The addCell method adds a cell to the grid for the report
000266100420      * Convert values to strings to keep it simple for now
000267100420      *
000268100420      *+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
000269100420     D RREReportView_addCell...
000270100420     D                 PR                  EXTPROC(*JAVA
000271100420     D                                     :'com.valadd.report.views-
000272100420     D                                     .ReportView'
000273100420     D                                     :'addCell')
000274100420     D  peCellContent                      like(jstring)
000275100420      *
000276100420      *----------------------------------------------------------------
000277100420      *
000278100420      *   RPG Wrapper Prototype for RREReportView_setGrayFill
000279100420      *
000280100420      *-----------------------------------------------------------------
000281100420     D rreRV_addCell...
000282100420     D                 PR
000283100420     D  prReportView                       like(jReportView)
000284100420     D  peCellContent              1024A   const varying
000285100420      *+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
000286100420      /define RRE_ITXT_H
000287100420      /endif
