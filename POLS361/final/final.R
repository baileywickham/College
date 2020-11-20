library(car)
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

reg.data<-read.csv ("~/Downloads/Week6Data.csv")
data<-read.csv ("~/Downloads/IntroDataSet.csv")
data1<-read.csv ("~/Downloads/Assignment1.csv")
data2<-read.csv ("~/Downloads/Week4Data.csv")

# Strip bad data
data2$PolAttention[data2$PolAttention<0]<-NA
data2$HCFT[data2$HCFT<0]<-NA
data2$DTFT[data2$DTFT<0]<-NA
data2$Income[data2$Income<0]<-NA

summary(data2)

data$ClintonFT<-data2$HCFT
data$TrumpFT<-data2$DTFT


all.data <- cbind(data, reg.data)

all.data$Age <- data1$Age
all.data$PolAttention<-data2$PolAttention

all.data$Education[all.data$Education <= 0 | all.data$Education >=17]<-NA
all.data$Ideology[all.data$Ideology <= 0 | all.data$Ideology >= 8] <- NA


#summary(all.data$ClintonFT)
#summary(all.data$Age)
#summary(all.data$Education)
#summary(all.data$Ideology)
#summary(all.data$Education)
#summary(all.data$Ideology)

