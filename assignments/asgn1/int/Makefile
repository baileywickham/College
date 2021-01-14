NAME=Int

default:
	hadoop com.sun.tools.javac.Main *.java
	jar cvf $(NAME).jar	*.class

run:
	-hadoop fs -rm -r /user/$(USER)/output
	hadoop jar $(NAME).jar $(NAME)Driver /user/$(USER)/input /user/$(USER)/output

output:
	hadoop fs -cat /user/$(USER)/output/*

copy_input:
	hadoop fs -rm -r /user/$(USER)/input
	hadoop fs -mkdir /user/$(USER)/input
	hadoop fs -put data /user/$(USER)/input/

clean:
	rm *.class *.jar
