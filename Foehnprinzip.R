#aktuelle Temperatur [�C]
Temp <- 20

#Anfangsh�he [m �NN]
h0 <- 100

#maximale H�he (Kamm) [m �NN]
hm <- 3600

# Wolkenuntergrenze [m]
hw <- 3100

# H�he Zielgebiet [m �NN]
hz <- 600

#relative Feuchte [%]
f <- 0.52

#trockenadiabatischer Temperaturgradient [K/100m]
adiabT <- 1

#feuchtadiabatischer Temperaturgradient [K/100m]
adiabF <- 0.6

#Taupunktabnahme [K/100m]
TPab <- 0.17

Magnus <- function(Temp){
  6.1078*exp(17.1*Temp/(235+Temp))
}

#S�ttigungsdampfdruck [hPa]
E <- Magnus(Temp= Temp)

#aktueller Dampfdruck [hPa]
e <- E*f

#Taupunkt TP [�C]
TP <- function(e){
  235*log(e/6.1078)/(17.1-log(e/6.1078))
}

tp <- TP(e)
tp
#absolute Feuchte [kg/m�]
absF <- function(e, Temp){
  e/(461.6*(Temp+273.15))
}

Fw <- absF(e= e, Temp= Temp)
Fw

#Kondensationsniveau (mit abnehmendem Taupunkt!)
hKN <- function(h0, TP, adiabT, TPab){
  h0+(Temp-TP)/(adiabT/100-TPab/100)
}

KN <- hKN(h0= h0, TP= tp, adiabT= adiabT, TPab= TPab)
KN

#### Berechnungen f�r den Kamm ####
hdiffF <- hm - KN
Tkamm <- tp-hdiffF*adiabF/100
Ekamm <- Magnus(Temp= Tkamm)
absFkamm <- absF(e= Ekamm, Temp= Tkamm)

#### Berechnungen f�r die Wolkenuntergrenze ####
hdiffW <- hw-hm
Tw <- hdiffW*adiabF/100
Ew <- Magnus(Temp= Tw)
Fw <- 100
absFw <- absF(e= Ew, Temp= Tw)

#### Berechnungen f�r das Zielgebiet ####
hdiffZ <- hz - hw
delta_T <- hdiffZ*adiabT/100
Tz <- Tw-delta_T
#Taupunkts�nderung
TPz <- Tw+hdiffZ*adiabF/100

#S�ttigungsdampfdruck
Ez <- Magnus(Temp= Tz)
Ez

#relative Feuchte
fz <- Ez/Magnus(Temp= TPz)
fz