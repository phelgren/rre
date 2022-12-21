000100100430      * Utility routines for working with RRE to create iText Reports
000101100422      * spreadsheets from ILE RPG.
000102100422      *
000103100422      *  To compile:
000104100422      *
000105100422      *  CRTRPGMOD QTEMP/RRE_ITXT SRCFILE(rre/QSOURCE) DBGVIEW(*LIST)
000106100422      *
000107100511      *CRTSRVPGM SRVPGM(RRE/RRE_ITXT) MODULE(QTEMP/RRE_ITXT) SRCFILE(RRE/QSOURCE) SRCMBR(RREITXTBND)
000108100422      *   TEXT('Utilties for creating iText Reports') ACTGRP(RRE)
000109100422      *
000110100422      *
000111100422      *  CRTBNDDIR BNDDIR(RRE/RRE_ITXT)
000112100422      *  ADDBNDDIRE BNDDIR(RRE/RRE_ITXT) OBJ((RRE/RRE_ITXT *SRVPGM))
000113100422      *
000114100422     H NOMAIN OPTION(*NODEBUGIO: *SRCSTMT: *NOSHOWCPY)
000115100422     H THREAD(*SERIALIZE)
000116100422     H BNDDIR('QC2LE')
000117100422     D start_jvm       PR              *
000118100422     D attach_jvm      PR              *
000119100422      * PI's for the start_jvm and attach_jvm are at the bottom
000127100422      /copy QSOURCE,RRE_ITXT_H
000128100422      /copy QSOURCE,RRE_H
000129100422
000130100422      *+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
000131100422      *  rreRV_initialize
000132100422      *        Initialize the ReportView object after passing the contructor parameters
000133100422      *
000134100422      *  Basically will instantiate the pdf document and create the header, report names, and file
000135100422      *  Java method returns void
000136100422      *
000148100422      *+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
000149100422     P rreRV_initialize...
000150100422     P                 B                   EXPORT
000151100422     D rreRV_initialize...
000152100422     D                 PI
000153100422     D  peReportView                       like(jReportView)
000156100422
000157100422      /free
000158100422
000159100422            RREReportView_initialize(peReportView);
000162100422
000163100422      /end-free
000164100422     P                 E
000165100422      *+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
000166100422      *  rreRV_finalize
000167100422      *        Finalize the report, outputting contents and cleaning up
000168100422      *  Java method returns void
000169100422      *
000170100422      *+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
000171100422     P rreRV_finalize...
000172100422     P                 B                   EXPORT
000173100422     D rreRV_finalize...
000174100422     D                 PI            10I 0
000175100422     D  peReportView                       like(jReportView)
000176100422     D  peRows                       10I 0 value
000177100422     D lRows           s             10I 0
000178100422
000179100422      /free
000180100422
000181100422            lRows = RREReportView_finalize(peReportView:peRows);
000184100422
000185100422            return lRows;
000186100422
000187100422      /end-free
000188100422     P                 E
000189100422      *+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
000190100422      *  rreRV_setGrayFill
000191100422      *        Changes the default background fill grayscale
000192100422      *   Java method returns void
000193100422      *+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
000194100422     P rreRV_setGrayFill...
000195100422     P                 B                   EXPORT
000196100422     D rreRV_setGrayFill...
000197100422     D                 PI
000198100422     D  peReportView                       like(jReportView)
000199100422     D  peFill                        4F   value
000200100422
000201100422      /free
000202100422
000203100422            RREReportView_setGrayFill(peReportView:peFill);
000206100422
000207100422      /end-free
000208100422     P                 E
000209100422      *+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
000210100422      *  rreRV_setGrayFill
000211100422      *        Changes the default background fill grayscale
000212100422      *   Java method returns void
000213100422      *+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
000214100422     P rreRV_addCell...
000215100422     P                 B                   EXPORT
000216100422     D rreRV_addCell...
000217100422     D                 PI
000218100422     D  peReportView                       like(jReportView)
000219100422     D  peCellContent              1024A   const varying
000221100422     D  cellContents   s                   like(jString)
000222100422      /free
000223100422           cellContents =  new_String(peCellContent);
000224100422           RREReportView_addCell(peReportView:cellContents);
000227100422
000228100422      /end-free
000229100422     P                 E
000230100422      *------------------------------------------------------------
000231100422      * Add Ojbects to and ArrayList
000232100422      *
000233100422      *------------------------------------------------------------
000234100422     P rre_jArrayList_add...
000235100422     P                 B                   EXPORT
000236100422     D rre_jArrayList_add...
000237100422     D                 PI
000238100422     D    peArrayList                      like(jArrayList)
000239100422     D    peObjToAdd                        like(jobject)
000242100422
000243100422      /free
000244100422
000245100422         JARRAYLIST_add(peArrayList:peObjToAdd);
000246100422
000249100422      /end-free
000250100422     P                 E
000251100422      *-----------------------------------------------------------------
000252100422      *  rre_freeLocalRef(Ref)
000253100422      *
000254100422      *  Service program utility to free a local reference.
000255100422      *
000256100422      *  Normally, when you call Java constructors from within Java,
000257100422      *  the JVM knows when they are no longer needed, and cleans
000258100422      *  them up appropriately.   But, from within RPG, the JVM has
000259100422      *  no way to know this.
000260100422      *
000261100422      *  This utility routine will tell the JVM that you're done with
000262100422      *  an object, so that the cleanup routines will remove it.
000263100422      *
000264100422      *      Usage:
000265100422      *               callp  rre_freeLocalRef(ObjectName)
000266100422      *
000267100422      *      for example, if you create a String, use it to create
000268100422      *        an output stream, and then don't need the string anymore,
000269100422      *        you might do something like this:
000270100422      *
000271100422      *               eval   Blah = new_String('/path/to/myfile.txt')
000272100422      *               eval   File = new_FileOutputStream(Blah)
000273100422      *               callp  rre_freeLocalRef(Blah)
000274100422      *-----------------------------------------------------------------
000275100422     P rre_freeLocalRef...
000276100422     P                 B                   EXPORT
000277100422     D rre_freeLocalRef...
000278100422     D                 PI
000279100422     D    peRef                            like(jobject)
000280100422     D wwEnv           s               *   static inz(*null)
000281100422
000282100422      /free
000283100422
000284100422          if (wwEnv = *NULL);
000285100422              wwEnv = rre_get_jni_env();
000286100422          endif;
000287100422
000288100422          JNIENV_P = wwEnv;
000289100422          DeleteLocalRef(wwEnv: peRef);
000290100422
000291100422      /end-free
000292100422     P                 E
000293100422      *----------------------------------------------------------------
000294100422      * Courtesy Scott Klement (www.scottklement.com)
000295100422      * rre_begin_object_group():  Start a new group of objects
000296100422      *    which will all be freed when hssf_end_object_group()
000297100422      *    gets called.
000298100422      *
000299100422      *   peCapacity = maximum number of objects that can be
000300100422      *        referenced within this object group.
000301100422      *
000302100422      *  NOTE: According to the 1.2 JNI Spec, you can create more
000303100422      *        objects in the new frame than peCapacity allows.  The
000304100422      *        peCapacity is the guarenteed number.   When no object
000305100422      *        groups are used, 16 references are guarenteed, so if
000306100422      *        you specify 16 here, that would be comparable to a
000307100422      *        "default value".
000308100422      *
000309100422      * Returns 0 if successful, or -1 upon error
000310100422      *-----------------------------------------------------------------
000311100422     P rre_begin_object_group...
000312100422     P                 B                   EXPORT
000313100422     D rre_begin_object_group...
000314100422     D                 PI            10I 0
000315100422     D    peCapacity                 10I 0 value
000316100422
000317100422     D wwEnv           s               *
000318100422     D wwRC            s             10I 0
000319100422
000320100422      /free
000321100422
000322100422       wwEnv = rre_get_jni_env();
000323100422       if (wwEnv = *NULL);
000324100422           return -1;
000325100422       endif;
000326100422
000327100422       JNIENV_P = wwEnv;
000328100422
000329100422       if  ( PushLocalFrame (wwEnv: peCapacity) <> JNI_OK );
000330100422           return -1;
000331100422       else;
000332100422           return 0;
000333100422       endif;
000334100422
000335100422      /end-free
000336100422     P                 E
000337100422
000338100422      *-----------------------------------------------------------------
000339100422      * Courtesy Scott Klement (www.scottklement.com)
000340100422      * rre_end_object_group():  Frees all Java objects that
000341100422      *    have been created since calling hssf_begin_object_group()
000342100422      *
000343100422      *        peOldObj = (see below)
000344100422      *        peNewObj = Sometimes it's desirable to preserve one
000345100422      *            object by moving it from the current object group
000346100422      *            to the parent group.   These parameters allow you
000347100422      *            to make that move.
000348100422      *
000349100422      * Returns 0 if successful, or -1 upon error
000350100422      *-----------------------------------------------------------------
000351100422     P rre_end_object_group...
000352100422     P                 B                   EXPORT
000353100422     D rre_end_object_group...
000354100422     D                 PI            10I 0
000355100422     D   peOldObj                          like(jObject) const
000356100422     D                                     options(*nopass)
000357100422     D   peNewObj                          like(jObject)
000358100422     D                                     options(*nopass)
000359100422
000360100422     D wwOld           s                   like(jObject) inz(*NULL)
000361100422     D wwNew           s                   like(jObject)
000362100422
000363100422      /free
000364100422
000365100422          JNIENV_p = rre_get_jni_env();
000366100422          if (JNIENV_p = *NULL);
000367100422              return -1;
000368100422          endif;
000369100422
000370100422          if %parms >= 2;
000371100422              wwOld = peOldObj;
000372100422          endif;
000373100422
000374100422          wwNew = PopLocalFrame (JNIENV_p: wwOld);
000375100422
000376100422          if %parms >= 2;
000377100422              peNewObj = wwNew;
000378100422          endif;
000379100422
000380100422          return 0;
000381100422
000382100422      /end-free
000383100422     P                 E
000384100422      *-----------------------------------------------------------------
000385100422      * Courtesy Scott Klement (www.scottklement.com)
000386100422      *  rre_get_jni_env():
000387100422      *
000388100422      *  Service program utility to get a pointer to the JNI environment
000389100422      *  you'll need this pointer in order to call many of the JNI
000390100422      *  routines.
000391100422      *
000392100422      *  returns the pointer, or *NULL upon error
000393100422      *-----------------------------------------------------------------
000394100422     P rre_get_jni_env...
000395100422     P                 B                   EXPORT
000396100422     D rre_get_jni_env...
000397100422     D                 PI              *
000398100422
000399100422     D wwEnv           s               *
000400100422
000401100422      /free
000402100422        wwEnv = attach_jvm();
000403100422        if (wwEnv = *NULL);
000404100422           wwEnv = start_jvm();
000405100422        endif;
000406100422
000407100422        return wwEnv;
000408100422      /end-free
000409100422     P                 E
000410100422      *-----------------------------------------------------------------
000411100422      * Courtesy Scott Klement (www.scottklement.com)
000412100422      * attach_jvm():  Attach to JVM if it's running
000413100422      *
000414100422      * Returns a pointer to the JNI environment, or *NULL upon error
000415100422      *-----------------------------------------------------------------
000416100422     P attach_jvm      B
000417100422     D attach_jvm      PI              *
000418100422
000419100422     D dsAtt           ds                  likeds(JavaVMAttachArgs)
000420100422     D wwJVM           s                   like(JavaVM_p) dim(1)
000421100422     D wwJVMc          s                   like(jSize)
000422100422     D wwEnv           s               *   inz(*null)
000423100422     D wwRC            s             10I 0
000424100422      /free
000425100422
000426100422        monitor;
000427100422           wwRC = JNI_GetCreatedJavaVMs(wwJVM: 1: wwJVMc);
000428100422
000429100422           if (wwRC <> JNI_OK  or  wwJVMc = 0);
000430100422               return *NULL;
000431100422           endif;
000432100422
000433100422           JavaVM_P = wwJVM(1);
000434100422           dsAtt = *ALLx'00';
000435100422           dsAtt.version = JNI_VERSION_1_2;
000436100422
000437100422           wwRC = AttachCurrentThread (wwJVM(1): wwEnv: %addr(dsAtt));
000438100422           if (wwRC <> JNI_OK);
000439100422               wwEnv = *NULL;
000440100422           endif;
000441100422
000442100422        on-error;
000443100422           wwEnv = *NULL;
000444100422        endmon;
000445100422
000446100422        return wwEnv;
000447100422
000448100422      /end-free
000449100422     P                 E
000450100422
000451100422      *-----------------------------------------------------------------
000452100422      * Courtesy Scott Klement (www.scottklement.com)
000453100422      *  start_jvm():   Start the Java Virtual Machine (JVM)
000454100422      *
000455100422      *  NOTE: Originally, this called JNI routines to start a new JVM,
000456100422      *        but that meant that a classpath and other options needed
000457100422      *        to be set manually in the JNI invocation.
000458100422      *
000459100422      *        I decided that it would be better to reduce the complexity
000460100422      *        and let RPG start the JVM, so I merely create & destroy
000461100422      *        a string here so that RPG will automatically start the
000462100422      *        JVM for me.
000463100422      *
000464100422      *  returns a pointer to the JNI environment
000465100422      *          or *NULL upon failure.
000466100422      *-----------------------------------------------------------------
000467100422     P start_jvm       B
000468100422     D start_jvm       PI              *
000469100422
000470100422     D SndPgmMsg       PR                  ExtPgm('QMHSNDPM')
000471100422     D   MessageID                    7A   Const
000472100422     D   QualMsgF                    20A   Const
000473100422     D   MsgData                     80A   Const
000474100422     D   MsgDtaLen                   10I 0 Const
000475100422     D   MsgType                     10A   Const
000476100422     D   CallStkEnt                  10A   Const
000477100422     D   CallStkCnt                  10I 0 Const
000478100422     D   MessageKey                   4A
000479100422     D   ErrorCode                32767A   options(*varsize)
000480100422
000481100422     D O_RDWR          C                   4
000482100422     D O_CREAT         C                   8
000483100422     D M_RDWR          C                   const(438)
000484100422
000485100422     D tmpnam          PR              *   extproc('_C_IFS_tmpnam')
000486100422     D   string                      39A   options(*omit)
000487100422     D open            PR            10I 0 ExtProc('open')
000488100422     D  filename                       *   value options(*string)
000489100422     D  openflags                    10I 0 value
000490100422     D  mode                         10U 0 value options(*nopass)
000491100422     D dup             PR            10I 0 ExtProc('dup')
000492100422     D   fildes                      10I 0 Value
000493100422     D unlink          PR            10I 0 ExtProc('unlink')
000494100422     D   path                          *   Value options(*string)
000495100422
000496100422     D ErrorNull       ds
000497100422     D   BytesProv                   10I 0 inz(0)
000498100422     D   BytesAvail                  10I 0 inz(0)
000499100422
000500100422     D fd              s             10I 0
000501100422     D filename        s               *
000502100422     D key             s              4A
000503100422     D wwStr           s                   like(jString)
000504100422
000505100422      /free
000506100422
000507100422         // ---------------------------------------------------------
000508100422         // The JVM can encounter I/O errors if there aren't at least
000509100422         // 3 descriptors open. This code makes sure that there are
000510100422         // at least 3.
000511100422         // ---------------------------------------------------------
000512100422
000513100422         fd = open('/dev/null': O_RDWR);
000514100422         if (fd = -1);
000515100422             filename = tmpnam(*omit);
000516100422             fd = open(filename: O_RDWR+O_CREAT: M_RDWR);
000517100422             unlink(filename);
000518100422         endif;
000519100422
000520100422         dow ( fd < 2 );
000521100422            if (fd = -1);
000522100422                SndPgmMsg( 'CPF9897'
000523100422                         : 'QCPFMSG   *LIBL'
000524100422                         : 'Unable to open three descriptors!'
000525100422                         : 80
000526100422                         : '*ESCAPE'
000527100422                         : '*PGMBDY'
000528100422                         : 1
000529100422                         : Key
000530100422                         : ErrorNull );
000531100422                return *NULL;
000532100422            endif;
000533100422            fd = dup(fd);
000534100422         enddo;
000535100422
000536100422
000537100422         // ---------------------------------------------------------
000538100422         //  Create a string -- this'll trigger RPG to create
000539100422         //  the JVM for us.
000540100422         // ---------------------------------------------------------
000541100422
000542100422         wwStr = new_String('Temp String');
000543100422
000544100422         // ---------------------------------------------------------
000545100422         //   Get the JNI environment for the newly creaed JVM,
000546100422         //   and use it to free up the string.
000547100422         // ---------------------------------------------------------
000548100422
000549100422         JNIENV_P = attach_jvm();
000550100422         DeleteLocalRef(JNIENV_P: wwStr);
000551100422
000552100422         return JNIENV_P;
000553100422        /end-free
000554100422     P                 E
