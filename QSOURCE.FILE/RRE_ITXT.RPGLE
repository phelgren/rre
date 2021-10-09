      * Utility routines for working with RRE to create iText Reports
      * spreadsheets from ILE RPG.
      *
      *  To compile:
      *
      *  CRTRPGMOD QTEMP/RRE_ITXT SRCFILE(rre/QSOURCE) DBGVIEW(*LIST)
      *
      *CRTSRVPGM SRVPGM(RRE/RRE_ITXT) MODULE(QTEMP/RRE_ITXT) SRCFILE(RRE/QSOURCE) SRCMBR(RREITXTBND)
      *   TEXT('Utilties for creating iText Reports') ACTGRP(RRE)
      *
      *
      *  CRTBNDDIR BNDDIR(RRE/RRE_ITXT)
      *  ADDBNDDIRE BNDDIR(RRE/RRE_ITXT) OBJ((RRE/RRE_ITXT *SRVPGM))
      *
     H NOMAIN OPTION(*NODEBUGIO: *SRCSTMT: *NOSHOWCPY)
     H THREAD(*SERIALIZE)
     H BNDDIR('QC2LE')
     D start_jvm       PR              *
     D attach_jvm      PR              *
      * PI's for the start_jvm and attach_jvm are at the bottom
      /copy QSOURCE,RRE_ITXT_H
      /copy QSOURCE,RRE_H

      *+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
      *  rreRV_initialize
      *        Initialize the ReportView object after passing the contructor parameters
      *
      *  Basically will instantiate the pdf document and create the header, report names, and file
      *  Java method returns void
      *
      *+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
     P rreRV_initialize...
     P                 B                   EXPORT
     D rreRV_initialize...
     D                 PI
     D  peReportView                       like(jReportView)

      /free

            RREReportView_initialize(peReportView);

      /end-free
     P                 E
      *+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
      *  rreRV_finalize
      *        Finalize the report, outputting contents and cleaning up
      *  Java method returns void
      *
      *+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
     P rreRV_finalize...
     P                 B                   EXPORT
     D rreRV_finalize...
     D                 PI            10I 0
     D  peReportView                       like(jReportView)
     D  peRows                       10I 0 value
     D lRows           s             10I 0

      /free

            lRows = RREReportView_finalize(peReportView:peRows);

            return lRows;

      /end-free
     P                 E
      *+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
      *  rreRV_setGrayFill
      *        Changes the default background fill grayscale
      *   Java method returns void
      *+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
     P rreRV_setGrayFill...
     P                 B                   EXPORT
     D rreRV_setGrayFill...
     D                 PI
     D  peReportView                       like(jReportView)
     D  peFill                        4F   value

      /free

            RREReportView_setGrayFill(peReportView:peFill);

      /end-free
     P                 E
      *+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
      *  rreRV_setGrayFill
      *        Changes the default background fill grayscale
      *   Java method returns void
      *+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
     P rreRV_addCell...
     P                 B                   EXPORT
     D rreRV_addCell...
     D                 PI
     D  peReportView                       like(jReportView)
     D  peCellContent              1024A   const varying
     D  cellContents   s                   like(jString)
      /free
           cellContents =  new_String(peCellContent);
           RREReportView_addCell(peReportView:cellContents);

      /end-free
     P                 E
      *------------------------------------------------------------
      * Add Ojbects to and ArrayList
      *
      *------------------------------------------------------------
     P rre_jArrayList_add...
     P                 B                   EXPORT
     D rre_jArrayList_add...
     D                 PI
     D    peArrayList                      like(jArrayList)
     D    peObjToAdd                        like(jobject)

      /free

         JARRAYLIST_add(peArrayList:peObjToAdd);

      /end-free
     P                 E
      *-----------------------------------------------------------------
      *  rre_freeLocalRef(Ref)
      *
      *  Service program utility to free a local reference.
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
      *               callp  rre_freeLocalRef(ObjectName)
      *
      *      for example, if you create a String, use it to create
      *        an output stream, and then don't need the string anymore,
      *        you might do something like this:
      *
      *               eval   Blah = new_String('/path/to/myfile.txt')
      *               eval   File = new_FileOutputStream(Blah)
      *               callp  rre_freeLocalRef(Blah)
      *-----------------------------------------------------------------
     P rre_freeLocalRef...
     P                 B                   EXPORT
     D rre_freeLocalRef...
     D                 PI
     D    peRef                            like(jobject)
     D wwEnv           s               *   static inz(*null)

      /free

          if (wwEnv = *NULL);
              wwEnv = rre_get_jni_env();
          endif;

          JNIENV_P = wwEnv;
          DeleteLocalRef(wwEnv: peRef);

      /end-free
     P                 E
      *----------------------------------------------------------------
      * Courtesy Scott Klement (www.scottklement.com)
      * rre_begin_object_group():  Start a new group of objects
      *    which will all be freed when hssf_end_object_group()
      *    gets called.
      *
      *   peCapacity = maximum number of objects that can be
      *        referenced within this object group.
      *
      *  NOTE: According to the 1.2 JNI Spec, you can create more
      *        objects in the new frame than peCapacity allows.  The
      *        peCapacity is the guarenteed number.   When no object
      *        groups are used, 16 references are guarenteed, so if
      *        you specify 16 here, that would be comparable to a
      *        "default value".
      *
      * Returns 0 if successful, or -1 upon error
      *-----------------------------------------------------------------
     P rre_begin_object_group...
     P                 B                   EXPORT
     D rre_begin_object_group...
     D                 PI            10I 0
     D    peCapacity                 10I 0 value

     D wwEnv           s               *
     D wwRC            s             10I 0

      /free

       wwEnv = rre_get_jni_env();
       if (wwEnv = *NULL);
           return -1;
       endif;

       JNIENV_P = wwEnv;

       if  ( PushLocalFrame (wwEnv: peCapacity) <> JNI_OK );
           return -1;
       else;
           return 0;
       endif;

      /end-free
     P                 E

      *-----------------------------------------------------------------
      * Courtesy Scott Klement (www.scottklement.com)
      * rre_end_object_group():  Frees all Java objects that
      *    have been created since calling hssf_begin_object_group()
      *
      *        peOldObj = (see below)
      *        peNewObj = Sometimes it's desirable to preserve one
      *            object by moving it from the current object group
      *            to the parent group.   These parameters allow you
      *            to make that move.
      *
      * Returns 0 if successful, or -1 upon error
      *-----------------------------------------------------------------
     P rre_end_object_group...
     P                 B                   EXPORT
     D rre_end_object_group...
     D                 PI            10I 0
     D   peOldObj                          like(jObject) const
     D                                     options(*nopass)
     D   peNewObj                          like(jObject)
     D                                     options(*nopass)

     D wwOld           s                   like(jObject) inz(*NULL)
     D wwNew           s                   like(jObject)

      /free

          JNIENV_p = rre_get_jni_env();
          if (JNIENV_p = *NULL);
              return -1;
          endif;

          if %parms >= 2;
              wwOld = peOldObj;
          endif;

          wwNew = PopLocalFrame (JNIENV_p: wwOld);

          if %parms >= 2;
              peNewObj = wwNew;
          endif;

          return 0;

      /end-free
     P                 E
      *-----------------------------------------------------------------
      * Courtesy Scott Klement (www.scottklement.com)
      *  rre_get_jni_env():
      *
      *  Service program utility to get a pointer to the JNI environment
      *  you'll need this pointer in order to call many of the JNI
      *  routines.
      *
      *  returns the pointer, or *NULL upon error
      *-----------------------------------------------------------------
     P rre_get_jni_env...
     P                 B                   EXPORT
     D rre_get_jni_env...
     D                 PI              *

     D wwEnv           s               *

      /free
        wwEnv = attach_jvm();
        if (wwEnv = *NULL);
           wwEnv = start_jvm();
        endif;

        return wwEnv;
      /end-free
     P                 E
      *-----------------------------------------------------------------
      * Courtesy Scott Klement (www.scottklement.com)
      * attach_jvm():  Attach to JVM if it's running
      *
      * Returns a pointer to the JNI environment, or *NULL upon error
      *-----------------------------------------------------------------
     P attach_jvm      B
     D attach_jvm      PI              *

     D dsAtt           ds                  likeds(JavaVMAttachArgs)
     D wwJVM           s                   like(JavaVM_p) dim(1)
     D wwJVMc          s                   like(jSize)
     D wwEnv           s               *   inz(*null)
     D wwRC            s             10I 0
      /free

        monitor;
           wwRC = JNI_GetCreatedJavaVMs(wwJVM: 1: wwJVMc);

           if (wwRC <> JNI_OK  or  wwJVMc = 0);
               return *NULL;
           endif;

           JavaVM_P = wwJVM(1);
           dsAtt = *ALLx'00';
           dsAtt.version = JNI_VERSION_1_2;

           wwRC = AttachCurrentThread (wwJVM(1): wwEnv: %addr(dsAtt));
           if (wwRC <> JNI_OK);
               wwEnv = *NULL;
           endif;

        on-error;
           wwEnv = *NULL;
        endmon;

        return wwEnv;

      /end-free
     P                 E

      *-----------------------------------------------------------------
      * Courtesy Scott Klement (www.scottklement.com)
      *  start_jvm():   Start the Java Virtual Machine (JVM)
      *
      *  NOTE: Originally, this called JNI routines to start a new JVM,
      *        but that meant that a classpath and other options needed
      *        to be set manually in the JNI invocation.
      *
      *        I decided that it would be better to reduce the complexity
      *        and let RPG start the JVM, so I merely create & destroy
      *        a string here so that RPG will automatically start the
      *        JVM for me.
      *
      *  returns a pointer to the JNI environment
      *          or *NULL upon failure.
      *-----------------------------------------------------------------
     P start_jvm       B
     D start_jvm       PI              *

     D SndPgmMsg       PR                  ExtPgm('QMHSNDPM')
     D   MessageID                    7A   Const
     D   QualMsgF                    20A   Const
     D   MsgData                     80A   Const
     D   MsgDtaLen                   10I 0 Const
     D   MsgType                     10A   Const
     D   CallStkEnt                  10A   Const
     D   CallStkCnt                  10I 0 Const
     D   MessageKey                   4A
     D   ErrorCode                32767A   options(*varsize)

     D O_RDWR          C                   4
     D O_CREAT         C                   8
     D M_RDWR          C                   const(438)

     D tmpnam          PR              *   extproc('_C_IFS_tmpnam')
     D   string                      39A   options(*omit)
     D open            PR            10I 0 ExtProc('open')
     D  filename                       *   value options(*string)
     D  openflags                    10I 0 value
     D  mode                         10U 0 value options(*nopass)
     D dup             PR            10I 0 ExtProc('dup')
     D   fildes                      10I 0 Value
     D unlink          PR            10I 0 ExtProc('unlink')
     D   path                          *   Value options(*string)

     D ErrorNull       ds
     D   BytesProv                   10I 0 inz(0)
     D   BytesAvail                  10I 0 inz(0)

     D fd              s             10I 0
     D filename        s               *
     D key             s              4A
     D wwStr           s                   like(jString)

      /free

         // ---------------------------------------------------------
         // The JVM can encounter I/O errors if there aren't at least
         // 3 descriptors open. This code makes sure that there are
         // at least 3.
         // ---------------------------------------------------------

         fd = open('/dev/null': O_RDWR);
         if (fd = -1);
             filename = tmpnam(*omit);
             fd = open(filename: O_RDWR+O_CREAT: M_RDWR);
             unlink(filename);
         endif;

         dow ( fd < 2 );
            if (fd = -1);
                SndPgmMsg( 'CPF9897'
                         : 'QCPFMSG   *LIBL'
                         : 'Unable to open three descriptors!'
                         : 80
                         : '*ESCAPE'
                         : '*PGMBDY'
                         : 1
                         : Key
                         : ErrorNull );
                return *NULL;
            endif;
            fd = dup(fd);
         enddo;


         // ---------------------------------------------------------
         //  Create a string -- this'll trigger RPG to create
         //  the JVM for us.
         // ---------------------------------------------------------

         wwStr = new_String('Temp String');

         // ---------------------------------------------------------
         //   Get the JNI environment for the newly creaed JVM,
         //   and use it to free up the string.
         // ---------------------------------------------------------

         JNIENV_P = attach_jvm();
         DeleteLocalRef(JNIENV_P: wwStr);

         return JNIENV_P;
        /end-free
     P                 E
