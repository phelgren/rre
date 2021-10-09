      /if not defined(JAVA_STD_H)

      /define OS400_JVM_12
      /copy QSYSINC/QRPGLESRC,JNI
      *******************************************************
      * Standard Java Types
      *
      * Some of these protypes are
      * based on Scott Klements prototypes found in hssf4
      * www.scottklement.com
      *
      *******************************************************

     D String_getBytes...
     D                 pr          1024A   varying
     D                                     extproc(*JAVA:
     D                                     'java.lang.String':
     D                                     'getBytes')
     D
      *-----------------------------------------------------------------
      *  new String(byte[] chars)
      *  Constructor for Java String object
      *
      *  Routine from the Java Runtime Environment.
      *-----------------------------------------------------------------
     D new_String      PR                  like(jString)
     D                                     EXTPROC(*JAVA
     D                                     :'java.lang.String'
     D                                     :*CONSTRUCTOR)
     D create_from                 1024A   VARYING const
      *-----------------------------------------------------------------

     D jMap            S               O   CLASS(*JAVA
     D                                     :'java.util.HashMap')
      *+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
      *  new_jMap
      *      Create a new Java Hashmap object
      *
      *   Returns the new Java HashMap object
      *+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
     D
     D new_jMap        PR                  like(jMap)
     D                                     ExtProc(*JAVA
     D                                     :'java.util.HashMap'
     D                                     :*CONSTRUCTOR)
      *+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
      *  jMap_put
      *     Add a key and a value to a hashmap
      *
      *+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
     D JMAP_put        PR                  like(jObject)
     D                                     EXTPROC(*JAVA
     D                                     :'java.util.HashMap'
     D                                     :'put')
     D  key                                like(jObject)
     D  value                              like(jObject)

     D rre_jMap_put    PR                  like(jObject)
     D prMap                               like(jMap)
     D prKey                               like(jObject)
     D prValue                             like(jObject)

      *++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
     D jInteger        S               O   CLASS(*JAVA
     D                                     :'java.lang.Integer')
      *+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
      *  new_jInteger
      *      Create a new Java Integer object
      *
      *   Returns the new Java Integer object
      *+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
     D new_jInteger...
     D                 PR                  like(jInteger)
     D                                     ExtProc(*JAVA
     D                                     :'java.lang.Integer'
     D                                     :*CONSTRUCTOR)
     D    num                        10I 0 VALUE

     D new_Int         PR              O   EXTPROC(*JAVA
     D                                     :'java.lang.Integer'
     D                                     :'decode')
     D                                     CLASS(*JAVA
     D                                         : 'java.lang.Integer')
     D                                     Static
     D create_from                     O   CLASS(*JAVA:'java.lang.String') CONST
      *++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
      *-----------------------------------------------------------------
      *  jFileOutputStream = the Java FileOutputStream class
      *-----------------------------------------------------------------
     D jFileOutputStream...
     D                 S               O   CLASS(*JAVA
     D                                     :'java.io.FileOutputStream')

      *-----------------------------------------------------------------
      *  jOutputStream = the Java OutputStream class
      *-----------------------------------------------------------------
     D jOutputStream   S               O   CLASS(*JAVA
     D                                     :'java.io.OutputStream')
      *-----------------------------------------------------------------
      *  new FileOutputStream(String filename)
      *
      *  Constructor for Java FileOutputStream class which is used
      *  to write new stream files.
      *
      *  Routine from the Java Runtime Environment.
      *
      *  filename = the file to create (IFS format)
      *-----------------------------------------------------------------
     D new_FileOutputStream...
     D                 PR                  like(jFileOutputStream)
     D                                     EXTPROC(*JAVA
     D                                     :'java.io.FileOutputStream'
     D                                     :*CONSTRUCTOR)
     D filename                            like(jString)


      *-----------------------------------------------------------------
      * FileOutputStream_close():  Close a stream file that was opened
      *            for output.
      *-----------------------------------------------------------------
     D FileOutputStream_close...
     D                 pr                  EXTPROC(*JAVA
     D                                     :'java.io.FileOutputStream'
     D                                     :'close')

      *++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
      * ArrayList definied
      *
      *++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

     D jArrayList      S               O   CLASS(*JAVA
     D                                     :'java.util.ArrayList')
      *+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
      *  new_jArrayList
      *      Create a new Java ArrayList object
      *
      *   Returns the new Java ArrayList object
      *+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
     D new_jArrayList...
     D                 PR                  like(jArrayList)
     D                                     ExtProc(*JAVA
     D                                     :'java.util.ArrayList'
     D                                     :*CONSTRUCTOR)

      *+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
      *  jArrayList
      *     Add an object to the current list
      *
      *+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
     D JARRAYLIST_add...
     D                 PR              N
     D                                     EXTPROC(*JAVA
     D                                     :'java.util.ArrayList'
     D                                     :'add')
     D objToAdd                            like(jObject)

     D rre_jArrayList_add...
     D                 PR
     D prArrayList                         like(jArrayList)
     D prObject                            like(jObject)



      /define JAVA_STD_H
      /endif
