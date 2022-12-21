000100100420      /if not defined(JAVA_STD_H)
000101100420
000102100420      /define OS400_JVM_12
000103100420      /copy QSYSINC/QRPGLESRC,JNI
000109100420      *******************************************************
000110100420      * Standard Java Types
000111100420      *
000112100420      * Some of these protypes are
000113100420      * based on Scott Klements prototypes found in hssf4
000114100420      * www.scottklement.com
000115100420      *
000116100420      *******************************************************
000117100420
000120100420     D String_getBytes...
000121100420     D                 pr          1024A   varying
000122100420     D                                     extproc(*JAVA:
000123100420     D                                     'java.lang.String':
000124100420     D                                     'getBytes')
000125100420     D
000126100420      *-----------------------------------------------------------------
000127100420      *  new String(byte[] chars)
000128100420      *  Constructor for Java String object
000129100420      *
000130100420      *  Routine from the Java Runtime Environment.
000131100420      *-----------------------------------------------------------------
000132100420     D new_String      PR                  like(jString)
000133100420     D                                     EXTPROC(*JAVA
000134100420     D                                     :'java.lang.String'
000135100420     D                                     :*CONSTRUCTOR)
000136100420     D create_from                 1024A   VARYING const
000137100420      *-----------------------------------------------------------------
000138100420
000139100420     D jMap            S               O   CLASS(*JAVA
000140100420     D                                     :'java.util.HashMap')
000141100420      *+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
000142100420      *  new_jMap
000143100420      *      Create a new Java Hashmap object
000144100420      *
000145100420      *   Returns the new Java HashMap object
000146100420      *+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
000147100420     D
000148100420     D new_jMap        PR                  like(jMap)
000149100420     D                                     ExtProc(*JAVA
000150100420     D                                     :'java.util.HashMap'
000151100420     D                                     :*CONSTRUCTOR)
000152100420      *+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
000153100420      *  jMap_put
000154100420      *     Add a key and a value to a hashmap
000155100420      *
000156100420      *+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
000157100420     D JMAP_put        PR                  like(jObject)
000158100420     D                                     EXTPROC(*JAVA
000159100420     D                                     :'java.util.HashMap'
000160100420     D                                     :'put')
000161100420     D  key                                like(jObject)
000162100420     D  value                              like(jObject)
000163100420
000164100420     D rre_jMap_put    PR                  like(jObject)
000165100420     D prMap                               like(jMap)
000166100420     D prKey                               like(jObject)
000167100420     D prValue                             like(jObject)
000168100420
000169100420      *++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
000170100420     D jInteger        S               O   CLASS(*JAVA
000171100420     D                                     :'java.lang.Integer')
000172100420      *+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
000173100420      *  new_jInteger
000174100420      *      Create a new Java Integer object
000175100420      *
000176100420      *   Returns the new Java Integer object
000177100420      *+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
000178100420     D new_jInteger...
000179100420     D                 PR                  like(jInteger)
000180100420     D                                     ExtProc(*JAVA
000181100420     D                                     :'java.lang.Integer'
000182100420     D                                     :*CONSTRUCTOR)
000183100420     D    num                        10I 0 VALUE
000184100420
000185100420     D new_Int         PR              O   EXTPROC(*JAVA
000186100420     D                                     :'java.lang.Integer'
000187100420     D                                     :'decode')
000188100420     D                                     CLASS(*JAVA
000189100420     D                                         : 'java.lang.Integer')
000190100420     D                                     Static
000191100420     D create_from                     O   CLASS(*JAVA:'java.lang.String') CONST
000192100420      *++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
000193100420      *-----------------------------------------------------------------
000194100420      *  jFileOutputStream = the Java FileOutputStream class
000195100420      *-----------------------------------------------------------------
000196100420     D jFileOutputStream...
000197100420     D                 S               O   CLASS(*JAVA
000198100420     D                                     :'java.io.FileOutputStream')
000199100420
000200100420      *-----------------------------------------------------------------
000201100420      *  jOutputStream = the Java OutputStream class
000202100420      *-----------------------------------------------------------------
000203100420     D jOutputStream   S               O   CLASS(*JAVA
000204100420     D                                     :'java.io.OutputStream')
000205100420      *-----------------------------------------------------------------
000206100420      *  new FileOutputStream(String filename)
000207100420      *
000208100420      *  Constructor for Java FileOutputStream class which is used
000209100420      *  to write new stream files.
000210100420      *
000211100420      *  Routine from the Java Runtime Environment.
000212100420      *
000213100420      *  filename = the file to create (IFS format)
000214100420      *-----------------------------------------------------------------
000215100420     D new_FileOutputStream...
000216100420     D                 PR                  like(jFileOutputStream)
000217100420     D                                     EXTPROC(*JAVA
000218100420     D                                     :'java.io.FileOutputStream'
000219100420     D                                     :*CONSTRUCTOR)
000220100420     D filename                            like(jString)
000221100420
000222100420
000223100420      *-----------------------------------------------------------------
000224100420      * FileOutputStream_close():  Close a stream file that was opened
000225100420      *            for output.
000226100420      *-----------------------------------------------------------------
000227100420     D FileOutputStream_close...
000228100420     D                 pr                  EXTPROC(*JAVA
000229100420     D                                     :'java.io.FileOutputStream'
000230100420     D                                     :'close')
000231100420
000232100420      *++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
000233100420      * ArrayList definied
000234100420      *
000235100420      *++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
000236100420
000237100420     D jArrayList      S               O   CLASS(*JAVA
000238100420     D                                     :'java.util.ArrayList')
000239100420      *+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
000240100420      *  new_jArrayList
000241100420      *      Create a new Java ArrayList object
000242100420      *
000243100420      *   Returns the new Java ArrayList object
000244100420      *+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
000245100420     D new_jArrayList...
000246100420     D                 PR                  like(jArrayList)
000247100420     D                                     ExtProc(*JAVA
000248100420     D                                     :'java.util.ArrayList'
000249100420     D                                     :*CONSTRUCTOR)
000250100420
000251100420      *+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
000252100420      *  jArrayList
000253100420      *     Add an object to the current list
000254100420      *
000255100420      *+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
000256100420     D JARRAYLIST_add...
000257100420     D                 PR              N
000258100420     D                                     EXTPROC(*JAVA
000259100420     D                                     :'java.util.ArrayList'
000260100420     D                                     :'add')
000261100420     D objToAdd                            like(jObject)
000262100420
000263100420     D rre_jArrayList_add...
000264100420     D                 PR
000265100420     D prArrayList                         like(jArrayList)
000266100420     D prObject                            like(jObject)
000267100420
000268100420
000413100420
000414100420      /define JAVA_STD_H
000415100420      /endif
