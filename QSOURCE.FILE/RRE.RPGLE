000100080419      * Utility routines for working with RRE to create Jasper Reports
000101080414      * spreadsheets from ILE RPG.
000102080414      *
000103080414      *  To compile:
000104080414      *
000105080419      *  CRTRPGMOD QTEMP/RRE SRCFILE(rre/QSOURCE) DBGVIEW(*LIST)
000106080414      *
000115090105      *  CRTSRVPGM SRVPGM(RRE/RRE) MODULE(QTEMP/RRE) SRCFILE(RRE/QSOURCE) SRCMBR(RREBND)
000116090105      *   TEXT('Utilties for creating Jasper Reports') ACTGRP(RRE)
000117090105      *
000118090105      *
000119080422      *  CRTBNDDIR BNDDIR(RRE/RRE)
000120080422      *  ADDBNDDIRE BNDDIR(RRE/RRE) OBJ((RRE/RRE *SRVPGM))
000121080414      *
000122080416     H NOMAIN OPTION(*NODEBUGIO: *SRCSTMT: *NOSHOWCPY)
000123080414     H THREAD(*SERIALIZE)
000124080414     H BNDDIR('QC2LE')
000125100422     D start_jvm       PR              *
000126100422     D attach_jvm      PR              *
000127100422      * PI's for the start_jvm and attach_jvm are at the bottom
000139210716      /include qsource,rre_h
000140080414
000141080414      *+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
000142080419      *  rre_iPrintReport():
000143080414      *        Print a Jasper Report
000144080414      *
000145080414      *     peHost       - IP Address or Hostname for JDBC Connection
000146080414      *     peLibList    - Library List for Connection
000147080414      *     peUserID     - User ID for connection
000148080414      *     pePassword   - Password for connection
000149080414      *     peReportName - Report Template Name - FULL PATH and either the compiled jasper
000150080414      *                    file name OR the jrxml file name (if compiling)
000151080414      *     peReportOut  - Report Output Name - FULL path and file name (extension will
000152080414      *                    be added by output routine)
000153080414      *     peOutFormat  - Extension (basically) PDF, HTML, XLS, RTF, TXT, CSV, ODT
000154080414      *     peCompile    - If you are passing a jrxml file, if this is set to true (1) will
000155080414      *                    compile it prior to creating the output.  This can be helpful
000156080414      *                    to resolve Jasper version issues.
000157100422      *     peEngine     - Type of report engine, Jasper or BIRT
000158100422      *                    BIRT only supports the PDF,HTML,XLS and DOC formats
000159100422      *                    The peCompile is ignored by BIRT.  The assumption is that the
000160100422      *                    reports are in the "raw" format - rptdesign
000161080414      *
000162080414      *    Returns the "success" flag to acknowledge a successful creation of report
000163080414      *+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
000164080419     P rre_iPrintReport...
000165080414     P                 B                   EXPORT
000166080419     D rre_iPrintReport...
000167080416     D                 PI              N
000168100422     D   peHost                    1024A   const varying
000169100422     D   peLibList                 1024A   const varying
000170100422     D   peUserID                  1024A   const varying
000171100422     D   pePassword                1024A   const varying
000172100422     D   peReportName              1024A   const varying
000173100422     D   peReportOut               1024A   const varying
000174080416     D   peRepParam                        like(jMap)
000175100422     D   peOutFormat               1024A   const varying
000176080416     D   peCompile                     N   value
000178080416     D success         s               N
000179080419     D gen             s                   like(RREGenerator)
000180080414     D
000181080414      /free
000182080416
000183080419         gen = new_RREGenerator();
000184080416
000185100422        // For convience convert RPG strings to string objects to pass
000186100422        lHost = new_String(peHost);
000187100422        lLibList = new_String(peLibList);
000188100422        lUserID = new_String(peUserID);
000189100422        lPassword = new_String(pePassword);
000190100422        lReportName = new_String(peReportName);
000191100422        lReportOut = new_String(peReportOut);
000194100422        lOutFormat = new_String(%trim(peOutFormat));
000196100422
000197080416
000198100422         success = RREGenerator_iPrintReport(gen: lHost:
000199100422                                            lLibList: lUserID:
000200100422                                            lPassword: lReportName:
000201100422                                            lReportOut: peRepParam:
000202180426                                            lOutFormat: peCompile);
000203080419         rre_freeLocalRef(gen);
000204080419
000205080414         return success;
000206080414      /end-free
000207080414     P                 E
000208080419      *+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
000209080419      *  rre_iPrintCompiledReport():
000210080419      *   Print a Compiled Jasper Report
000211080419      *
000212080419      *     peReportName - Report Template Name - FULL PATH and either the compiled jasper
000213080419      *                    file name
000214080419      *     peReportOut  - Report Output Name - FULL path and file name (extension will
000215080419      *                    be added by output routine)
000216080419      *     peOutFormat  - Extension (basically) PDF, HTML, XLS, RTF, TXT, CSV, ODT
000217080419      *     peRepParam   - Passed report parameters
000218100422      *     peEngine     - Type of report engine, Jasper or BIRT
000219100422      *                    BIRT only supports the PDF,HTML,XLS and DOC formats
000220080419      *
000221080419      *    Returns the "success" flag to acknowledge a successful creation of report
000222080419      *+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
000223080419     P rre_iPrintCompiledReport...
000224080419     P                 B                   EXPORT
000225080419     D rre_iPrintCompiledReport...
000226080419     D                 PI              N
000227100422     D   peReportName              1024A   const varying
000228100422     D   peReportOut               1024A   const varying
000229080419     D   peRepParam                        like(jMap)
000230100422     D   peOutFormat               1024A   const varying
000232080419     D success         s               N
000233080419     D gen             s                   like(RREGenerator)
000234080419     D
000235080419      /free
000236080419
000237080419         gen = new_RREGenerator();
000238100422
000239100422        // For convience convert RPG strings to string objects to pass
000244100422        lReportName = new_String(peReportName);
000245100422        lReportOut = new_String(peReportOut);
000246100422        lOutFormat = new_String(%trim(peOutFormat));
000248100422
000249080419
000250100422         success = RREGenerator_iPrintCompiledReport(gen: lReportName:
000251100422                                            lReportOut: peRepParam:
000252180426                                            lOutFormat);
000253080419         rre_freeLocalRef(gen);
000254080419
000255080419         return success;
000256080419      /end-free
000257080419     P                 E
000258080419      *+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
000259080419      *  rre_iPrintUnCompiledReport():
000260080419      *   Print a an UnCompiled Jasper Report
000261080419      *
000262080419      *     peReportName - Report Template Name - FULL PATH and the .jrxml report
000263080419      *                    file name to be compiled
000264080419      *     peReportOut  - Report Output Name - FULL path and file name (extension will
000265080419      *                    be added by output routine)
000266080419      *     peOutFormat  - Extension (basically) PDF, HTML, XLS, RTF, TXT, CSV, ODT
000267080419      *     peRepParam   - Passed report parameters
000268100422      *     peEngine     - Type of report engine, Jasper or BIRT
000269100422      *                    BIRT only supports the PDF,HTML,XLS and DOC formats
000270080419      *
000271080419      *    Returns the "success" flag to acknowledge a successful creation of report
000272080419      *+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
000273080419     P rre_iPrintUnCompiledReport...
000274080419     P                 B                   EXPORT
000275080419     D rre_iPrintUnCompiledReport...
000276080419     D                 PI              N
000277100422     D   peReportName              1024A   const varying
000278100422     D   peReportOut               1024A   const varying
000279080419     D   peRepParam                        like(jMap)
000280100422     D   peOutFormat               1024A   const varying
000282080419     D success         s               N
000283080419     D gen             s                   like(RREGenerator)
000284080419     D
000285080419      /free
000286080419
000287080419         gen = new_RREGenerator();
000288100422        // For convience convert RPG strings to string objects to pass
000293100422        lReportName = new_String(peReportName);
000294100422        lReportOut = new_String(peReportOut);
000295100422        lOutFormat = new_String(%trim(peOutFormat));
000297100422
000298080419
000299100422         success = RREGenerator_iPrintUnCompiledReport(gen: lReportName:
000300100422                                            lReportOut: peRepParam:
000301180426                                            lOutFormat);
000302080419         rre_freeLocalRef(gen);
000303080419
000304080419         return success;
000305080419      /end-free
000306080419     P                 E
000307080419      *+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
000308080419      *  rre_iEmailCompiledReport():
000309080419      *   Email a Compiled Jasper Report
000310080419      *
000311080419      *     peSender     - Email Address of sender of report
000312080419      *     peRecipient  - Email Address of recipient of report
000313080419      *     peReportName - Report Template Name - FULL PATH and the compiled jasper
000314080419      *                    file name
000315080419      *     peReportOut  - Report Output Name - FULL path and file name (extension will
000316080419      *                    be added by output routine)
000317080419      *     peOutFormat  - Extension (basically) PDF, HTML, XLS, RTF, TXT, CSV, ODT
000318080419      *     peRepParam   - Passed report parameters
000319100422      **     peEngine     - Type of report engine, Jasper or BIRT
000320100422      *                    BIRT only supports the PDF,HTML,XLS and DOC formats
000321080419      *
000322080419      *    Returns the "success" flag to acknowledge a successful creation of report
000323080419      *+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
000324080419     P rre_iEmailCompiledReport...
000325080419     P                 B                   EXPORT
000326080419     D rre_iEmailCompiledReport...
000327080419     D                 PI              N
000328100422     D   peSender                  1024A   const varying
000329100422     D   peRecipient               1024A   const varying
000330100422     D   peReportName              1024A   const varying
000331100422     D   peReportOut               1024A   const varying
000332080419     D   peRepParam                        like(jMap)
000333100422     D   peOutFormat               1024A   const varying
000335080419     D success         s               N
000336080419     D gen             s                   like(RREGenerator)
000337080419     D
000338080419      /free
000339080419
000340080419         gen = new_RREGenerator();
000341100422        // For convience convert RPG strings to string objects to pass
000344100422        lSender = new_String(peSender);
000345100422        lRecipient = new_String(peRecipient);
000346100422        lReportName = new_String(peReportName);
000347100422        lReportOut = new_String(peReportOut);
000348100422        lOutFormat = new_String(%trim(peOutFormat));
000350100422
000351080419
000352100422         success = RREGenerator_iEmailCompiledReport(gen: lSender:
000353100422                                            lRecipient: lReportName:
000354100422                                            lReportOut: peRepParam:
000355180426                                            lOutFormat);
000356080419
000357080419         rre_freeLocalRef(gen);
000358080419
000359080419         return success;
000360080419      /end-free
000361080419     P                 E
000362080419      *+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
000363080419      *  rre_iEmailUnCompiledReport():
000364080419      *   Email an UnCompiled Jasper Report
000365080419      *
000366080419      *     peSender     - Email Address of sender of report
000367080419      *     peRecipient  - Email Address of recipient of report
000368080419      *     peReportName - Report Template Name - FULL PATH and the .jrxml report
000369080419      *                    file name
000370080419      *     peReportOut  - Report Output Name - FULL path and file name (extension will
000371080419      *                    be added by output routine)
000372080419      *     peOutFormat  - Extension (basically) PDF, HTML, XLS, RTF, TXT, CSV, ODT
000373080419      *     peRepParam   - Passed report parameters
000374100422      *     peEngine     - Type of report engine, Jasper or BIRT
000375100422      *                    BIRT only supports the PDF,HTML,XLS and DOC formats
000376080419      *
000377080419      *    Returns the "success" flag to acknowledge a successful creation of report
000378080419      *+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
000379080419     P rre_iEmailUnCompiledReport...
000380080419     P                 B                   EXPORT
000381080419     D rre_iEmailUnCompiledReport...
000382080419     D                 PI              N
000383100422     D   peSender                  1024A   const varying
000384100422     D   peRecipient               1024A   const varying
000385100422     D   peReportName              1024A   const varying
000386100422     D   peReportOut               1024A   const varying
000387080419     D   peRepParam                        like(jMap)
000388100422     D   peOutFormat               1024A   const varying
000390080419     D success         s               N
000391080419     D gen             s                   like(RREGenerator)
000392080419     D
000393080419      /free
000394080419
000395080419         gen = new_RREGenerator();
000396080419
000397100422           // For convience convert RPG strings to string objects to pass
000398100422        lSender = new_String(peSender);
000399100422        lRecipient = new_String(peRecipient);
000400100422        lReportName = new_String(peReportName);
000401100422        lReportOut = new_String(peReportOut);
000402100422        lOutFormat = new_String(%trim(peOutFormat));
000404080419
000405100422         success = RREGenerator_iEmailUnCompiledReport(gen: lSender:
000406100422                                            lRecipient: lReportName:
000407100422                                            lReportOut: peRepParam:
000408180426                                            lOutFormat);
000409080419         rre_freeLocalRef(gen);
000410080419
000411080419         return success;
000412080419      /end-free
000413080419     P                 E
000414090107      *+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
000415090107      *  rre_iEmailCompiledReportAlt();
000416090107      *   Email a Compiled Jasper Report
000417090107      *
000418090107      *     peSender     - Email Address of sender of report
000419090107      *     peRecipient  - Email Address of recipient of report
000420090107      *     peSubject    - Email Subject Line
000421090107      *     peBodyText   - Email Body Text
000422090107      *     peReportName - Report Template Name - FULL PATH and the compiled jasper
000423090107      *                    file name
000424090107      *     peReportOut  - Report Output Name - FULL path and file name (extension will
000425090107      *                    be added by output routine)
000426090107      *     peOutFormat  - Extension (basically) PDF, HTML, XLS, RTF, TXT, CSV, ODT
000427090107      *     peRepParam   - Passed report parameters
000428100422      *     peEngine     - Type of report engine, Jasper or BIRT
000429100422      *                    BIRT only supports the PDF,HTML,XLS and DOC formats
000430090107      *
000431090107      *    Returns the "success" flag to acknowledge a successful creation of report
000432090107      *+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
000433090107     P rre_iEmailCompiledReportAlt...
000434090107     P                 B                   EXPORT
000435090107     D rre_iEmailCompiledReportAlt...
000436090107     D                 PI              N
000437100422     D   peSender                  1024A   const varying
000438100422     D   peRecipient               1024A   const varying
000439100422     D   peSubject                 1024A   const varying
000440100422     D   peBodyText                1024A   const varying
000441100422     D   peReportName              1024A   const varying
000442100422     D   peReportOut               1024A   const varying
000443090107     D   peRepParam                        like(jMap)
000444100422     D   peOutFormat               1024A   const varying
000446090107     D success         s               N
000447090107     D gen             s                   like(RREGenerator)
000448090107     D
000449090107      /free
000450090107
000451090107         gen = new_RREGenerator();
000452100422
000453100422        // For convience convert RPG strings to string objects to pass
000454100422        lSender = new_String(peSender);
000455100422        lRecipient = new_String(peRecipient);
000456100422        lSubject = new_String(peSubject);
000457100422        lBodyText = new_String(peBodyText);
000458100422        lReportName = new_String(peReportName);
000459100422        lReportOut = new_String(peReportOut);
000460100422        lOutFormat = new_String(%trim(peOutFormat));
000462090107
000463100422         success = RREGenerator_iEmailCompiledReportAlt(gen: lSender:
000464100422                                            lRecipient: lSubject:
000465100422                                            lBodyText: lReportName:
000466100422                                            lReportOut: peRepParam:
000467180426                                            lOutFormat);
000468090107
000469090107         rre_freeLocalRef(gen);
000470090107
000471090107         return success;
000472090107      /end-free
000473090107     P                 E
000474090107      *+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
000475090107      *  rre_iEmailUnCompiledReportAlt();
000476090107      *   Email an UnCompiled Jasper Report
000477090107      *
000478090107      *     peSender     - Email Address of sender of report
000479090107      *     peRecipient  - Email Address of recipient of report
000480090107      *     peSubject    - Email Subject Line
000481090107      *     peBodyText   - Email Body Text
000482090107      *     peReportName - Report Template Name - FULL PATH and the .jrxml report
000483090107      *                    file name
000484090107      *     peReportOut  - Report Output Name - FULL path and file name (extension will
000485090107      *                    be added by output routine)
000486090107      *     peOutFormat  - Extension (basically) PDF, HTML, XLS, RTF, TXT, CSV, ODT
000487090107      *     peRepParam   - Passed report parameters
000488100422      *     peEngine     - Type of report engine, Jasper or BIRT
000489100422      *                    BIRT only supports the PDF,HTML,XLS and DOC formats
000490090107      *
000491090107      *    Returns the "success" flag to acknowledge a successful creation of report
000492090107      *+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
000493090107     P rre_iEmailUnCompiledReportAlt...
000494090107     P                 B                   EXPORT
000495090107     D rre_iEmailUnCompiledReportAlt...
000496090107     D                 PI              N
000497100422     D   peSender                  1024A   const varying
000498100422     D   peRecipient               1024A   const varying
000499100422     D   peSubject                 1024A   const varying
000500100422     D   peBodyText                1024A   const varying
000501100422     D   peReportName              1024A   const varying
000502100422     D   peReportOut               1024A   const varying
000503090107     D   peRepParam                        like(jMap)
000504100422     D   peOutFormat               1024A   const varying
000506090107     D success         s               N
000507090107     D gen             s                   like(RREGenerator)
000508090107     D
000509090107      /free
000510090107
000511090107         gen = new_RREGenerator();
000512090107
000513100422           // For convience convert RPG strings to string objects to pass
000514100422        lSender = new_String(peSender);
000515100422        lRecipient = new_String(peRecipient);
000516100422        lSubject = new_String(peSubject);
000517100422        lBodyText = new_String(peBodyText);
000518100422        lReportName = new_String(peReportName);
000519100422        lReportOut = new_String(peReportOut);
000520100422        lOutFormat = new_String(%trim(peOutFormat));
000522090107
000523100422         success = RREGenerator_iEmailUnCompiledReportAlt(gen: lSender:
000524100422                                            lRecipient: lSubject:
000525100422                                            lBodyText: lReportName:
000526100422                                            lReportOut: peRepParam:
000527180426                                            lOutFormat);
000528090107         rre_freeLocalRef(gen);
000529090107
000530090107         return success;
000531090107      /end-free
000532090107     P                 E
000533080422      *------------------------------------------------------------
000534080422      * Add elements to a Hashmap
000535080422      *
000536080422      *------------------------------------------------------------
000537080422     P rre_jMap_put...
000538080422     P                 B                   EXPORT
000539080422     D rre_jMap_put...
000540080422     D                 PI                  like(jObject)
000541080422     D    peMap                            like(jMap)
000542080422     D    peKey                            like(jobject)
000543080422     D    peValue                          like(jObject)
000544080424     D lMap            s                   like(jMap)
000545080422
000546080422      /free
000547080422
000548080424         lMap = JMAP_put(peMap:peKey:peValue);
000549080422
000550080424         return lMap;
000551080422
000552080422      /end-free
000553080422     P                 E
000554080419      *-----------------------------------------------------------------
000555100422      *  rre_freeLocalRef(Ref)
000556080419      *
000557080419      *  Service program utility to free a local reference.
000558080419      *
000559080419      *  Normally, when you call Java constructors from within Java,
000560080419      *  the JVM knows when they are no longer needed, and cleans
000561080419      *  them up appropriately.   But, from within RPG, the JVM has
000562080419      *  no way to know this.
000563080419      *
000564080419      *  This utility routine will tell the JVM that you're done with
000565080419      *  an object, so that the cleanup routines will remove it.
000566080419      *
000567080419      *      Usage:
000568080419      *               callp  rre_freeLocalRef(ObjectName)
000569080419      *
000570080419      *      for example, if you create a String, use it to create
000571080419      *        an output stream, and then don't need the string anymore,
000572080419      *        you might do something like this:
000573080419      *
000574080419      *               eval   Blah = new_String('/path/to/myfile.txt')
000575080419      *               eval   File = new_FileOutputStream(Blah)
000576080419      *               callp  rre_freeLocalRef(Blah)
000577080419      *-----------------------------------------------------------------
000578080419     P rre_freeLocalRef...
000579080419     P                 B                   EXPORT
000580080419     D rre_freeLocalRef...
000581080419     D                 PI
000582080419     D    peRef                            like(jobject)
000583080419     D wwEnv           s               *   static inz(*null)
000584080419
000585080419      /free
000586080419
000587080419          if (wwEnv = *NULL);
000588080419              wwEnv = rre_get_jni_env();
000589080419          endif;
000590080419
000591080419          JNIENV_P = wwEnv;
000592080419          DeleteLocalRef(wwEnv: peRef);
000593080419
000594080419      /end-free
000595080419     P                 E
000596080419      *----------------------------------------------------------------
000597080416      * Courtesy Scott Klement (www.scottklement.com)
000598080419      * rre_begin_object_group():  Start a new group of objects
000599080416      *    which will all be freed when hssf_end_object_group()
000600080416      *    gets called.
000601080416      *
000602080416      *   peCapacity = maximum number of objects that can be
000603080416      *        referenced within this object group.
000604080416      *
000605080416      *  NOTE: According to the 1.2 JNI Spec, you can create more
000606080416      *        objects in the new frame than peCapacity allows.  The
000607080416      *        peCapacity is the guarenteed number.   When no object
000608080416      *        groups are used, 16 references are guarenteed, so if
000609080416      *        you specify 16 here, that would be comparable to a
000610080416      *        "default value".
000611080416      *
000612080416      * Returns 0 if successful, or -1 upon error
000613080416      *-----------------------------------------------------------------
000614080419     P rre_begin_object_group...
000615080416     P                 B                   EXPORT
000616080419     D rre_begin_object_group...
000617080416     D                 PI            10I 0
000618080416     D    peCapacity                 10I 0 value
000619080416
000620080416     D wwEnv           s               *
000621080416     D wwRC            s             10I 0
000622080416
000623080416      /free
000624080416
000625080419       wwEnv = rre_get_jni_env();
000626080416       if (wwEnv = *NULL);
000627080416           return -1;
000628080416       endif;
000629080416
000630080416       JNIENV_P = wwEnv;
000631080416
000632080416       if  ( PushLocalFrame (wwEnv: peCapacity) <> JNI_OK );
000633080416           return -1;
000634080416       else;
000635080416           return 0;
000636080416       endif;
000637080416
000638080416      /end-free
000639080416     P                 E
000640080416
000641080416      *-----------------------------------------------------------------
000642080416      * Courtesy Scott Klement (www.scottklement.com)
000643080419      * rre_end_object_group():  Frees all Java objects that
000644080416      *    have been created since calling hssf_begin_object_group()
000645080416      *
000646080416      *        peOldObj = (see below)
000647080416      *        peNewObj = Sometimes it's desirable to preserve one
000648080416      *            object by moving it from the current object group
000649080416      *            to the parent group.   These parameters allow you
000650080416      *            to make that move.
000651080416      *
000652080416      * Returns 0 if successful, or -1 upon error
000653080416      *-----------------------------------------------------------------
000654080419     P rre_end_object_group...
000655080416     P                 B                   EXPORT
000656080419     D rre_end_object_group...
000657080416     D                 PI            10I 0
000658080416     D   peOldObj                          like(jObject) const
000659080416     D                                     options(*nopass)
000660080416     D   peNewObj                          like(jObject)
000661080416     D                                     options(*nopass)
000662080416
000663080416     D wwOld           s                   like(jObject) inz(*NULL)
000664080416     D wwNew           s                   like(jObject)
000665080416
000666080416      /free
000667080416
000668080419          JNIENV_p = rre_get_jni_env();
000669080416          if (JNIENV_p = *NULL);
000670080416              return -1;
000671080416          endif;
000672080416
000673080416          if %parms >= 2;
000674080416              wwOld = peOldObj;
000675080416          endif;
000676080416
000677080416          wwNew = PopLocalFrame (JNIENV_p: wwOld);
000678080416
000679080416          if %parms >= 2;
000680080416              peNewObj = wwNew;
000681080416          endif;
000682080416
000683080416          return 0;
000684080416
000685080416      /end-free
000686080416     P                 E
000687080416      *-----------------------------------------------------------------
000688080416      * Courtesy Scott Klement (www.scottklement.com)
000689080419      *  rre_get_jni_env():
000690080416      *
000691080416      *  Service program utility to get a pointer to the JNI environment
000692080416      *  you'll need this pointer in order to call many of the JNI
000693080416      *  routines.
000694080416      *
000695080416      *  returns the pointer, or *NULL upon error
000696080416      *-----------------------------------------------------------------
000697080419     P rre_get_jni_env...
000698080416     P                 B                   EXPORT
000699080419     D rre_get_jni_env...
000700080416     D                 PI              *
000701080416
000702080416     D wwEnv           s               *
000703080416
000704080416      /free
000705080416        wwEnv = attach_jvm();
000706080416        if (wwEnv = *NULL);
000707080416           wwEnv = start_jvm();
000708080416        endif;
000709080416
000710080416        return wwEnv;
000711080416      /end-free
000712080416     P                 E
000713100422      *-----------------------------------------------------------------
000714100422      * Courtesy Scott Klement (www.scottklement.com)
000715100422      * attach_jvm():  Attach to JVM if it's running
000716100422      *
000717100422      * Returns a pointer to the JNI environment, or *NULL upon error
000718100422      *-----------------------------------------------------------------
000719100422     P attach_jvm      B
000720100422     D attach_jvm      PI              *
000721100422
000722100422     D dsAtt           ds                  likeds(JavaVMAttachArgs)
000723100422     D wwJVM           s                   like(JavaVM_p) dim(1)
000724100422     D wwJVMc          s                   like(jSize)
000725100422     D wwEnv           s               *   inz(*null)
000726100422     D wwRC            s             10I 0
000727100422      /free
000728100422
000729100422        monitor;
000730100422           wwRC = JNI_GetCreatedJavaVMs(wwJVM: 1: wwJVMc);
000731100422
000732100422           if (wwRC <> JNI_OK  or  wwJVMc = 0);
000733100422               return *NULL;
000734100422           endif;
000735100422
000736100422           JavaVM_P = wwJVM(1);
000737100422           dsAtt = *ALLx'00';
000738100422           dsAtt.version = JNI_VERSION_1_2;
000739100422
000740100422           wwRC = AttachCurrentThread (wwJVM(1): wwEnv: %addr(dsAtt));
000741100422           if (wwRC <> JNI_OK);
000742100422               wwEnv = *NULL;
000743100422           endif;
000744100422
000745100422        on-error;
000746100422           wwEnv = *NULL;
000747100422        endmon;
000748100422
000749100422        return wwEnv;
000750100422
000751100422      /end-free
000752100422     P                 E
000753100422
000754100422      *-----------------------------------------------------------------
000755100422      * Courtesy Scott Klement (www.scottklement.com)
000756100422      *  start_jvm():   Start the Java Virtual Machine (JVM)
000757100422      *
000758100422      *  NOTE: Originally, this called JNI routines to start a new JVM,
000759100422      *        but that meant that a classpath and other options needed
000760100422      *        to be set manually in the JNI invocation.
000761100422      *
000762100422      *        I decided that it would be better to reduce the complexity
000763100422      *        and let RPG start the JVM, so I merely create & destroy
000764100422      *        a string here so that RPG will automatically start the
000765100422      *        JVM for me.
000766100422      *
000767100422      *  returns a pointer to the JNI environment
000768100422      *          or *NULL upon failure.
000769100422      *-----------------------------------------------------------------
000770100422     P start_jvm       B
000771100422     D start_jvm       PI              *
000772100422
000773100422     D SndPgmMsg       PR                  ExtPgm('QMHSNDPM')
000774100422     D   MessageID                    7A   Const
000775100422     D   QualMsgF                    20A   Const
000776100422     D   MsgData                     80A   Const
000777100422     D   MsgDtaLen                   10I 0 Const
000778100422     D   MsgType                     10A   Const
000779100422     D   CallStkEnt                  10A   Const
000780100422     D   CallStkCnt                  10I 0 Const
000781100422     D   MessageKey                   4A
000782100422     D   ErrorCode                32767A   options(*varsize)
000783100422
000784100422     D O_RDWR          C                   4
000785100422     D O_CREAT         C                   8
000786100422     D M_RDWR          C                   const(438)
000787100422
000788100422     D tmpnam          PR              *   extproc('_C_IFS_tmpnam')
000789100422     D   string                      39A   options(*omit)
000790100422     D open            PR            10I 0 ExtProc('open')
000791100422     D  filename                       *   value options(*string)
000792100422     D  openflags                    10I 0 value
000793100422     D  mode                         10U 0 value options(*nopass)
000794100422     D dup             PR            10I 0 ExtProc('dup')
000795100422     D   fildes                      10I 0 Value
000796100422     D unlink          PR            10I 0 ExtProc('unlink')
000797100422     D   path                          *   Value options(*string)
000798100422
000799100422     D ErrorNull       ds
000800100422     D   BytesProv                   10I 0 inz(0)
000801100422     D   BytesAvail                  10I 0 inz(0)
000802100422
000803100422     D fd              s             10I 0
000804100422     D filename        s               *
000805100422     D key             s              4A
000806100422     D wwStr           s                   like(jString)
000807100422
000808100422      /free
000809100422
000810100422         // ---------------------------------------------------------
000811100422         // The JVM can encounter I/O errors if there aren't at least
000812100422         // 3 descriptors open. This code makes sure that there are
000813100422         // at least 3.
000814100422         // ---------------------------------------------------------
000815100422
000816100422         fd = open('/dev/null': O_RDWR);
000817100422         if (fd = -1);
000818100422             filename = tmpnam(*omit);
000819100422             fd = open(filename: O_RDWR+O_CREAT: M_RDWR);
000820100422             unlink(filename);
000821100422         endif;
000822100422
000823100422         dow ( fd < 2 );
000824100422            if (fd = -1);
000825100422                SndPgmMsg( 'CPF9897'
000826100422                         : 'QCPFMSG   *LIBL'
000827100422                         : 'Unable to open three descriptors!'
000828100422                         : 80
000829100422                         : '*ESCAPE'
000830100422                         : '*PGMBDY'
000831100422                         : 1
000832100422                         : Key
000833100422                         : ErrorNull );
000834100422                return *NULL;
000835100422            endif;
000836100422            fd = dup(fd);
000837100422         enddo;
000838100422
000839100422
000840100422         // ---------------------------------------------------------
000841100422         //  Create a string -- this'll trigger RPG to create
000842100422         //  the JVM for us.
000843100422         // ---------------------------------------------------------
000844100422
000845100422         wwStr = new_String('Temp String');
000846100422
000847100422         // ---------------------------------------------------------
000848100422         //   Get the JNI environment for the newly creaed JVM,
000849100422         //   and use it to free up the string.
000850100422         // ---------------------------------------------------------
000851100422
000852100422         JNIENV_P = attach_jvm();
000853100422         DeleteLocalRef(JNIENV_P: wwStr);
000854100422
000855100422         return JNIENV_P;
000856100422        /end-free
000857100422     P                 E
