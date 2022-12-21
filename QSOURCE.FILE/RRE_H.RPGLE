000100180509      /if not defined(RRE_H)
000102080416      /define OS400_JVM_12
000103180509      /INCLUDE QSYSINC/QRPGLESRC,JNI
000104180509      /INCLUDE qsource,java_std_h
000105090107      * Some of these protypes are
000106080414      * based on Scott Klements prototypes found in hssf4
000107080425      * www.scottklement.com
000108080414      *
000109100419      * April 19th, 2010
000110100419      * I updated the RPG prototypes so that the strings didn't have to be
000111100419      * constructed to be passed which simplifies the interface a bit.
000112100419      * Plus, I added the "engine" parm to accomodate the BIRT option
000113180426      *
000114180426      * April 26, 2018
000115180426      * REMOVED the BIRT Option so removed engine from the signature
000116100419      *
000117100419      *******************************************************************
000118100419      * RRE Data types (shared across some programs)
000119100419      *******************************************************************
000120100419     D RRE_STRING...
000121100419     D                 C                   'java.lang.String'
000122100419     D
000123100419     D lHost           S               O   CLASS(*JAVA: RRE_STRING )
000124100419     D lLibList        S               O   CLASS(*JAVA: RRE_STRING )
000125100419     D lUserID         S               O   CLASS(*JAVA: RRE_STRING )
000126100419     D lPassword       S               O   CLASS(*JAVA: RRE_STRING )
000127100419     D lReportName     S               O   CLASS(*JAVA: RRE_STRING )
000128100419     D lReportOut      S               O   CLASS(*JAVA: RRE_STRING )
000129100419     D lOutFormat      S               O   CLASS(*JAVA: RRE_STRING )
000131100419     D lSender         S               O   CLASS(*JAVA: RRE_STRING )
000132100419     D lRecipient      S               O   CLASS(*JAVA: RRE_STRING )
000133100419     D lSubject        S               O   CLASS(*JAVA: RRE_STRING )
000134100419     D lBodyText       S               O   CLASS(*JAVA: RRE_STRING )
000150100419      ********************************************************************
000162080419      *  rre_get_jni_env(): Get pointer to JNI Environment
000163080414      *
000164080419      *  (Routine from the RRE service program)
000165080414      *  Used by many of the other JNI routines.
000166080414      *
000167080414      *  returns the pointer, or *NULL upon error
000168080414      *-----------------------------------------------------------------
000169080419     D rre_get_jni_env...
000170080414     D                 PR              *
000171080414      *-----------------------------------------------------------------
000172080419      *  rre_freeLocalRef(Ref)
000173080414      *
000174080419      *  Utility routine in the RRE service program.
000175080414      *
000176080414      *  Normally, when you call Java constructors from within Java,
000177080414      *  the JVM knows when they are no longer needed, and cleans
000178080414      *  them up appropriately.   But, from within RPG, the JVM has
000179080414      *  no way to know this.
000180080414      *
000181080414      *  This utility routine will tell the JVM that you're done with
000182080414      *  an object, so that the cleanup routines will remove it.
000183080414      *
000184080414      *      Usage:
000185080414      *               callp  freeLocalRef(ObjectName)
000186080414      *
000187080414      *      for example, if you create a String, use it to create
000188080414      *        an output stream, and then don't need the string anymore,
000189080414      *        you might do something like this:
000190080414      *
000191080414      *               eval   Blah = new_String('/path/to/myfile.txt')
000192080414      *               eval   File = new_FileOutputStream(Blah)
000193080414      *               callp  freeLocalRef(Blah)
000194080414      *-----------------------------------------------------------------
000195080419     D rre_freeLocalRef...
000196080414     D                 PR
000197080414     D    peRef                            like(jobject)
000198080414      *-----------------------------------------------------------------
000199080419      * rre_begin_object_group():  Start a new group of objects
000200080419      *    which will all be freed when rre_end_object_group()
000201080414      *    gets called.
000202080414      *
000203080419      *  Utility routine in the rre service program.
000204080414      *
000205080414      *   peCapacity = maximum number of objects that can be
000206080414      *        referenced within this object group.
000207080414      *
000208080414      *  NOTE: According to the 1.2 JNI Spec, you can create more
000209080414      *        objects in the new frame than peCapacity allows.  The
000210080414      *        peCapacity is the guarenteed number. When no object
000211080414      *        groups are used, 16 references are guarenteed, so if
000212080414      *        you specify 16 here, that would be comparable to a
000213080414      *        "default value".
000214080414      *
000215080414      * Returns 0 if successful, or -1 upon error
000216080414      *-----------------------------------------------------------------
000217080419     D RRE_DFT_GROUP_CAPACITY...
000218080414     D                 C                   CONST(16)
000219080419     D rre_begin_object_group...
000220080414     D                 PR            10I 0
000221080414     D    peCapacity                 10I 0 value
000222080414
000223080414
000224080414      *-----------------------------------------------------------------
000225080419      * rre_end_object_group():  Frees all Java objects that
000226080419      *    have been created since calling rre_begin_object_group()
000227080414      *
000228080414      *        peOldObj = (see below)
000229080414      *        peNewObj = Sometimes it's desirable to preserve one
000230080414      *            object by moving it from the current object group
000231080414      *            to the parent group.   These parameters allow you
000232080414      *            to make that move.
000233080414      *
000234080414      * Returns 0 if successful, or -1 upon error
000235080414      *-----------------------------------------------------------------
000236080419     D rre_end_object_group...
000237080414     D                 PR            10I 0
000238080414     D   peOldObj                          like(jObject) const
000239080414     D                                     options(*nopass)
000240080414     D   peNewObj                          like(jObject)
000241080414     D                                     options(*nopass)
000259080414      ******************************************************************
000260080419      *  RRE Data Types
000261080414      ******************************************************************
000274080419     D RREGenerator    S               O   CLASS(*JAVA
000275080414     D                                     :'com.valadd.report.engine-
000276080414     D                                     .Generator')
000277080414
000278080414      *+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
000279080419      *  new_RREGenerator
000280080419      *      Create a new RPG Report Engine Generator Object
000281080414      *
000282080419      *   Returns the new RPG Report Engine Generator Object
000283080414      *+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
000284080419     D new_RREGenerator...
000285080419     D                 PR                  like(RREGenerator)
000286080414     D                                     ExtProc(*JAVA:
000287080414     D                                     'com.valadd.report.engine-
000288080414     D                                     .Generator':
000289080414     D                                     *CONSTRUCTOR)
000290080418      *++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
000291180516      * RREGenerator has several convenience methods that wrap around the main
000292080418      * method of printReport in the Java Generator class:
000293080418      *
000294080418      *iPrintReport:
000295080418      *  Use iPrintReport when you want to set all the connection information
000296080418      *  manually - Usually for testing or perhaps connecting to different
000297080418      *  systems or databases
000298080418      *
000299080418      *iPrintCompiledReport
000300080418      *  Use iPrintCompiledReport when you have a .jasper file that is already
000301080418      *  compiled AND you want to use the default connection information
000302080418      *  in the properties file
000303080419      *
000304080419      *iPrintUnCompiledReport
000305180516      *  Use iPrintUnCompiledReport when you have a .jrxml file that is NOT already
000306080419      *  compiled AND you want to use the default connection information
000307080419      *  in the properties file.
000308080419      *
000309080419      *iEmailCompiledReport
000310080419      *  Use iEmailCompiledReport when you have a .jasper file that is already
000311080419      *  compiled AND you want to use the default connection information
000312080419      *  in the properties file.  File will be emailed to recipient using
000313080419      *  JavaMail.
000314080419      *
000315080419      *iEmailUnCompiledReport
000316180516      *  Use iEmailUnCompiledReport when you have a .jasper file that is NOT already
000317080419      *  compiled AND you want to use the default connection information
000318080419      *  in the properties file.  These files have a .jrxml extension. The file will
000319080419      *  be emailed to the recipient.
000320080419      *
000321090107      *iEmailCompiledReportAlt
000322090107      *  Use iEmailCompiledReport when you have a .jasper file that is already
000323090107      *  compiled AND you want to use the default connection information
000324090107      *  in the properties file.  File will be emailed to recipient using
000325090107      *  JavaMail.
000326090107      *
000327090107      *iEmailUnCompiledReportAlt
000328180516      *  Use iEmailUnCompiledReport when you have a .jasper file that is NOT already
000329090107      *  compiled AND you want to use the default connection information
000330090107      *  in the properties file.  These files have a .jrxml extension. The file will
000331090107      *  be emailed to the recipient.
000332090107      *
000333080418      *
000334080414      *+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
000335080419      *  Java prototype for RREGenerator
000336080415      *
000337080419      *  RREGenerator_iPrintReport()
000338080414      *    All the heavy lifting is done here for the moment
000339080414      *   String reportOutput, Map reportParameters, String outputFormat, boolean compileFirst
000340080414      *
000341100419      *   host = (input) hostname or IP address for DB connection
000342080414      *   libraryList = (input) comma separated list of libraries for connection
000343080414      *   userID = (input) userID for connection
000344080414      *   password = (input)Password for userID for connection
000345080414      *   reportName = (input) Full path and name of report to be run or compiled
000346080414      *   reportOutput = (input) Full path and name to out the report.  If file doesn't
000347080414      *                  exist then it will be created.  Otherwise it is replaced.  Extension
000348080414      *                  to file is added automatically when output
000349100419      *   reportParameters = A hashmap with key/value pairs for any parameters that are passed
000350080414      *   outputFormat = Basically the extension of the file:
000351080414      *                  pdf, xls,txt,csv,html,odt, rtf
000352080415      *   compileFirst = If you are passing a .jrxml file to be compiled, set this to "true" (1)
000353080414      *
000354080414      *+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
000355080419     D RREGenerator_iPrintReport...
000356080416     D                 PR              N   EXTPROC(*JAVA
000357080415     D                                     :'com.valadd.report.engine-
000358080415     D                                     .Generator'
000359080418     D                                     :'iPrintReport')
000360080415     D  host                               like(jString)
000361080415     D  libraryList                        like(jString)
000362080415     D  userID                             like(jString)
000363080415     D  password                           like(jString)
000364080415     D  reportName                         like(jString)
000365080415     D  reportOutput                       like(jString)
000366080416     D  reportParam                        like(jMap)
000367080415     D  outputFormat                       like(jString)
000368080416     D  compFirst                      N   value
000370080419      *
000371080419      *----------------------------------------------------------------
000372080419      *
000373080419      *   RPG Wrapper Prototype for RRE_iPrintReport
000374080419      *
000375080419      *-----------------------------------------------------------------
000376080419     D rre_iPrintReport...
000377080419     D                 PR              N
000378100419     D   prHost                    1024A   const varying
000379100419     D   prLibList                 1024A   const varying
000380100419     D   prUserID                  1024A   const varying
000381100419     D   prPassword                1024A   const varying
000382100419     D   prReportName              1024A   const varying
000383100419     D   prReportOut               1024A   const varying
000384080419     D   prRepParam                        like(jMap)
000385100419     D   prOutFormat               1024A   const varying
000386080419     D   prCompile                     N   value
000388100419
000389080419      *+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
000390080419      *
000391080419      *  RREGenerator_iPrintCompiledReport()
000392080419      *
000393080419      *  iPrintCompiledReport
000394080419      *
000395080419      *  Use iPrintCompiledReport when you have a .jasper file that is already
000396080419      *  compiled AND you want to use the default connection information
000397080419      *  in the properties file
000398080419      *
000399080419      *   reportName = (input) Full path and name of report to be run or compiled
000400080419      *   reportOutput = (input) Full path and name to out the report.  If file doesn't
000401080419      *                  exist then it will be created.  Otherwise it is replaced.  Extension
000402080419      *                  to file is added automatically when output
000403100419      *   reportParameters = A hashmap with key/value pairs for any parameters that are passed
000404080419      *   outputFormat = Basically the extension of the file:
000405080419      *                  pdf, xls,txt,csv,html,odt, rtf
000406080419      *
000407080419      *+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
000408080419     D RREGenerator_iPrintCompiledReport...
000409080419     D                 PR              N   EXTPROC(*JAVA
000410080419     D                                     :'com.valadd.report.engine-
000411080419     D                                     .Generator'
000412080419     D                                     :'iPrintCompiledReport')
000413100419     D  reportName                         like(jString)
000414100419     D  reportOutput                       like(jString)
000415080419     D  reportParam                        like(jMap)
000416080419     D  outputFormat                       like(jString)
000418080419      *
000419080419      *----------------------------------------------------------------
000420080419      *
000421080419      *   RPG Wrapper Prototype for RRE_iPrintCompiledReport
000422080419      *
000423080419      *-----------------------------------------------------------------
000424080419     D rre_iPrintCompiledReport...
000425080419     D                 PR              N
000426100419     D   prReportName              1024A   const varying
000427100419     D   prReportOut               1024A   const varying
000428080419     D   prRepParam                        like(jMap)
000429100419     D   prOutFormat               1024A   const varying
000431080419      *+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
000432080419      *
000433080419      *  RREGenerator_iPrintUnCompiledReport()
000434080419      *
000435080419      *  iPrintUnCompiledReport
000436080419      *
000437080419      *  Use iPrintUnCompiledReport when you have a .jrxml file that has NOT already
000438080419      *  compiled AND you want to use the default connection information
000439080419      *  in the properties file
000440080419      *
000441080419      *   reportName = (input) Full path and name of report to be run or compiled
000442080419      *   reportOutput = (input) Full path and name to out the report.  If file doesn't
000443080419      *                  exist then it will be created.  Otherwise it is replaced.  Extension
000444080419      *                  to file is added automatically when output
000445100419      *   reportParameters = A hashmap with key/value pairs for any parameters that are passed
000446080419      *   outputFormat = Basically the extension of the file:
000447080419      *                  pdf, xls,txt,csv,html,odt, rtf
000448080419      *
000449080419      *+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
000450080419     D RREGenerator_iPrintUnCompiledReport...
000451080419     D                 PR              N   EXTPROC(*JAVA
000452080419     D                                     :'com.valadd.report.engine-
000453080419     D                                     .Generator'
000454080419     D                                     :'iPrintUnCompiledReport')
000455080419     D  reportName                         like(jString)
000456080419     D  reportOutput                       like(jString)
000457080419     D  reportParam                        like(jMap)
000458080419     D  outputFormat                       like(jString)
000460080419      *
000461080419      *----------------------------------------------------------------
000462080419      *
000463080419      *   RPG Wrapper Prototype for RRE_iPrintUnCompiledReport
000464080419      *
000465080419      *-----------------------------------------------------------------
000466080419     D rre_iPrintUnCompiledReport...
000467080419     D                 PR              N
000468100419     D   prReportName              1024A   const varying
000469100419     D   prReportOut               1024A   const varying
000470080419     D   prRepParam                        like(jMap)
000471100419     D   prOutFormat               1024A   const varying
000473080419      *+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
000474080419      *
000475080419      *  RREGenerator_iEmailCompiledReport()
000476080419      *
000477080419      *  iEmailCompiledReport
000478080419      *
000479080419      *  Use iEmailCompiledReport when you have a .jasper file that is already
000480080419      *  compiled AND you want to use the default connection information
000481080419      *  in the properties file and you want the report delivered by email
000482080419      *
000483080419      *   sender = Email Address of sender
000484080419      *   recipient = Email Address of recipient
000485080419      *   reportName = (input) Full path and name of report to be run or compiled
000486080419      *   reportOutput = (input) Full path and name to out the report.  If file doesn't
000487080419      *                  exist then it will be created.  Otherwise it is replaced.  Extension
000488080419      *                  to file is added automatically when output
000489100419      *   reportParameters = A hashmap with key/value pairs for any parameters that are passed
000490080419      *   outputFormat = Basically the extension of the file:
000491080419      *                  pdf, xls,txt,csv,html,odt, rtf
000492080419      *
000493080419      *+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
000494080419     D RREGenerator_iEmailCompiledReport...
000495080419     D                 PR              N   EXTPROC(*JAVA
000496080419     D                                     :'com.valadd.report.engine-
000497080419     D                                     .Generator'
000498080419     D                                     :'iEmailCompiledReport')
000499080419     D  sender                             like(jString)
000500080419     D  recipient                          like(jString)
000501080419     D  reportName                         like(jString)
000502080419     D  reportOutput                       like(jString)
000503080419     D  reportParam                        like(jMap)
000504080419     D  outputFormat                       like(jString)
000506080419     D
000507080419      *
000508080419      *----------------------------------------------------------------
000509080419      *
000510080419      *   RPG Wrapper Prototype for RRE_iEmailCompiledReport
000511080419      *
000512080419      *-----------------------------------------------------------------
000513080419     D rre_iEmailCompiledReport...
000514080419     D                 PR              N
000515100419     D   prSender                  1024A   const varying
000516100419     D   prRecipient               1024A   const varying
000517100419     D   prReportName              1024A   const varying
000518100419     D   prReportOut               1024A   const varying
000519080419     D   prRepParam                        like(jMap)
000520100419     D   prOutFormat               1024A   const varying
000522080419     D
000523080419      *+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
000524080419      *
000525080419      *  RREGenerator_iEmailUnCompiledReport()
000526080419      *
000527080419      *  iEmailUnCompiledReport
000528080419      *
000529080419      *  Use iEmailUnCompiledReport when you have a .jrxml file that has NOT already
000530080419      *  compiled AND you want to use the default connection information
000531080419      *  in the properties file and you want the report delivered by email
000532080419      *
000533080419      *   sender = Email Address of sender
000534080419      *   recipient = Email Address of recipient
000535080419      *   reportName = (input) Full path and name of report to be run or compiled
000536080419      *   reportOutput = (input) Full path and name to out the report.  If file doesn't
000537080419      *                  exist then it will be created.  Otherwise it is replaced.  Extension
000538080419      *                  to file is added automatically when output
000539100419      *   reportParameters = A hashmap with key/value pairs for any parameters that are passed
000540080419      *   outputFormat = Basically the extension of the file:
000541080419      *                  pdf, xls,txt,csv,html,odt, rtf
000542080419      *
000543080419      *+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
000544080419     D RREGenerator_iEmailUnCompiledReport...
000545080419     D                 PR              N   EXTPROC(*JAVA
000546080419     D                                     :'com.valadd.report.engine-
000547080419     D                                     .Generator'
000548080419     D                                     :'iEmailUnCompiledReport')
000549080419     D  sender                             like(jString)
000550080419     D  recipient                          like(jString)
000551080419     D  reportName                         like(jString)
000552080419     D  reportOutput                       like(jString)
000553080419     D  reportParam                        like(jMap)
000554080419     D  outputFormat                       like(jString)
000556080419     D
000557080419      *
000558080419      *----------------------------------------------------------------
000559080419      *
000560080419      *   RPG Wrapper Prototype for RRE_iEmailUnCompiledReport
000561080419      *
000562080419      *-----------------------------------------------------------------
000563080419     D rre_iEmailUnCompiledReport...
000564080419     D                 PR              N
000565100419     D   prSender                  1024A   const varying
000566100419     D   prRecipient               1024A   const varying
000567100419     D   prReportName              1024A   const varying
000568100419     D   prReportOut               1024A   const varying
000569080419     D   prRepParam                        like(jMap)
000570100419     D   prOutFormat               1024A   const varying
000572080419     D
000573090107      *+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
000574090107      *
000575090107      *  RREGenerator_iEmailCompiledReportAlt()
000576090107      *
000577090107      *  iEmailCompiledReportAlt
000578090107      *
000579090107      *  Use iEmailCompiledReport when you have a .jasper file that is already
000580090107      *  compiled AND you want to use the default connection information
000581090107      *  in the properties file and you want the report delivered by email
000582090107      *
000583090107      *   sender = Email Address of sender
000584090107      *   recipient = Email Address of recipient
000585090107      *   subject = A subject line for the email
000586090107      *   bodyText = The body of the email message
000587090107      *             Both the subject and bodyText can use three 'placeholders'
000588090107      *   $reportName = will insert the full path report name
000589090107      *   $reportOutput = will insert the full path output name
000590090107      *   $outputFormat = will insert the report format e.g. PDF, HTML,
000591090107      *   reportName = (input) Full path and name of report to be run or compiled
000592090107      *   reportOutput = (input) Full path and name to out the report.  If file doesn't
000593090107      *                  exist then it will be created.  Otherwise it is replaced.  Extension
000594090107      *                  to file is added automatically when output
000595100419      *   reportParameters = A hashmap with key/value pairs for any parameters that are passed
000596090107      *   outputFormat = Basically the extension of the file:
000597090107      *                  pdf, xls,txt,csv,html,odt, rtf
000598090107      *
000599090107      *+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
000600090107     D RREGenerator_iEmailCompiledReportAlt...
000601090107     D                 PR              N   EXTPROC(*JAVA
000602090107     D                                     :'com.valadd.report.engine-
000603090107     D                                     .Generator'
000604090107     D                                     :'iEmailCompiledReportAlt')
000605090107     D  sender                             like(jString)
000606090107     D  recipient                          like(jString)
000607090107     D  subject                            like(jString)
000608090107     D  bodyText                           like(jString)
000609090107     D  reportName                         like(jString)
000610090107     D  reportOutput                       like(jString)
000611090107     D  reportParam                        like(jMap)
000612090107     D  outputFormat                       like(jString)
000614090107     D
000615090107      *
000616090107      *----------------------------------------------------------------
000617090107      *
000618090107      *   RPG Wrapper Prototype for RRE_iEmailCompiledReportAlt
000619090107      *
000620090107      *-----------------------------------------------------------------
000621090107     D rre_iEmailCompiledReportAlt...
000622090107     D                 PR              N
000623100419     D   prSender                  1024A   const varying
000624100419     D   prRecipient               1024A   const varying
000625100419     D   prSubject                 1024A   const varying
000626100419     D   prBodyText                1024A   const varying
000627100419     D   prReportName              1024A   const varying
000628100419     D   prReportOut               1024A   const varying
000629090107     D   prRepParam                        like(jMap)
000630100419     D   prOutFormat               1024A   const varying
000632090107     D
000633090107      *+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
000634090107      *
000635090107      *  RREGenerator_iEmailUnCompiledReportAlt()
000636090107      *
000637090107      *  iEmailUnCompiledReportAlt
000638090107      *
000639090107      *  Use iEmailUnCompiledReport when you have a .jrxml file that has NOT already
000640090107      *  compiled AND you want to use the default connection information
000641090107      *  in the properties file and you want the report delivered by email
000642090107      *
000643090107      *   sender = Email Address of sender
000644090107      *   recipient = Email Address of recipient
000645090107      *   subject = A subject line for the email
000646090107      *   bodyText = The body of the email message
000647090107      *             Both the subject and bodyText can use three 'placeholders'
000648090107      *   $reportName = will insert the full path report name
000649090107      *   $reportOutput = will insert the full path output name
000650090107      *   $outputFormat = will insert the report format e.g. PDF, HTML,
000651090107      *   reportName = (input) Full path and name of report to be run or compiled
000652090107      *   reportOutput = (input) Full path and name to out the report.  If file doesn't
000653090107      *                  exist then it will be created.  Otherwise it is replaced.  Extension
000654090107      *                  to file is added automatically when output
000655100419      *   reportParameters = A hashmap with key/value pairs for any parameters that are passed
000656090107      *   outputFormat = Basically the extension of the file:
000657090107      *                  pdf, xls,txt,csv,html,odt, rtf
000658090107      *
000659090107      *+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
000660090107     D RREGenerator_iEmailUnCompiledReportAlt...
000661090107     D                 PR              N   EXTPROC(*JAVA
000662090107     D                                     :'com.valadd.report.engine-
000663090107     D                                     .Generator'
000664090107     D                                     :'iEmailUnCompiledReportAlt')
000665090107     D  sender                             like(jString)
000666090107     D  recipient                          like(jString)
000667090107     D  subject                            like(jString)
000668090107     D  bodyText                           like(jString)
000669090107     D  reportName                         like(jString)
000670090107     D  reportOutput                       like(jString)
000671090107     D  reportParam                        like(jMap)
000672090107     D  outputFormat                       like(jString)
000674090107     D
000675090107      *
000676090107      *----------------------------------------------------------------
000677090107      *
000678090107      *   RPG Wrapper Prototype for RRE_iEmailUnCompiledReportAlt
000679090107      *
000680090107      *-----------------------------------------------------------------
000681090107     D rre_iEmailUnCompiledReportAlt...
000682090107     D                 PR              N
000683100419     D   prSender                  1024A   const varying
000684100419     D   prRecipient               1024A   const varying
000685100419     D   prSubject                 1024A   const varying
000686100419     D   prBodyText                1024A   const varying
000687100419     D   prReportName              1024A   const varying
000688100419     D   prReportOut               1024A   const varying
000689090107     D   prRepParam                        like(jMap)
000690100419     D   prOutFormat               1024A   const varying
000692090107     D
000693080419      ******************************************************************
000694080419      *  RRE Data Types
000695080416      ******************************************************************
000755080419      /define RRE_H
000756080415      /endif
