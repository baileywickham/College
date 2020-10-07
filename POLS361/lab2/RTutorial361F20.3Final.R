####Week 3 Stuff####
###part 1###
library(foreign)
library(plyr)
library(stats)
library (dplyr)

data<-read.csv ("~/Downloads/IntroDataSet.csv")
data1<-read.csv ("~/Downloads/Assignment1.csv")

colnames(data)<-c("ObamaFT","HealthInsurance","PartyID","ClimateChangeAttitude")
colnames(data1)<-c("LikelyVote","BirthYear","HomeOwner","Gender")

data$ObamaFT[data$ObamaFT<0] <- NA
data$HealthInsurance[data$HealthInsurance<0] <- NA
data$PartyID[data$PartyID<0] <- NA
data$ClimateChangeAttitude[data$ClimateChangeAttitude<0] <- NA

data1$LikelyVote[data1$LikelyVote<0] <- NA
data1$BirthYear[data1$BirthYear<0]<-NA
data1$HomeOwner[data1$HomeOwner<0]<-NA
data1$Gender[data1$Gender<0]<-NA


summary(data)
summary(data1)


data1$Gender <-factor(data1$Gender,
                      levels = c('1', '2','3'),
                      labels = c('Male','Female','Other'))

data1$HomeOwner <-factor(data1$HomeOwner, 
                         levels = c('1','2','3','4'),
                         labels = c('Pay Rent','Pay Mortgage','Own Home','Other'))




#Slides 7 - 13
#mean, median, mode

###finding the mode
###categorical data
###let's clean up the "PartyID" variable
data$NewPartyID[data$PartyID >=1 & data$PartyID <=3]<-1
data$NewPartyID[data$PartyID == 4]<-2
data$NewPartyID[data$PartyID >=5 & data$PartyID <=7]<-3

data$NewPartyID <-factor(data$NewPartyID,
                             levels = c('1', '2','3'),
                             labels = c('Democrat','Independent','Republican'))
###just make a table
NewPartyIDFreq<-table(data$NewPartyID)
print(NewPartyIDFreq)

###we can see the modal respondent is a Democrat
###note that this not the same as saying "most of the respondents are Democrats"

partyID.table<-prop.table(NewPartyIDFreq)
print(partyID.table)
###we find that while Democrats are the most frequent, response
###they still only account for 46% of the data, or less than 50%

###finding the median
### conceptually...
###to find the median, we would need to arrange all of the values in a vector
###from least to greatest
###here's one way to do this in R
data$ClimateChangeAttitude
CCA <-array(data$ClimateChangeAttitude)[!is.na(data$ClimateChangeAttitude)]

###this command extracts all the non-missing values in the Climate Change variable
###then we can sort them in order
sorted.CCA <-sort(CCA)

###now we have all the values in order. To find N (the number of observations)
###we can use the length function

length(sorted.CCA)

###so we know there are 4180 cases. The formula for locating the median is (N + 1)/2
###we can do that in R

med<-(length(sorted.CCA)+1)/2

###this tells us the median is at the 2090.5th place in the data
###that is, it is halfway between the 2090th value and the 2091th value
###we can [] to extract those values
###the 2090th value
sorted.CCA[2090]

###the 2091st value
sorted.CCA[2091]

###obviously, the mean of these two values is 3
###but if we wanted R to calculate it
median.CCA <-(sorted.CCA[2090]+sorted.CCA[2091])/2
median.CCA
###that's a lot of work, but it shows what R can do if you understand
###the concepts. It also shows why writing functions can be useful


###the median function
###note that for this function to work we have to tell R to remove the
###missing values. the argument 'na.rm' means "remove missing (NA) data"
###we set that argument to 'True'. otherwise we get an error message
median(data$ClimateChangeAttitude,na.rm = TRUE)
median
###finding the mean
###let's find the mean ObamaFT rating
###first, we'll do it the 'long way'
##to find the mean, we need the sum of all of the X values in the vector
###to do that, use the sum command
summary(data$ObamaFT)
sum.FT <-sum(data$ObamaFT, na.rm=TRUE)

###next, we need the number of observations, N
###we can find that with the length command
num.obs<-length(data$ObamaFT[!is.na(data$ObamaFT)])
length(data$ObamaFT[!is.na(data$ObamaFT)])
###finally, we divide the sum of X by the number of observations
mean.FT <-sum.FT/num.obs
mean.FT

###let's check our answer using the mean function
mean(data$ObamaFT, na.rm = TRUE)

####week 3: part 2####

###slides 2 - 10###
###create the data

x <-c(-10,-5,2,3,3,4,11,16)
print(x)
####find the mean

mean(x)

####use the variance formula with our data
x.var<-sum((x - mean(x))^2)/length(x)

###take the square root of this value to find the standard deviation

x.sd <-sqrt(x.var)
x.sd
###all at once

x.sd1 <-sqrt(sum((x - mean(x))^2)/length(x))
print(x.sd1)

####very important note: the calculation is different when finding
###the standard deviation of a population and when finding the standard
###deviation of a sample

x.sd2<-sqrt(sum((x - mean(x))^2)/(length(x)-1))
print(x.sd2)

###let's use the function
sd(x)

###R gives us the standard deviation of a sample
###if we check the documentation of the function we can verify this
?sd
sd(data$ObamaFT)
sd(data$ObamaFT, na.rm = TRUE)
###under 'details', the texts states 'Like var this uses denominator n - 1.'


###data presentation review
###so far, we've looked at a few ways of presenting data: histograms and barplots
####let's look at the ObamaFT graphically with a histogram

graph.1<-hist(data$ObamaFT)

###now let's add a normal curve to the distribution
###the 'curve' command creates a curve for a graph and the 'dnorm' function creates
### a normal distribution. However, dnorm defaults to a mean of 0 and a sd of 1
###we'll come back to why this is this later, but for now, we need to scale our curve
###to our data using the mean and sd of the variable

m <-mean(data$ObamaFT, na.rm=TRUE)
std <-sqrt(var(data$ObamaFT, na.rm=TRUE))

###for now, don't worry too much about all the plotting details here. of course,
###if you are curious, change some of the values and see how that affects
###the graph

graph.2<-hist(data$ObamaFT, density=10, breaks=10, prob=TRUE, 
     xlab="Obama Feeling Thermometer", ylim=c(0, .025), 
     main="normal curve over histogram")
curve(dnorm(x, mean=m, sd=std), 
      col="darkblue", lwd=2, add=TRUE, yaxt="n")  

###let's make a boxplot
plot.1<-boxplot(data$ObamaFT)

###this is the 'basic' boxplot, but you can customize all sorts of things
###remember, typing a question mark and the function brings up the documentation

?boxplot

###let's add a title
plot.2<-boxplot(data$ObamaFT, main ="Obama Feeling Thermometer")

###let's change the color
plot.2<-boxplot(data$ObamaFT, main = "Obama Feeling Thermometer", col = 20)

###let's make a more complex boxplot: Obama Feelings by party identification
###often times in data analysis, we want to subset the data by groups
###in R, the ~ is used for many formulas. You can think of it as meaning "by"
###in the code below, we want to see Obama FT scores by Party identification
###the boxplot function can take a simple vector as an argument as above
###or we can use the formula and then tell R what data to use
###notice the argument is 'data'...this is why I mentioned earlier that 
###naming our dataset 'data' could be confusing

plot.3 <-boxplot(ObamaFT ~ NewPartyID, data = data, main = "Obama Feeling Thermometer")

####not bad. let's add some colors. before, we've used numbers
###but R will also accept words. Let's use the standard blue/red scheme
###we will make independents purple

plot.3 <-boxplot(ObamaFT ~ NewPartyID, data = data, main = "Obama Feeling Thermometer", col = c('blue','purple','red'))

###how about feeling thermometer by gender?###
###our gender variable is in a different dataset###
###let's add it in###

data$Gender<-data1$Gender

plot.4 <-boxplot(ObamaFT ~ Gender, data = data, main = "Obama Feeling Thermometer", col = c('blue','red', 'purple'))


## age 

data1$NewAge <-2020-data1$BirthYear
summary(ClimateChangeAttitude ~ Gender)
sd(data1$NewAge, na.rm=TRUE)
hist(data1$NewAge)
plot.5 <-boxplot(ClimateChangeAttitude ~ Gender, data = data, main = "Climate change by Gender", col = c('blue','red', 'purple'))
plot.6 <-boxplot(ClimateChangeAttitude ~ NewPartyID, data = data, main = "Climate change by Party", col = c('blue','red', 'purple'))
