## Librarie necessaire pour la realisation de ces tests
library(tidyverse)
library(soiltexture)
## Importation des donnees
representativehorizonvalue<-read_csv2("RepresentativeHorizonValues.csv")
profil<-read_csv2("Profile.csv")
code<-read_csv2("Codes.csv")
CLAF88<-read_csv2("CLAF88.csv")
terrain<-read_csv2("Terrain.csv")
tail(profil,2)
head(representativehorizonvalue,3)
## Creation de nouveau data set avec leftjoin 
newdata<-left_join(profil,representativehorizonvalue)
head(newdata,3)

## Supprimons les colonnes sans importance
data<-newdata%>%select(-EAST,-NORT,-LABO,-UTMZ,-ALPE,-FEPE,-PRET,-ALDE,-GYPS,-CLAY,-HCO3,-MCT5,-TEN4,-MCT1,-TEN2,-MCT2,-TEN3,-MCT3,-DATM,-ELEV,-ORGA,-INFR,-PDID,-FEDE,-SCDR,-STGR,-STSI,-STTY,-MINA,-MINS)
new_data<-dplyr::select(data, LNGI, LATI, everything())
dim(new_data)
names(new_data)
## Filtrons en eliminant les NA sur longitutute et lat
new_data<-new_data%>%filter(!is.na(LNGI))
names(new_data)
summary(new_data)
## Subset pour les variables quantitztives 
data_qua<-new_data[,c("EXMG","EXNA","EXCA","SDTO","STPC","CLPC","TOTC","TOTN","CECS","PHAQ")]
## Nettoyer les variables quatitatives
ex<-data_qua%>%filter(!is.na(EXCA))
## Voir la corellation entre les differnts paremetres 
pairs(na.omit(ex))
cor(na.omit(ex))

## Selection des parametres granulometrique pour la conception de triangle textural
tex<-ex%>%select(CLPC,STPC,SDTO)
tex<-tex%>%rename(CLAY=CLPC,SILT=STPC,SAND=SDTO)

tex<-tex%>%filter(!is.na(CLAY)&!is.na(SILT)&!is.na(SAND))
## Creons une nouvelle variable pour voir si les proportions sont respecter
tex<-tex%>%mutate(sum=CLAY+SILT+SAND)
## Filtrer ceux ayant un total egale à 100
tex<-tex%>%filter(sum==100)
## Eliminons la colonnne sum
tex<-tex%>%select(-sum)
tex_dataframe<-as.data.frame(tex)
## Triangle textural
TT.plot(
  class.sys = "HYPRES.TT",
  tri.data = tex_dataframe,
  main = "Soil texture data"
  ,col="red"
) 
## Representation graphique 
tex%>%ggplot()+geom_point(aes(x=CLAY,y=SAND))
## Modele entre teneur en carbone et teneur en azote et teneur en argile 

## Creation d'un  jeu de donnees de test et de validation
set.seed(100)
valid<-sample(nrow(ex),size = 0.7*nrow(ex))
## trainning data 
ex<-na.omit(ex)
training<-ex[c(valid),]
## Test
test<-ex[-c(valid),]

## Modeleisation 

model1<-lm(TOTC~TOTN+CLPC,data = training)

summary(model1)

## Prediction

pred_trai<-predict(model1,training)
## MSE avec les training data

mean((training$TOTC-pred_trai)^2,na.rm = TRUE)

## MSE avec le dataset test
pred_test<-predict(model1,test)

mean((test$TOTC-pred_test)^2,na.rm = TRUE)
library(broom)
model_df<-tidy(model1)
## MAPE training data

mean(abs(training$TOTC-pred_trai)/training$TOTC,na.rm = TRUE)

## MAPE test data

mean(abs(test$TOTC-pred_test)/test$TOTC,na.rm = TRUE)
##verifier la precision
DMwR::regr.eval(training$TOTC,pred_trai)

## jetons un coup d 'oeil sur les residus du model1
par(mfrow=c(2,2))
plot(model1)
### Creons un modele et verifions avec le k fold

library(boot)

mod4<-glm(TOTC~TOTN+EXCA+SDTO,data=training)
cv.glm(training,mod4,K = 5)$delta

## Pour choisir le meillleur modele utilisons stepwise

base<-lm(TOTC~1,data = training)

all_mod<-lm(TOTC~.,data = training)
step<-step(base,scope = list(lower=base,upper=all_mod),direction = "both",trace = 1,steps = 1000)
step
