OLD=Int
NAME=SecondarySort

all: build run output

build:
	hadoop com.sun.tools.javac.Main *.java
	jar cvf $(NAME).jar	*.class

move_name:
	sed -i 's/$(OLD)Driver/$(NAME)Driver/g' *.java
	sed -i 's/$(OLD)Mapper/$(NAME)Mapper/g' *.java
	sed -i 's/$(OLD)Reducer/$(NAME)Reducer/g' *.java


run:
	hadoop fs -rm -r -f /user/$(USER)/output
	hadoop jar $(NAME).jar $(NAME)Driver /user/$(USER)/input /user/$(USER)/output

output:
	hadoop fs -cat /user/$(USER)/output/*

copy_input:
	hadoop fs -rm -r -f /user/$(USER)/input
	hadoop fs -mkdir /user/$(USER)/input
	hadoop fs -put data /user/$(USER)/input/

clean:
	rm *.class *.jar

java:
	javac CountDates.java
	java CountDates
.PHONY: clean all
