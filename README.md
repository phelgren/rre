# RPG Report Engine
The RPG Report Engine is an RPG wrapper around the Jasper Report API's that simplify the
running of Jasper reports from an RPG program.

What do you need to use RPG Report Engine? Well, some familiarity with basic Java concepts like classpaths, .jar files and JVM's would be helpful. Some experience with using iReport or another Jasper Report template generator would be helpful as well, since RRE is a tool to RUN those reports, not create them. You should meet these prerequisites:

1. At least V7R2M0 of IBM i 
2.  Java version 8 installed - The Java jars and classes were compiled and tested on a Windows box running Version 8. You might be able to run it with java version 11 although I haven't had time to test it.
3. PASE installed (Licensed program in IBM i)
4.  os400.awt.native=true and java.awt.headless=true entries in your SystemDefault.properties file (either in your “home” folder or in the /QIBM/UserData/Java400 folder). These are requirements for the image generation in PASE.

## Basic concepts

RRE is designed to create an environment on your IBM i so that you can run Jasper Reports from an RPG program.  So rather than relying on a PRT file and program to create a spooled file, even one that will  output as PDF, Jasper reports is a full BI solution, open source and free, that allows you to create great looking reports that can be output to the IFS or emailed to the report submitter.

You really need to get familiar with Jasper Reports and Jasper Studio to start with.  There are plenty of tutorials and videos available online[.  This might be a good place to start ](https://community.jaspersoft.com/wiki/jasperreports-library-tutorial) That will mean learning how to use a WYSIWYG designer and connecting to DB2 (or any DB) using JDBC.  Once you have created a report you will most likely have a .jrxml file that defines the report design.  You can then run that file directly to create the report and direct the output to whatever format you wish.  HOWEVER, you will need to make sure that all of the artifacts used in the report: DB connections, images and fonts will need to be available on your IBM i as well.  The sanest approach is to start simple, using the sample programs provided, then following the same conventions before branching out on your own.  I have tried to "bundle" everything you need to get started so you can see how things hang together. I created Java wrappers of convienience and then wrapped the wrappers in RPG so they can be called from RPG.  Spend a little time walking the source code if you are interested.  The basic "RPG calling Java" technique has been around forever but kudos to Scott Klement (as usual) for his presentation and code in calling POI from RPG which was the genesis of RRE.  You'll see those conventions adopted here.

Just a note: There are **TWO** repos involved here.  The RRE repo is the RPG stuff but the RRE_java repo is equally important in that it contains the java artifacts AND the sample reports you need to run the "test" RPG programs.  I am going to make more of the code and setup a bit more flexible in the future but for now, stick with the recommendations.  Once you get the hang of how things are structured you can depart from this "static" setup that is here just to get the sample code to work.

The RRE repo has the RPG and a CL wrappers that call the Java wrappers.  All the code is in the QSOURCE file and the rre.file is a save file of not only the wrappers but a series of test programs AND a database library on which the sample Jasper Reports and the test programs are based.

The RRE_java repo contains the java code and jars that wrap the Jasper library api's.  I consolidated most of the jars into a single jar just to simplify setting the classpath. When called from the command line or another RPG program, it is the CL program RREC that sets that classpath.  It is all important that the classpath be set before calling the Java programs.  The RPGReportEngine.jar has a set of sample test programs, similar to the test program wrappers in RPG. The test programs in RPG aren't calling the Java test programs, they are invoking the Java wrappers just like the Java test programs do.  So sometimes running the Java test programs directly can help you figure out if the error is in your Java environment or the invocation from RPG.  You can run the Java programs after following the installation instructions, in a Bash shell in PASE or using QSHELL (QSH) using syntax similar to this:

java -cp /rre/lib/RPGReportEngine.jar:/rre/lib/jasperreports-6.17.0.jar:/rre/lib/activation.jar:/rre/lib/rrejars.jar:/rre/lib/fonts.jar:. com.valadd.report.engine.Test3

That trailing "." is important.  The example above would run the Java program Test3

The whole practice of calling Java from RPG is subject to quite a bit of conversation.  The biggest issue with this approach is that when an RPG programs calls a Java method, a JVM instance is instantiated and configured for just that call.  RPG really knows nothing about what is going on in that world, it just makes the invocation and waits for a response.  If something goes wrong (and it often does) then RPG goes along without giving the Java failure much thought.  That is why you will explicit allocation and deallocation of memory in the RPG calls.  Without it, out of memory errors would soon occur. Just remember that as you make modifications and enhance the functionality.  Dieter Bender wrote an app that implements RPG to Java in a resource-sparing, more humane way.  Take a look at [AppServer4RPG](https://sourceforge.net/p/appserver4rpg/) 

## Installation:
The easiest way to start is to restore the RRE library from the save file (rre.file is an IBM i SAVF) using the RSTLIB command and setting the proper authorities afterward. Then grab the lib and the reports folder from the RRE_java repo.  By default, the installation assumes that you will create a folder called rre in the root of your IFS.  In that folder you will copy the lib and reports folder. You can actually restore all of this stuff wherever you want but then you'll have to tweak settings, particularly the CL that sets the classpath, to make it all work again. My suggestion is to follow the “easy” way and then, once you feel comfortable with how it all works, then start moving things where you want them to finally be.

If you follow the conventions and take a look at CL program that sets the classpath, you will see this:

```
             ADDENVVAR  ENVVAR(CLASSPATH) +
                          VALUE('/rre/lib/RPGReportEngine.jar:/rre/lib/jasperreports-6.17.0.jar:+
                          /rre/lib/activation.jar:/rre/lib/rrejars.jar:/rre/lib/fonts.jar') +
                          REPLACE(*YES)
```
What does that tell you?  That you should have a structure similar to this in the IFS:

A folder named "rre" in the root of the IFS
A subfolder of "rre" named "lib"
And within the "lib" subfolder you should have the following jars:

RPGReportEngine.jar
jasperreports-6.17.0.jar
activation.jar
rrejars.jar  (these are all the Jasper Reports dependencies for 6.17.0)
fonts.jar

Beyond just getting the Java environment and classpath correct, there are some additional artifacts that the test programs use for getting and outputting the sample Jasper Reports:

/reports  This should be on the root of the IFS.

And that folder has two sub-folders, one for report output called report_output and one for the templates called report_templates

/reports/report_output

/reports/report_templates

The /reports/report_templates  folder has the following files:
Employee_Gender_Chart.jasper
Employee_Gender_Chart.jrxml
Employee_Listing.html
Employee_Listing.jasper
Employee_Listing.jrxml
Employee_Listing_new.jasper
Employee_Listing_new.jrxml
Employee_Listing_with_Parms.jasper
Employee_Listing_with_Parms.jrxml

One subfolder in the /report/report_templates folder is called images (so, the complete folder structure would be /report/report_templates/images). It has two files that are used in the templates :    IBM_i_logo.jpg and VasSmallLogo.jpg.  As an FYI, images can be a challenge to include in a report.  When designing a report in Windows, for example, your images may be in a specific hard coded path whereas when you deploy to IBM i it may be a relative reference.  You may have to tweak the jrmxl after you deploy so that the images can be found.  If you receive a Java/Jasper error on a report with an image, you may want to remove the image reference and try again.

## A note about fonts
Embedded fonts in a PDF are a bit of an art.  You'll find that the fonts you use in Jasper Studio as you design the report may not appear in the PDF version of the report.  This is a known issue and a bit of a challenge to solve.  Basically you export your fonts to a jar and package them there.  I have included a VERY basic set of fonts in the fonts.jar.  You should be able to add/create more and included them in a jar of your own (make sure you include the jar in the classpath) or just replace the fonts.jar with one of your own.  More about fonts in Jasper Reports can be found [here](https://helicaltech.com/new-custom-fonts-jaspersoft-studio-jasper-server):

## Post-installation steps:
Everything is pretty self contained. You have report templates, data files, Java .jars, everything you
need to run the CL program to invoke the test reports.

There is a sample rre.properties file in the REE_java repo.  You should put that in the /rre folder in the IFS root (if you took the defaults in installation). You will need to change the JDBC driver properties in the file so that the connection information is correct. The most important things are the IP address (localhost is the default) and the user name and password for the connection.

## Running the Test programs:
I tried to throw together some test programs so that you can see how the API's should be invoked. The easiest test program is probably test3 because it uses the settings in the properties file to connect to the database. Run it as follows:
CALL PGM(RREC) PARM(TEST3_RRE PDF)

That **assumes** that you have RRE in your library list.  That you have an /rre folder and in that folder is the rre.properties file that you have updated, a folder called lib that has a spring folder and three jars, a reports folder with two folders: report_output and report_templates.  

## Things to think about
Start by getting familiar with the Jasper Studio designer.  Run it locally, connecting using JDBC.  All the samples use the EMPBASIC table and that guy should be found in your RRE library after you install it. If you can access the data and run the samples locally, that generally means you should be OK when you call the RPG.

The java code itself is just a wrapper over the Jasper core API's.  Really, they are just convienece methods to make using and calling the programs easier.  The source for the java code is in the RRE_java repo.  When I was building and testing the java code, I started out by running the java code locally, connecting to the IBM using the IP address for DB access.  The settings are in the file called /rre.properties in the rre folder.

Running the RPG code to call the Java wrappers is a little dicey.  The CL program will set the classpath where the proper jars can be found. You'll need RRE library in the library list if you call the test programs.  Running these guys interactively is not very efficient.  Generally, a java JVM is created, and then destroyed, each time the call is made.  At some point I'll either add, or someone can contribute, a solution that will allow a JVM to be running and then invoke the RRE java end of things using a data queue or some other mechanism.  Right now it WILL work, but it ain't very snappy, even on an IBM i.

**Debugging java programs called from RPG can be a drag.**  The most common issue is that the jars aren't found OR the jasper report template has an error.  Common errors at the template end of things are image artifacts that aren't found.  Remember that the reports run on the IBM i side of things and paths to the images need to reference IFS locations.

If push comes to shove, email me.  I am pete and you can email me at petesworkshop.com.  You can also find me on the midrange mailing list.
