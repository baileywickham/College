###Week 7: Statistical Modeling, part I

####new data to work with
reg.data<-read.csv ("~/Downloads/Week6Data.csv")

###this dataset contains 24 variables for you to explore!
###variables are as follows:
###1. DaysMedia: Number of days during the week watching media; coded from 0 - 7
###2. Ideology: coded 1 - Extremely Liberal; 2 - Liberal; 3 - Slightly Liberal; 4 - Moderate; 5 - Slightly Conservative; 6 -Conservative; 7 - Extremely Conservative
###3. Voting Duty: Do you see voting as a duty or a choice? coded 1 -Strongly feel that voting is a duty; 4 - Feel that voting is neither a duty nor a choice; 7 - Feel strongly that voting is a choice
###4. TrustPeople: How often can people be trusted? coded 1 - Always; 2 - Most of the time; 3 - About half the time; 4 - Some of the time; 5 - Never
###5. Attend Services: How often do you attend religious services? coded 1 - Every week; 2 - Almost every week; 3 - Once or twice a month; 4 - A few times a year; 5 - Never
###6. Education: Highest level of education. This has 16 levels; 1 - less than 1st grade; 2 - 1st thru 4th grade; 3 - 5th or 6th grade; 4 - 7th or 8th grade; 5 - 9th grade; 6 - 10th grade; 7 - 11th grade;
###Education, cont'd: 8 - 12th grade, no diploma; 9 - HS grad; 10 - Some college, no degree; 11 - Associates degree/vocational; 12 - Associate's degree/academic; 13 - BA degree; 14 - MA degree ; 15 - Professional degree; 16 - PhD
###7. RoughProtestors: Do protestors deserve to get roughed up for disturbing political events? 1 - Not at all; 2 - A little; 3 - A moderate amount; 4 - A lot; 5 - A great deal
###8. Feminist: Do you consider yourself a feminist? coded 1 - Strong Feminist; 2 - Feminist; 3 - Not a Feminist
###9. HuffPostNews: Do you get news from Huffington Post? 0 - No; 1 - Yes
###10. FoxNewsWeb: Do you get news from Foxnews.com? 0 - No; 1 - Yes
###11. GunsOwned: How many guns do you own?
###12. ClintonPostFT: Feeling Thermometer for Hillary Clinton, post-election
###13. TrumpPostFT: Feeling Thermometer for Donald Trump, post-election
###14. FundamentalistFT: Feeling Thermometer for Christian Fundamentalists
###15. FeministFT: Feeling Thermometer for Feminists
###16. PoorFT: Feeling Thermometer for Poor People
###17. BigBizFT: Feeling Theremometer for Big Business
###18. RichFT: Feeling Thermometer for Rich People
###19: PoliceFT: Feeling Thermometer for Police Officers
###20: ScientistFT: Feeling Thermomter for Scientists
###21: BLMFT: Feeling Thermoter for Black Lives Matter
###22: WeedLegal: Should Marijuana be legal? coded 1 - Favor, 2 - Oppose; 3 - Neither Favor nor Oppose
###23: WomenHome: Is it better if men work and women take care of the home? coded 1 - Much better; 2 - Somewhat better; 3 - Slightly better; 4 - Makes no difference; 5 - Slightly worse; 6 - Somewhat worse; 7 - Much worse
###24: ObamaMuslim: Is Barack Obama a Muslim? coded 1 - Extremely sure Obama is a Muslim; 2 - Very sure Obama is a Muslim; 3 - Moderately sure Obama is a Muslim; 4 - A little sure Obama is a Muslim; 5 - Not sure at all Obama is a Muslim;
###ObamaMuslim, cont'd: 6 - Not sure at all Obama is not a Muslim; 7 - A little sure Obama is not a Muslim; 8 - Moderately sure Obama is not a Muslim; 9 - Very sure Obama is not a Muslim; 10 - Extremely sure Obama is not a Muslim

###remember to do some cleaning of these variables before you analyze them
###any value not listed above should be treated as "missing" and coded as 'NA'

###combining the datasets
###the 'cbind' function (column bind) is an easy way to join two datasets
###for this to work, the datasets have to have the same number of rows

all.data <-cbind(data, reg.data)

###there's a few other variables I need to add
all.data$Age <- data1$Age
all.data$PolAttention<-data2$PolAttention

###let's run our model
###remember, the DV is ClintonFT and the IVs are: Age, Ideology, and Education
###first, let's make sure all of our variables are in order

summary(all.data$ClintonFT)
summary(all.data$Age)
summary(all.data$Education)
summary(all.data$Ideology)

####looks like we have some missing values. let's clean them up
all.data$Education[all.data$Education <= 0 | all.data$Education >=17]<-NA
all.data$Ideology[all.data$Ideology <= 0 | all.data$Ideology >= 8] <- NA

###checking results

summary(all.data$Education)
summary(all.data$Ideology)

###notice we have 967 NA's in the ideology variable; this is because quite a few people answer "don't know" or "haven't thought much about it"
###to ideology questions. Some researchers prefer to code those people as "moderate" but I prefer to treat them as missing

##okay, let's run the model

my.model <- lm(ClintonFT ~ Age + Ideology + Education, data = all.data)

###to get the details, we need to use the summary function

summary(my.model)

###a simulated respondent with age 45, a score of 4 on the ideology scale, and a score of 13 on the education variable

89.54 + (.148)*(45) + (-13.60)*(4) + (-.01)*(13)

###typically, when we do a regression, we are interested in how the DV changes over the range
###of an IV. For example, based on our model, how does the average person feel about Clinton
###as they become more conservative?
###we can use the predict function to show this

###let's make some simulated data. We will hold age and education at their means and then vary ideology

###let's create the vectors and then put them into a data frame
###we want to vary Ideology from 1 - 7
Ideology <-c(1,2,3,4,5,6,7)

###the other values we will hold constant
###the 'rep' function will repeat a value multiple times
###this command is telling R to find the mean age and then repeat it 7 times
###one for each ideology level
Age<-rep(mean(all.data$Age, na.rm = TRUE), 7)
Education<-rep(mean(all.data$Education, na.rm = TRUE),7)

###now let's put them all together

sim.data<-data.frame(Age,Education, Ideology)

###now, we can use the 'predict' function to see how feelings toward Clinton
###change as one moves from Extremely Liberal to Extremely Conservative

pred.values<-predict(my.model, sim.data)
pred.values
###let's plot the results

plot(pred.values, main = "Predicted FT Ratings: Hillary Clinton", ylab = "FT Rating", xlab = "Ideology Score",
     ylim = c(0,100))

###nothing too surprising there
###we can do in sample predictions too
###let's create a dataset that just has the variables in our model: Age, Ideology, and Education
###to find the index of our variables, we can use 'colnames'
colnames(all.data)

###this tells us that Age is column 31, Ideology is 8, and Education is 12
###we can select just those values using the index [] feature
sample.data<-all.data[,c(31,8,12)]

###how close are our predictions to the actual values?
###let's see...
###first, we would have to know the average values by ideology score
###we did this earlier using the aggregate function...
avg.FT <-aggregate(all.data$ClintonFT, by = list(all.data$Ideology), FUN = mean, na.rm = TRUE)

colnames(avg.FT)<-c('Ideology','ClintonFT')

###first, we plot the predicted values
plot(pred.values, main = "Predicted FT Ratings: Hillary Clinton", ylab = "FT Rating", xlab = "Ideology Score",
     ylim = c(0,100))

###next, we can add the true values using the 'lines' command which adds lines to existing plots
plot(pred.values, main = "Predicted FT Ratings: Hillary Clinton", ylab = "FT Rating", xlab = "Ideology Score",
     ylim = c(0,100))
lines(avg.FT$ClintonFT, col = 'blue')

###let's customize a bit
###we can change the line types, the point characters, almost anything we want
##here, I change a few features: type changes how the line is plotted and pch changes the symbol used
###I also add a legend. for all of these commands, more info can be found by typing ? and the name of the function
plot(pred.values, main = "Predicted FT Ratings vs. Observed", ylab = "FT Rating", xlab = "Ideology Score",
     ylim = c(0,100), type = "b", pch = 17)
lines(avg.FT$ClintonFT, col = 'red', type = "b", pch = 1)
legend (5, 90, legend = c("Predicted","Observed"), col = c("black","red"), pch = c(17,1))



####Part II#####


###let's run a second model. I'd imagine that feelings towards Hillary Clinton
###are also connected to gender. We should include that in our model as well
###gender is a categorical variable. Regression doesn't work with such variables UNLESS there are only two categories
###for this regression, we are only using 'Male' and 'Female' as our categories

my.model.2 <- lm(ClintonFT ~ Age + Ideology + Education + GenderSimple, data = all.data)

summary(my.model)
summary(my.model.2)

###that's a bit surprising. although gender has a significant effect, it didn't change much of the other effects
###that could mean that the results are robust--they hold even when other important variables
###are controlled for
###let's see if we can find a better example of a control variable
###control variables are those that are likely correlated with both the IVs in the model and the DV
###here's a simple model suggesting that feelings toward Clinton are based on income and gender
all.data$Income<-data2$Income

my.model.3<- lm(ClintonFT ~ Income + GenderSimple, data = all.data)
summary(my.model.3)
###we find a significant effect for income in this model; wealthier people like Clinton less
###but wait; income might be correlated with ideology--the richer you are, the more conservative you might be
###before we conclude that income is a significant predictor of feelings for Clinton, we should control for ideology

my.model.4 <-lm(ClintonFT ~ Income + Ideology + GenderSimple, data = all.data)
summary(my.model.4)

###notice a few things here. first, the r squared of our new model is much higher
###that means it explains more of the variance in the DV
###second, the b coefficient on the income variable, while still significant, is smaller
###this means that some of the effect we saw in the first model wasn't really due to income, but to 
###other factors correlated with income. when we control for those factors, the impact of income decreases

###making meaningful regression equations
###recoding so we have meaningful zero points
###one strategy is to make the lowest level of your variable equal to zero
##for example, for Ideology, instead of a 1 - 7 scale, make it 0 - 6
###whenever I recode, I typically make a new variable. that way, if I make a mistake I don't overwrite the original variable

all.data$IdeologyRecode<-(all.data$Ideology) -1
summary(all.data$IdeologyRecode)

###for the other variables in our data
all.data$EducationRecode<-(all.data$Education)-1
summary(all.data$EducationRecode)
###it's a little trickier because Age is an interval variable. So if we recode it, we have to know what the zero point is
###normally, I wouldn't do this because I would have to remember that I recoded it this way, but for consistency let's do it
all.data$AgeRecode<-(all.data$Age) - 22
summary(all.data$AgeRecode)

###now let's run our model again

my.model.zero <-lm(ClintonFT ~ AgeRecode + IdeologyRecode + EducationRecode, data = all.data)
summary(my.model.zero)

###as you can see, the b coefficient estimates don't change. But now the intercept is interpretable
###a person who is 22 years old, an extreme liberal, and has a 1st grade education is predicted to give 
###Hillary Clinton a FT score of 79.18
###in this case, the intercept is interpretable, but not very useful
###let's 'center' our variables on zero such that a score of zero indicates the mean
###one way to do this to simply subtract the mean from each observation

all.data$IdeologyRecodeMean<-all.data$Ideology -mean(all.data$Ideology, na.rm = TRUE)
summary(all.data$IdeologyRecodeMean)
all.data$EducationRecodeMean<-(all.data$Education)-mean(all.data$Education, na.rm = TRUE)
summary(all.data$EducationRecodeMean)
all.data$AgeRecodeMean<-(all.data$Age) - mean(all.data$Age, na.rm = TRUE)
summary(all.data$AgeRecodeMean)

###running the model again...

my.model.mean <-lm(ClintonFT ~ AgeRecodeMean + IdeologyRecodeMean + EducationRecodeMean, data = all.data)
summary(my.model.mean)

###once again, the b estimates don't change, but now we now the average feeling thermometer score
###for people who are at the mean of age, ideology, and education


###recoding variables for ease of interpretation
###adding a package to make recoding easier
library(car)

###in the dataset above, "AttendServices" is coded so that 1 means 'Every Week' and 5 means 'Never'. This can be confusing
###first, clean the data
all.data$AttendServices[all.data$AttendServices<=0]<-NA

###run the regression
bad.coding <-lm(ClintonFT ~ AttendServices, data = all.data)
summary(bad.coding)

###just glancing at the model summary, we might assume that the more a person attends services, the more they like Clinton
###but that's not correct. it's actually the reverse
###let's recode

all.data$AttendServicesRecode<-recode(all.data$AttendServices, "1 = 5; 2 = 4; 3 = 3; 4 = 2; 5 = 1")

###check the results
summary(all.data$AttendServices)
summary(all.data$AttendServicesRecode)

###run the regression
good.coding <-lm(ClintonFT ~ AttendServicesRecode, data = all.data)
summary(good.coding)

###now, it is clear that the more you attend services, the less you like Clinton
###renaming a variable
###renaming just one column in R

names(all.data)[names(all.data) == 'Ideology']<- 'Conservatism'
names(all.data)
good.names <-lm(ClintonFT ~ Conservatism, data = all.data)
summary(good.names)

###now, it is easy to see at a glance that as conservatism increases, feelings toward Clinton decrease

###dummy variables
###let's say we want to analyze the effect of being a feminist on feelings towards Hillary Clinton
###right now, it's coded with three levels. let's make it into a dummy variable: feminist or not a feminist
###make 1 the category you are interested in explaining...if you care about how feminists feel about Clinton, make that category 1
###if you care about explaining how non-feminists feel, make that category 1
###here, we are interested in how feminists think about Clinton

all.data$FeministID[all.data$Feminist <=2 ]<-1
all.data$FeministID[all.data$Feminist == 3]<-0

my.model.dummy <-lm(ClintonFT ~ FeministID, data = all.data)
summary(my.model.dummy)

###this model tells us that the difference in feeling thermometer ratings between
###a feminist and a non-feminist is 21.37 points; specifically, those who identify as feminists have FT ratings
###21 points higher than those who don't

###full dose variables
###let's say we want the full effect of education, age, and ideology on feelings
###for Clinton. To see this, we need to recode our variables on a 0 - 1 scale
###that means we need the smallest value in our data to be zero and the largest to be 1
###mathematically, this means we need to first set our variables so that the minimum value is 0
###then, we need to divide remaining values by the new maximum 
###let's use AGE as an example

summary(all.data$Age)

###we see the minimum is 22; if we subtract 22 from every value, the minimum will be 0
###we did this previously when we centered our variables on zero

summary(all.data$AgeRecode)

###now, we want the maximum value to be 1. currently, it is 72. 
###however, 72 divided by 72 is 1. So if we do this to all values in our data, we will create a variable that ranges from 0 -1

all.data$AgeDose<-all.data$AgeRecode/72
summary(all.data$AgeDose)

###let's repeat for the other variables in our model
###in each case, we are setting the minimum value to 0 and then dividing by the maximum value
all.data$IdeologyDose<-all.data$IdeologyRecode/6
summary(all.data$IdeologyDose)
all.data$EducationDose<-all.data$EducationRecode/15
summary(all.data$EducationDose)

###why would we do this? now we can compare the b coefficients for each variable
###and determine the total effect of each variable

my.model.dose<-lm(ClintonFT ~ AgeDose + IdeologyDose + EducationDose, data = all.data)
summary(my.model.dose)

###looking at this model, we see that ideology is by far the most influential variable
###the diffference between an "extreme liberal"---coded 0 and an "extreme conservative" is a whopping 81.6 points
###by comparison, the difference between the youngest member of the sample and the oldest is only 10.6 points
###and the difference between the least educated and the most is only .25 points
###thus, we can can conclude that ideology is probably the most impactful variable on our DV