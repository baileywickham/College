###Week 4 Stuff####
###some new data to look at!
library(foreign)
library(plyr)
library(stats)
library (dplyr)


data<-read.csv ("~/Downloads/IntroDataset.csv")
data1<-read.csv ("~/Downloads/Assignment1.csv")
data2<-read.csv ("~/Downloads/Week4Data.csv")

###this data set has 4 variables
###PolAttention: How often do you pay attention to politics and elections?
###coded 1 - 'Always'; 2 - 'Most of the time'; 3 - 'About half the time'; 4 - 'Some of the time'; 5 - 'Never'
####HCFT: Hillary Clinton Feeling Thermometer
####DTFT: Donald Trump Feeling Thermometer
####Income: coded in 28 steps from 1 - 28;

###preparing the data
###removing missing variables

data2$PolAttention[data2$PolAttention<0]<-NA
data2$HCFT[data2$HCFT<0]<-NA
data2$DTFT[data2$DTFT<0]<-NA
data2$Income[data2$Income<0]<-NA

summary(data2)

###let's add the other feeling thermometer ratings to our data
data$ClintonFT<-data2$HCFT
data$TrumpFT<-data2$DTFT

###slides 4 - 9
###let's pick a random subject from the data
###we can use the sample command to pick one lucky subject out of the 4271 in our sample
sample(1:4271, 1)

###for this code, I got 2386, but since sample is random if you run it again you 
###likely get a different answer
###let's learn about subject 2386
###how do they feel about Obama?
data$ObamaFT[2386]
data$ObamaFT[data$ObamaFT > 50]
random.FT <-data$ObamaFT[2386]
random.FT

###this subject gave Obama a score of 52
###how do we interpret that value?
###let's see how they viewed the other candidates
data$ClintonFT[2386]
data$TrumpFT[2386]

FT.ratings <-c(data$ObamaFT[2386],data$ClintonFT[2386],data$TrumpFT[2386])
FT.ratings

###how were the other the 2016 presidential candidates?
summary(data$ObamaFT)
summary(data$ClintonFT)
summary(data$TrumpFT)

hist(data$ObamaFT)
Obama.haters <-data$ObamaFT[data$ObamaFT == 0]
length(Obama.haters)
###let's see how the candidates stack up against each other
boxplot(data$ObamaFT, data$ClintonFT, data$TrumpFT, names = c('Obama','Clinton','Trump'),
        col = c('purple','blue','red'),
        main = "Feeling Thermometer Ratings, 2016")

###slides 10 - 11
#####calculating percentiles####
###for this exercise we want to figure out what percentile the number 10 is 

x.1 <-c(0,0,0,1,1,2,8,9,10,11)

###note that the data is already in order; as with median, we have to arrange
###the data by value before finding the percentile
###the formula for percentile is Pr = B/N x 100, where Pr is percentile rank
####B is the number of values beneath a certain point and N is the number of observations
###we can use length() to find N
length(x.1)
length(data$ObamaFT)
###finding B is a bit more complex. we need to know the location of our target number
###the which command will tell us where in a vector a particular value is
###let's find the position of 10 in the vector

which(x.1 == 10)

###this returns a value of 9
###let's check this by using our [] to extract the 9th value
x.1[9]

###so we know that there are 10 observations in the vector and the 9th observation is 10
###that means there are 8 observations below the 9th observation
###we can put these values into our formula"

pr <- (8/10) * 100

###this returns a value of 80, meaning 10 is in the 80th percentile
###using just the R commands to find percentile ranking of 10 in the vector

pr.1 <-((which(x.1 == 10)-1)/length(x.1))*100

###it worked! let's find the percentile ranking of 2
pr.2<-((which(x.1 == 2)-1)/length(x.1))*100

###2 is in the 50th percentile...it's the median
###what happens if there are duplicates in the vector?

which(x.1 == 1)
pr.3<-((which(x.1 == 1)-1)/length(x.1))*100

###we see a value of 1 at the 4th and 5th place in the vector
###if the which() command returns a vector, we can tell R to just take 
###the minimum value using the min command

min(which(x.1==1))

###so what percentile is 1 in our vector?

pr.4 <-(min(which(x.1==1))-1)/length(x.1)*100
pr.4
###vector X2 from the slides
x.2 <-c(7,7,7,8,8,8,9,9,10,11)

pr.5 <-(min(which(x.2==10))-1)/length(x.2)*100
pr.5

pr.FT <-(min(which(data$ObamaFT==35))-1)/length(data$ObamaFT)*100

pr.FT
###finding means and sds
mean(x.1)
mean(x.2)
sd(x.1)
sd(x.2)

####slides 13 - 19###
###let's look at the income data
hist(data2$Income)

###looks like a slightly negative skew, although there are a lot of observations at the very
###low tail
###let's find some z scores
###we need the mean and standard deviation of our data
income.mean<-mean(data2$Income, na.rm = TRUE)
income.sd<-sd(data2$Income, na.rm = TRUE)

###for a score of 10
z.1 <-(10 - income.mean)/income.sd
z.1
###the relationship between a z score, an observation, the mean, and sd
(z.1)*(income.sd)
(z.1)*(income.sd) + (income.mean)

###making comparisons with z scores
z.x1 <-(10 - mean(x.1))/sd(x.1)
z.x2 <-(10 - mean(x.2))/sd(x.2)

###randomness and probability####

###Slides 7 - 8
####simulate 10 rolls of a six-sided die###
###we can use the sample command to simulate a random process

roll.1 <-sample(1:6, 10, replace = TRUE)
roll.1
###let's put the results in order to make it easier to see
roll.order <-sort(roll.1)
roll.order
table(roll.order)
###now let's do 100 rolls
roll.2<-sample(1:6, 100, replace = TRUE)
roll.order2<-sort(roll.2)
roll.order2
###we don't want to count all those values
###let's just make a table
table(roll.order2)

###Slides 18 - 21
###empirical vs. theoretical distributions
###in theory, rolling two six-sided dice and summing their results should produce 
###a mean of 7 and a standard deviation of 2.415
###let's see how close our data comes to that theoretical result
###rolling two six-sided dice 50 times and finding their sum

dice.sum <- sample(1:6, 50, replace = TRUE) + sample(1:6, 50, replace = TRUE)

###find the mean and standard deviation
m <-mean(dice.sum)
sd <-sd(dice.sum)
sd
###actually, pretty close: we got a mean of 6.54 and a sd of 2.533
###generate the histogram

graph.2<-hist(dice.sum, density=10, breaks=10, prob=TRUE, 
             xlab="Dice Total", ylim=c(0, .4), 
             main="Simulated Dice Throws")
curve(dnorm(x, mean=m, sd=sd), 
      col="darkblue", lwd=2, add=TRUE, yaxt="n")
?pnorm
tsd
###finding the probability of an outcome
pnorm(7, mean = 7, sd = tsd)
pnorm(7, mean = m, sd = sd)

####with mean = 0 and sd = 1
###probability of the mean
pnorm(0)

###probability of being 1 standard deviation larger than the mean
pnorm(1)

###In the income data, a score of 23 indicates an income between $100,000 and 109,999
###what is the probability that a respondent makes more than that?
###solution
###find the z score
hist(data2$Income)
mean.income <-mean(data2$Income, na.rm = TRUE)

###the mean is 15.39
####find the sd

sd.income<-sd(data2$Income, na.rm = TRUE)

####the sd is 8.08

###calculate the z score
income.z <-(23 - mean.income)/sd.income
income.z

###the z score is .94216
###find the probability

pnorm(income.z)

###the value we found is the proportion of the curve beneath our target value
###we want the proportion larger than our target value; the area to the right of 23
###the sum of all probabilities for an event always equals 1 

1 -pnorm(income.z)

###.173 or 17.3% of the data is expected to lie to the right of 23
###thus, we would say that the probability of someone making more than 100,000 to 109,999
###is 17.3%


