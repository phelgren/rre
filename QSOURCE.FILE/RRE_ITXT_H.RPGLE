      /if not defined(RRE_ITXT_H)
      /define OS400_JVM_12
      /INCLUDE QSYSINC/QRPGLESRC,JNI
      /INCLUDE qsource,java_std_h
      ********************************************************************
      *                                                                  *
      *  Product of - Value Added Software, Inc                          *C
      *               1511 East Harvard Ave                              *C
      *               Salt Lake City, UT  84105                          *C
      *               (801) 581-1154                                     *C
      *                                                                  *C
      *  Copyright Notice                                                *C
      *                                                                  *C
      *  All rights, including copyrights reserved.                      *C
      *  Created: 2010                                                   *C
      *                                                                  *
      ********************************************************************
      * Original version written:    04/20/10  By: P. Helgren                  *
      * Modifications:                                                         *
      *       ________________________________________________________________ *
      **************************************************************************
      ******************************************************************
      *  RRE_ITEXT Data Types   PROCEDURE PROTOTYPES
      *                         PROCEDURE INTERFACES ARE IN RRE_ITXT.RPGLE
      ******************************************************************
      *
      *  iText Classes
      ******************************************************************

     D RREReportView   S               O   CLASS(*JAVA
     D                                     :'com.valadd.report.views-
     D                                     .ReportView')

     D jReportView     S               O   CLASS(*JAVA
     D                                     :'com.valadd.report.views-
     D                                     .ReportView')

      *+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
      *  new_RREReportView
      *      Create a new RPG Report Engine ReportView Object
      *
      *   Returns the new RPG Report Engine ReportView Object
      *+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
     D new_RREReportView...
     D                 PR                  like(RREReportView)
     D                                     ExtProc(*JAVA:
     D                                     'com.valadd.report.views-
     D                                     .ReportView':
     D                                     *CONSTRUCTOR)
     D heading                             like(jString)
     D columns                             like(jArrayList)
     D reportname                          like(jString)
     D filename                            like(jString)

     D new_RREReportViewEmpty...
     D                 PR                  like(RREReportView)
     D                                     ExtProc(*JAVA:
     D                                     'com.valadd.report.views-
     D                                     .ReportView':
     D                                     *CONSTRUCTOR)
      *++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
      * RRE_ReportColumnView    Used to hold column contents for the
      * report
      *
      *++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
     D RREReportColumnView...
     D                 S               O   CLASS(*JAVA
     D                                     :'com.valadd.report.views-
     D                                     .ReportColumnView')
     D jReportColumnView...
     D                 S               O   CLASS(*JAVA
     D                                     :'com.valadd.report.views-
     D                                     .ReportColumnView')


      *+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
      *  new_RREReportColumnView
      *      Create a new RPG Report Engine ReportColumnView Object
      *
      *   Returns the new RPG Report Engine ReportColumnView Object
      *+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
     D new_RREReportColumnView...
     D                 PR                  like(RREReportColumnView)
     D                                     ExtProc(*JAVA:
     D                                     'com.valadd.report.views-
     D                                     .ReportColumnView':
     D                                     *CONSTRUCTOR)
     D    peTitle                          like(jString)
     D    pePCTWidth                 10I 0 value
      *+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
      *
      * The initialize method takes the constructed ReportView object and sets up
      * variables and properties to be used in subsequent steps
      *
      *+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
     D RREReportView_initialize...
     D                 PR                  EXTPROC(*JAVA
     D                                     :'com.valadd.report.views-
     D                                     .ReportView'
     D                                     :'initialize')
      *
      *----------------------------------------------------------------
      *
      *   RPG Wrapper Prototype for RREReportView_initialize
      *
      *-----------------------------------------------------------------
     D rreRV_initialize...
     D                 PR
     D   prReportView                      like(jReportView)
      *+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
      *
      *The finalize method checks to see if there will be any rows to print in the report
      * if so, it will output them
      *
      *+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
     D RREReportView_finalize...
     D                 PR            10I 0 EXTPROC(*JAVA
     D                                     :'com.valadd.report.views-
     D                                     .ReportView'
     D                                     :'finalize')
     D    peRows                     10I 0 value
      *
      *----------------------------------------------------------------
      *
      *   RPG Wrapper Prototype for RREReportView_finalize
      *
      *-----------------------------------------------------------------
     D rreRV_finalize...
     D                 PR            10I 0
     D   prReportView                      like(jReportView)
     D    peRows                     10I 0 value
      *+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
      *
      * The setGrayFill sets the background GrayFill so that you can create
      * a "greenbar" effect
      *
      *+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
     D RREReportView_setGrayFill...
     D                 PR                  EXTPROC(*JAVA
     D                                     :'com.valadd.report.views-
     D                                     .ReportView'
     D                                     :'setGrayFill')
     D    peFill                      4F   value
      *
      *----------------------------------------------------------------
      *
      *   RPG Wrapper Prototype for RREReportView_setGrayFill
      *
      *-----------------------------------------------------------------
     D rreRV_setGrayFill...
     D                 PR
     D   prReportView                      like(jReportView)
     D    peRows                      4F   value
      *+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
      *
      * The addCell method adds a cell to the grid for the report
      * Convert values to strings to keep it simple for now
      *
      *+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
     D RREReportView_addCell...
     D                 PR                  EXTPROC(*JAVA
     D                                     :'com.valadd.report.views-
     D                                     .ReportView'
     D                                     :'addCell')
     D  peCellContent                      like(jstring)
      *
      *----------------------------------------------------------------
      *
      *   RPG Wrapper Prototype for RREReportView_setGrayFill
      *
      *-----------------------------------------------------------------
     D rreRV_addCell...
     D                 PR
     D  prReportView                       like(jReportView)
     D  peCellContent              1024A   const varying
      *+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
      /define RRE_ITXT_H
      /endif
