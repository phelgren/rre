      /if not defined(RRE_H)
      /define OS400_JVM_12
      /INCLUDE QSYSINC/QRPGLESRC,JNI
      /INCLUDE qsource,java_std_h
      * Some of these protypes are
      * based on Scott Klements prototypes found in hssf4
      * www.scottklement.com
      *
      * April 19th, 2010
      * I updated the RPG prototypes so that the strings didn't have to be
      * constructed to be passed which simplifies the interface a bit.
      * Plus, I added the "engine" parm to accomodate the BIRT option
      *
      * April 26, 2018
      * REMOVED the BIRT Option so removed engine from the signature
      *
      *******************************************************************
      * RRE Data types (shared across some programs)
      *******************************************************************
     D RRE_STRING...
     D                 C                   'java.lang.String'
     D
     D lHost           S               O   CLASS(*JAVA: RRE_STRING )
     D lLibList        S               O   CLASS(*JAVA: RRE_STRING )
     D lUserID         S               O   CLASS(*JAVA: RRE_STRING )
     D lPassword       S               O   CLASS(*JAVA: RRE_STRING )
     D lReportName     S               O   CLASS(*JAVA: RRE_STRING )
     D lReportOut      S               O   CLASS(*JAVA: RRE_STRING )
     D lOutFormat      S               O   CLASS(*JAVA: RRE_STRING )
     D lSender         S               O   CLASS(*JAVA: RRE_STRING )
     D lRecipient      S               O   CLASS(*JAVA: RRE_STRING )
     D lSubject        S               O   CLASS(*JAVA: RRE_STRING )
     D lBodyText       S               O   CLASS(*JAVA: RRE_STRING )
      ********************************************************************
      *  rre_get_jni_env(): Get pointer to JNI Environment
      *
      *  (Routine from the RRE service program)
      *  Used by many of the other JNI routines.
      *
      *  returns the pointer, or *NULL upon error
      *-----------------------------------------------------------------
     D rre_get_jni_env...
     D                 PR              *
      *-----------------------------------------------------------------
      *  rre_freeLocalRef(Ref)
      *
      *  Utility routine in the RRE service program.
      *
      *  Normally, when you call Java constructors from within Java,
      *  the JVM knows when they are no longer needed, and cleans
      *  them up appropriately.   But, from within RPG, the JVM has
      *  no way to know this.
      *
      *  This utility routine will tell the JVM that you're done with
      *  an object, so that the cleanup routines will remove it.
      *
      *      Usage:
      *               callp  freeLocalRef(ObjectName)
      *
      *      for example, if you create a String, use it to create
      *        an output stream, and then don't need the string anymore,
      *        you might do something like this:
      *
      *               eval   Blah = new_String('/path/to/myfile.txt')
      *               eval   File = new_FileOutputStream(Blah)
      *               callp  freeLocalRef(Blah)
      *-----------------------------------------------------------------
     D rre_freeLocalRef...
     D                 PR
     D    peRef                            like(jobject)
      *-----------------------------------------------------------------
      * rre_begin_object_group():  Start a new group of objects
      *    which will all be freed when rre_end_object_group()
      *    gets called.
      *
      *  Utility routine in the rre service program.
      *
      *   peCapacity = maximum number of objects that can be
      *        referenced within this object group.
      *
      *  NOTE: According to the 1.2 JNI Spec, you can create more
      *        objects in the new frame than peCapacity allows.  The
      *        peCapacity is the guarenteed number. When no object
      *        groups are used, 16 references are guarenteed, so if
      *        you specify 16 here, that would be comparable to a
      *        "default value".
      *
      * Returns 0 if successful, or -1 upon error
      *-----------------------------------------------------------------
     D RRE_DFT_GROUP_CAPACITY...
     D                 C                   CONST(16)
     D rre_begin_object_group...
     D                 PR            10I 0
     D    peCapacity                 10I 0 value


      *-----------------------------------------------------------------
      * rre_end_object_group():  Frees all Java objects that
      *    have been created since calling rre_begin_object_group()
      *
      *        peOldObj = (see below)
      *        peNewObj = Sometimes it's desirable to preserve one
      *            object by moving it from the current object group
      *            to the parent group.   These parameters allow you
      *            to make that move.
      *
      * Returns 0 if successful, or -1 upon error
      *-----------------------------------------------------------------
     D rre_end_object_group...
     D                 PR            10I 0
     D   peOldObj                          like(jObject) const
     D                                     options(*nopass)
     D   peNewObj                          like(jObject)
     D                                     options(*nopass)
      ******************************************************************
      *  RRE Data Types
      ******************************************************************
     D RREGenerator    S               O   CLASS(*JAVA
     D                                     :'com.valadd.report.engine-
     D                                     .Generator')

      *+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
      *  new_RREGenerator
      *      Create a new RPG Report Engine Generator Object
      *
      *   Returns the new RPG Report Engine Generator Object
      *+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
     D new_RREGenerator...
     D                 PR                  like(RREGenerator)
     D                                     ExtProc(*JAVA:
     D                                     'com.valadd.report.engine-
     D                                     .Generator':
     D                                     *CONSTRUCTOR)
      *++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
      * RREGenerator has several convenience methods that wrap around the main
      * method of printReport in the Java Generator class:
      *
      *iPrintReport:
      *  Use iPrintReport when you want to set all the connection information
      *  manually - Usually for testing or perhaps connecting to different
      *  systems or databases
      *
      *iPrintCompiledReport
      *  Use iPrintCompiledReport when you have a .jasper file that is already
      *  compiled AND you want to use the default connection information
      *  in the properties file
      *
      *iPrintUnCompiledReport
      *  Use iPrintUnCompiledReport when you have a .jrxml file that is NOT already
      *  compiled AND you want to use the default connection information
      *  in the properties file.
      *
      *iEmailCompiledReport
      *  Use iEmailCompiledReport when you have a .jasper file that is already
      *  compiled AND you want to use the default connection information
      *  in the properties file.  File will be emailed to recipient using
      *  JavaMail.
      *
      *iEmailUnCompiledReport
      *  Use iEmailUnCompiledReport when you have a .jasper file that is NOT already
      *  compiled AND you want to use the default connection information
      *  in the properties file.  These files have a .jrxml extension. The file will
      *  be emailed to the recipient.
      *
      *iEmailCompiledReportAlt
      *  Use iEmailCompiledReport when you have a .jasper file that is already
      *  compiled AND you want to use the default connection information
      *  in the properties file.  File will be emailed to recipient using
      *  JavaMail.
      *
      *iEmailUnCompiledReportAlt
      *  Use iEmailUnCompiledReport when you have a .jasper file that is NOT already
      *  compiled AND you want to use the default connection information
      *  in the properties file.  These files have a .jrxml extension. The file will
      *  be emailed to the recipient.
      *
      *
      *+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
      *  Java prototype for RREGenerator
      *
      *  RREGenerator_iPrintReport()
      *    All the heavy lifting is done here for the moment
      *   String reportOutput, Map reportParameters, String outputFormat, boolean compileFirst
      *
      *   host = (input) hostname or IP address for DB connection
      *   libraryList = (input) comma separated list of libraries for connection
      *   userID = (input) userID for connection
      *   password = (input)Password for userID for connection
      *   reportName = (input) Full path and name of report to be run or compiled
      *   reportOutput = (input) Full path and name to out the report.  If file doesn't
      *                  exist then it will be created.  Otherwise it is replaced.  Extension
      *                  to file is added automatically when output
      *   reportParameters = A hashmap with key/value pairs for any parameters that are passed
      *   outputFormat = Basically the extension of the file:
      *                  pdf, xls,txt,csv,html,odt, rtf
      *   compileFirst = If you are passing a .jrxml file to be compiled, set this to "true" (1)
      *
      *+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
     D RREGenerator_iPrintReport...
     D                 PR              N   EXTPROC(*JAVA
     D                                     :'com.valadd.report.engine-
     D                                     .Generator'
     D                                     :'iPrintReport')
     D  host                               like(jString)
     D  libraryList                        like(jString)
     D  userID                             like(jString)
     D  password                           like(jString)
     D  reportName                         like(jString)
     D  reportOutput                       like(jString)
     D  reportParam                        like(jMap)
     D  outputFormat                       like(jString)
     D  compFirst                      N   value
      *
      *----------------------------------------------------------------
      *
      *   RPG Wrapper Prototype for RRE_iPrintReport
      *
      *-----------------------------------------------------------------
     D rre_iPrintReport...
     D                 PR              N
     D   prHost                    1024A   const varying
     D   prLibList                 1024A   const varying
     D   prUserID                  1024A   const varying
     D   prPassword                1024A   const varying
     D   prReportName              1024A   const varying
     D   prReportOut               1024A   const varying
     D   prRepParam                        like(jMap)
     D   prOutFormat               1024A   const varying
     D   prCompile                     N   value

      *+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
      *
      *  RREGenerator_iPrintCompiledReport()
      *
      *  iPrintCompiledReport
      *
      *  Use iPrintCompiledReport when you have a .jasper file that is already
      *  compiled AND you want to use the default connection information
      *  in the properties file
      *
      *   reportName = (input) Full path and name of report to be run or compiled
      *   reportOutput = (input) Full path and name to out the report.  If file doesn't
      *                  exist then it will be created.  Otherwise it is replaced.  Extension
      *                  to file is added automatically when output
      *   reportParameters = A hashmap with key/value pairs for any parameters that are passed
      *   outputFormat = Basically the extension of the file:
      *                  pdf, xls,txt,csv,html,odt, rtf
      *
      *+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
     D RREGenerator_iPrintCompiledReport...
     D                 PR              N   EXTPROC(*JAVA
     D                                     :'com.valadd.report.engine-
     D                                     .Generator'
     D                                     :'iPrintCompiledReport')
     D  reportName                         like(jString)
     D  reportOutput                       like(jString)
     D  reportParam                        like(jMap)
     D  outputFormat                       like(jString)
      *
      *----------------------------------------------------------------
      *
      *   RPG Wrapper Prototype for RRE_iPrintCompiledReport
      *
      *-----------------------------------------------------------------
     D rre_iPrintCompiledReport...
     D                 PR              N
     D   prReportName              1024A   const varying
     D   prReportOut               1024A   const varying
     D   prRepParam                        like(jMap)
     D   prOutFormat               1024A   const varying
      *+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
      *
      *  RREGenerator_iPrintUnCompiledReport()
      *
      *  iPrintUnCompiledReport
      *
      *  Use iPrintUnCompiledReport when you have a .jrxml file that has NOT already
      *  compiled AND you want to use the default connection information
      *  in the properties file
      *
      *   reportName = (input) Full path and name of report to be run or compiled
      *   reportOutput = (input) Full path and name to out the report.  If file doesn't
      *                  exist then it will be created.  Otherwise it is replaced.  Extension
      *                  to file is added automatically when output
      *   reportParameters = A hashmap with key/value pairs for any parameters that are passed
      *   outputFormat = Basically the extension of the file:
      *                  pdf, xls,txt,csv,html,odt, rtf
      *
      *+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
     D RREGenerator_iPrintUnCompiledReport...
     D                 PR              N   EXTPROC(*JAVA
     D                                     :'com.valadd.report.engine-
     D                                     .Generator'
     D                                     :'iPrintUnCompiledReport')
     D  reportName                         like(jString)
     D  reportOutput                       like(jString)
     D  reportParam                        like(jMap)
     D  outputFormat                       like(jString)
      *
      *----------------------------------------------------------------
      *
      *   RPG Wrapper Prototype for RRE_iPrintUnCompiledReport
      *
      *-----------------------------------------------------------------
     D rre_iPrintUnCompiledReport...
     D                 PR              N
     D   prReportName              1024A   const varying
     D   prReportOut               1024A   const varying
     D   prRepParam                        like(jMap)
     D   prOutFormat               1024A   const varying
      *+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
      *
      *  RREGenerator_iEmailCompiledReport()
      *
      *  iEmailCompiledReport
      *
      *  Use iEmailCompiledReport when you have a .jasper file that is already
      *  compiled AND you want to use the default connection information
      *  in the properties file and you want the report delivered by email
      *
      *   sender = Email Address of sender
      *   recipient = Email Address of recipient
      *   reportName = (input) Full path and name of report to be run or compiled
      *   reportOutput = (input) Full path and name to out the report.  If file doesn't
      *                  exist then it will be created.  Otherwise it is replaced.  Extension
      *                  to file is added automatically when output
      *   reportParameters = A hashmap with key/value pairs for any parameters that are passed
      *   outputFormat = Basically the extension of the file:
      *                  pdf, xls,txt,csv,html,odt, rtf
      *
      *+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
     D RREGenerator_iEmailCompiledReport...
     D                 PR              N   EXTPROC(*JAVA
     D                                     :'com.valadd.report.engine-
     D                                     .Generator'
     D                                     :'iEmailCompiledReport')
     D  sender                             like(jString)
     D  recipient                          like(jString)
     D  reportName                         like(jString)
     D  reportOutput                       like(jString)
     D  reportParam                        like(jMap)
     D  outputFormat                       like(jString)
     D
      *
      *----------------------------------------------------------------
      *
      *   RPG Wrapper Prototype for RRE_iEmailCompiledReport
      *
      *-----------------------------------------------------------------
     D rre_iEmailCompiledReport...
     D                 PR              N
     D   prSender                  1024A   const varying
     D   prRecipient               1024A   const varying
     D   prReportName              1024A   const varying
     D   prReportOut               1024A   const varying
     D   prRepParam                        like(jMap)
     D   prOutFormat               1024A   const varying
     D
      *+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
      *
      *  RREGenerator_iEmailUnCompiledReport()
      *
      *  iEmailUnCompiledReport
      *
      *  Use iEmailUnCompiledReport when you have a .jrxml file that has NOT already
      *  compiled AND you want to use the default connection information
      *  in the properties file and you want the report delivered by email
      *
      *   sender = Email Address of sender
      *   recipient = Email Address of recipient
      *   reportName = (input) Full path and name of report to be run or compiled
      *   reportOutput = (input) Full path and name to out the report.  If file doesn't
      *                  exist then it will be created.  Otherwise it is replaced.  Extension
      *                  to file is added automatically when output
      *   reportParameters = A hashmap with key/value pairs for any parameters that are passed
      *   outputFormat = Basically the extension of the file:
      *                  pdf, xls,txt,csv,html,odt, rtf
      *
      *+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
     D RREGenerator_iEmailUnCompiledReport...
     D                 PR              N   EXTPROC(*JAVA
     D                                     :'com.valadd.report.engine-
     D                                     .Generator'
     D                                     :'iEmailUnCompiledReport')
     D  sender                             like(jString)
     D  recipient                          like(jString)
     D  reportName                         like(jString)
     D  reportOutput                       like(jString)
     D  reportParam                        like(jMap)
     D  outputFormat                       like(jString)
     D
      *
      *----------------------------------------------------------------
      *
      *   RPG Wrapper Prototype for RRE_iEmailUnCompiledReport
      *
      *-----------------------------------------------------------------
     D rre_iEmailUnCompiledReport...
     D                 PR              N
     D   prSender                  1024A   const varying
     D   prRecipient               1024A   const varying
     D   prReportName              1024A   const varying
     D   prReportOut               1024A   const varying
     D   prRepParam                        like(jMap)
     D   prOutFormat               1024A   const varying
     D
      *+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
      *
      *  RREGenerator_iEmailCompiledReportAlt()
      *
      *  iEmailCompiledReportAlt
      *
      *  Use iEmailCompiledReport when you have a .jasper file that is already
      *  compiled AND you want to use the default connection information
      *  in the properties file and you want the report delivered by email
      *
      *   sender = Email Address of sender
      *   recipient = Email Address of recipient
      *   subject = A subject line for the email
      *   bodyText = The body of the email message
      *             Both the subject and bodyText can use three 'placeholders'
      *   $reportName = will insert the full path report name
      *   $reportOutput = will insert the full path output name
      *   $outputFormat = will insert the report format e.g. PDF, HTML,
      *   reportName = (input) Full path and name of report to be run or compiled
      *   reportOutput = (input) Full path and name to out the report.  If file doesn't
      *                  exist then it will be created.  Otherwise it is replaced.  Extension
      *                  to file is added automatically when output
      *   reportParameters = A hashmap with key/value pairs for any parameters that are passed
      *   outputFormat = Basically the extension of the file:
      *                  pdf, xls,txt,csv,html,odt, rtf
      *
      *+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
     D RREGenerator_iEmailCompiledReportAlt...
     D                 PR              N   EXTPROC(*JAVA
     D                                     :'com.valadd.report.engine-
     D                                     .Generator'
     D                                     :'iEmailCompiledReportAlt')
     D  sender                             like(jString)
     D  recipient                          like(jString)
     D  subject                            like(jString)
     D  bodyText                           like(jString)
     D  reportName                         like(jString)
     D  reportOutput                       like(jString)
     D  reportParam                        like(jMap)
     D  outputFormat                       like(jString)
     D
      *
      *----------------------------------------------------------------
      *
      *   RPG Wrapper Prototype for RRE_iEmailCompiledReportAlt
      *
      *-----------------------------------------------------------------
     D rre_iEmailCompiledReportAlt...
     D                 PR              N
     D   prSender                  1024A   const varying
     D   prRecipient               1024A   const varying
     D   prSubject                 1024A   const varying
     D   prBodyText                1024A   const varying
     D   prReportName              1024A   const varying
     D   prReportOut               1024A   const varying
     D   prRepParam                        like(jMap)
     D   prOutFormat               1024A   const varying
     D
      *+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
      *
      *  RREGenerator_iEmailUnCompiledReportAlt()
      *
      *  iEmailUnCompiledReportAlt
      *
      *  Use iEmailUnCompiledReport when you have a .jrxml file that has NOT already
      *  compiled AND you want to use the default connection information
      *  in the properties file and you want the report delivered by email
      *
      *   sender = Email Address of sender
      *   recipient = Email Address of recipient
      *   subject = A subject line for the email
      *   bodyText = The body of the email message
      *             Both the subject and bodyText can use three 'placeholders'
      *   $reportName = will insert the full path report name
      *   $reportOutput = will insert the full path output name
      *   $outputFormat = will insert the report format e.g. PDF, HTML,
      *   reportName = (input) Full path and name of report to be run or compiled
      *   reportOutput = (input) Full path and name to out the report.  If file doesn't
      *                  exist then it will be created.  Otherwise it is replaced.  Extension
      *                  to file is added automatically when output
      *   reportParameters = A hashmap with key/value pairs for any parameters that are passed
      *   outputFormat = Basically the extension of the file:
      *                  pdf, xls,txt,csv,html,odt, rtf
      *
      *+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
     D RREGenerator_iEmailUnCompiledReportAlt...
     D                 PR              N   EXTPROC(*JAVA
     D                                     :'com.valadd.report.engine-
     D                                     .Generator'
     D                                     :'iEmailUnCompiledReportAlt')
     D  sender                             like(jString)
     D  recipient                          like(jString)
     D  subject                            like(jString)
     D  bodyText                           like(jString)
     D  reportName                         like(jString)
     D  reportOutput                       like(jString)
     D  reportParam                        like(jMap)
     D  outputFormat                       like(jString)
     D
      *
      *----------------------------------------------------------------
      *
      *   RPG Wrapper Prototype for RRE_iEmailUnCompiledReportAlt
      *
      *-----------------------------------------------------------------
     D rre_iEmailUnCompiledReportAlt...
     D                 PR              N
     D   prSender                  1024A   const varying
     D   prRecipient               1024A   const varying
     D   prSubject                 1024A   const varying
     D   prBodyText                1024A   const varying
     D   prReportName              1024A   const varying
     D   prReportOut               1024A   const varying
     D   prRepParam                        like(jMap)
     D   prOutFormat               1024A   const varying
     D
      ******************************************************************
      *  RRE Data Types
      ******************************************************************
      /define RRE_H
      /endif
