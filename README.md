# RPG Report Engine
The RPG Report Engine is an RPG wrapper around the Jasper Report API's that simplify the
running of the reports from an RPG program.

What do you need to use RPG Report Engine? Well, some familiarity with basic Java concepts like classpaths, .jar files and JVM's would be helpful. Some experience with using iReport or another Jasper Report template generator would be helpful as well, since RRE is a tool to RUN those reports, not create them. You should meet these prerequisites:

1. At least V7R2M0 of IBM i 
2.  Java version 8 installed - The Java jars and classes were compiled and tested on a Windows box running Version 8. You might be able to run it with java version 11 although I haven't had time to test it.
3. PASE installed (Licensed program in IBM i)
4.  os400.awt.native=true and java.awt.headless=true entries in your SystemDefault.properties file (either in your “home” folder or in the /QIBM/UserData/Java400 folder). These are requirements for the image generation in PASE.

Just a note: There are **TWO** repos involved here.  The RRE repo is the RPG stuff but the RRE_java repo is equally important in that it contains the java artifacts AND the sample reports you need to run the "test" RPG programs.  I am going to make more of the code and setup a bit more flexible in the future but for now, stick with the recommendations.  Once you get the hang of how things are structured you can depart from this "static" setup that is here just to get the sample code to work.

## Installation:
The easiest way to start is to restore the RRE library from the save file (rre.file is an IBM i SAVF) using the RSTLIB command and setting the proper authorities afterward. Then grab the lib and the reports folder from the RRE_java repo.  By default, the installation assumes that you will create a folder called rre in the root of your IFS.  In that folder you will copy the lib and reports folder. You can actually restore all of this stuff wherever you want but then you'll have to tweak settings, particularly the CL that sets the classpath, to make it all work again. My suggestion is to follow the “easy” way and then, once you feel comfortable with how it all works, then start moving things where you want them to finally be.

## Post-installation steps:
Everything is pretty self contained. You have report templates, data files, Java .jars, everything you
need to run the CL program to invoke the test reports.

There is a sample rre.properties file in the REE_java repo.  You should put that in the /rre folder in the IFS root (if you took the defaults in installation). You will need to change the JDBC driver properties in the file so that the connection
information is correct. The most important things are the IP address (localhost is the default) and the user name and password for the connection.

## Running the Test programs:
I tried to throw together some test programs so that you can see how the API's should be invoked. The easiest test program is probably test3 because it uses the settings in the properties file to connect to the database. Run it as follows:
CALL PGM(RREC) PARM(TEST3_RRE PDF)

That **assumes** that you have RRE in your library list.  That you have an /rre folder and in that folder is the rre.properties file that you have updated, a folder called lib that has a spring folder and three jars, a reports folder with two folders: report_output and report_templates.  

## Things to think about
Start by getting familiar with the Jasper Studio designer.  Run it locally, connecting using JDBC.  All the samples use the EMPLOYEE table and that guy should be found in your RRE library after you install it. If you can access the data and run the samples locally, that generally means you should be OK when you call the RPG.

The java code itself is just a wrapper over the Jasper core API's.  Really, they are just convienece methods to make using and calling the programs easier.  The source for the java code is in the RRE_java repo.  When I was building and testing the java code, I started out by running the java code locally, connecting to the IBM using the IP address for DB access.  The settings are in the file called /rre.properties in the rre folder.

Running the RPG code to call the Java wrappers is a little dicey.  The CL program will set the classpath where the proper jars can be found. You'll need RRE library in the library list if you call the test programs.  Running these guys interactively is not very efficient.  Generally, a java JVM is created, and then destroyed, each time the call is made.  At some point I'll either add, or someone can contribute, a solution that will allow a JVM to be running and then invoke the RRE java end of things using a data queue or some other mechanism.  Right now it WILL work, but it ain't very snappy, even on an IBM i.

Debugging java programs called from RPG can be a drag.  The most common issue is that the jars aren't found OR the jasper report template has an error.  Common errors at the template end of things are image artifacts that aren't found.  Remember that the reports run on the IBM i side of things and paths to the images need to reference IFS locations.

If push comes to shove, email me.  I am pete and you can email me at petesworkshop.com.  You can also find me on the midrange mailing list.
