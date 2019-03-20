set MATERIALS_DIR_203=..\..\..\materials
set LIBS=%MATERIALS_DIR_203%\lib\testy.jar
erase *.class
javac -Xlint:unchecked -Xmaxerrs 5 -cp %LIBS% *.java
java -cp %LIBS%:. -ea MyGUI $1 $2 $3 $4
