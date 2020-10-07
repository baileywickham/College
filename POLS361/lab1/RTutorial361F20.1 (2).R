#####R Tutorial: Week Two####
####Loading packages####

library(foreign)
library(plyr)
library(stats)
library(dplyr)

####importing data####


class.data<-read.csv ("~/workspace/college/POLS361/lab1/F20ClassDataset.csv")

####attaching data makes the dataset the 'default'####

attach(class.data) 

###let's take a look...###
####setting variable names####

colnames(class.data)<-c("Age","Gender","HoursStudying","NumberSiblings", 
                        "Height", "FaveMeal","Vote","StatsScore","Excitement")

####looking at the data#####
summary(class.data)
summary(class.data$FaveMeal)

###R reads the entries differently based on capitalization###
###we can fix this!###

class.data$FaveMeal[class.data$FaveMeal == 'breakfast']<-"Breakfast"
class.data$FaveMeal[class.data$FaveMeal == 'dinner']<-"Dinner"

summary(class.data$FaveMeal)


###what about the 'lunch' answers?"

x<-class.data$FaveMeal
x
x2<-trimws(x)
x3<-as.factor(x2)
class.data$FaveMeal<-x3
summary(class.data$FaveMeal)

summary(class.data)

##let's clean the rest of the variables###

class.data$Gender[class.data$Gender == 'female']<-'Female'
class.data$Gender[class.data$Gender == 'male']<-'Male'

summary(class.data$Gender)

class.data$Vote[class.data$Vote == 'es']<-'Yes'
class.data$Vote[class.data$Vote == 'yes']<-'Yes'

summary(class.data)


###we have missing values here. let's remove them####


class.data$Excitement[class.data$Excitement<0] <- NA

summary(class.data$Excitement)

####checking final results###
summary(class.data)


####tranforming variables to factors---> nominal measures####
class.data$Gender <-as.factor(class.data$Gender)
class.data$Gender<-droplevels(class.data$Gender)                     
summary(class.data)

class.data$Vote<-as.factor(class.data$Vote)
class.data$Vote<-droplevels(class.data$Vote)

summary(class.data)

###frequency tables####

table(class.data$FaveMeal)
my.table<-table(class.data$FaveMeal)
prop.table(my.table)
prop.table(my.table)*100
my.prop.table<-prop.table(my.table)
my.prop.table*100

###a bad table###
bad.table<-table(class.data$HoursStudying)
print(bad.table)

####grouping values/creating new variables###

class.data$StudyGroup[class.data$HoursStudying>=10 & class.data$HoursStudying<=14]<-1
class.data$StudyGroup[class.data$HoursStudying>=15 & class.data$HoursStudying<=19]<-2
class.data$StudyGroup[class.data$HoursStudying>=20]<-3

summary(class.data$StudyGroup)
table(class.data$StudyGroup)

###let's clean up this new variable###

class.data$StudyGroup <-factor(class.data$StudyGroup, 
                        levels = c('1','2','3'),
                        labels = c('10 - 14 hrs','15 - 19 hrs','20 or more hrs'))

summary(class.data$StudyGroup)

#####generate histogram#####
  
hist(class.data$NumberSiblings)

###try it with our new variable###
hist(class.data$StudyGroup)

###R won't let us make a histogram with this data
###why? because histograms are for interval/ratio data
###we can use a barplot instead though

###so we make a frequency table first

study.table<-table(class.data$StudyGroup)

###now we can use the 'barplot' command with our table

my.plot<-barplot(study.table)

###nice!
###R has a ton of customization options
###let's label our plot
###functions in R take arguments--these arguments affect how the function is carried out
####one argument for graphs is 'main', which provides a title for a graph

my.plot<-barplot(study.table, main = "Hours Studied Per Week")

###want to know what else you can customize?
###for any command, you can type '?' and the command
?barplot

###this will show a list of arguments supported by the function, as 
###well as the default settings

###try changing the value 'color' here
my.plot<-barplot(study.table, main = "Hours Studied Per Week", col = 10)

###if you are curious, you can see the R color palette by typing:

colors()

####what do you think will happen to the barplot when you run this command:
my.plot<-barplot(study.table, main = "Hours Studied Per Week", col = c(5, 30, 100))

###crosstabulations/'crosstabs'###
###let's figure out what the proportions of males and females who prefer each of the meal types### 

###as we have learned, the 'table' function will give us counts of our variables
table(class.data$Gender)
gender.table<-table(class.data$Gender)
meal.table<-table(class.data$FaveMeal)
print(meal.table)

gender.table
meal.table

###now, we can use the 'table' function to make a 2-way table

my.crosstab<-table(class.data$Gender,class.data$FaveMeal)

my.crosstab

####let's get the proportions###
prop.table(my.crosstab)

my.prop.table<-prop.table(my.crosstab)

### My Results
hist(class.data$Height)

class.data$StatsSummary[class.data$StatsScore <= 10]<-1
class.data$StatsSummary[class.data$StatsScore > 10 & class.data$StatsScore<=14]<-2
class.data$StatsSummary[class.data$StatsScore >=15 & class.data$StatsScore<=19]<-3
class.data$StatsSummary[class.data$StatsScore>=20]<-4

class.data$StatsSummary <-factor(class.data$StatsSummary, 
                                 levels = c('1','2','3', '4'),
                                 labels = c('Fair', 'Good','Excellent','Superior'))
summary(class.data$StatsSummary)
table(class.data$StatsSummary)
barplot(table(class.data$StatsSummary), main="Quiz Score Distribution",
        xlab="Quiz Scores")

prop.table(table(class.data$Gender, class.data$StatsSummary))
