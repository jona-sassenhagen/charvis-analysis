library("BayesFactor")
library("Hmisc")
library("ggplot2")
library("pander")

df1=3
df2=56
l = 6
N = 20


binlats <- data.frame(F=1:l, pvals=1:l, BFs=1:l, rhos=1:l, es=1:l, ci_l=1:l, ci_u=1:l, lats=I(vector(mode="list", length=l)), rts=I(vector(mode="list", length=l)), rt1=1:l, rt2=1:l, rt3=1:l, rt4=1:l, lat1=1:l, lat2=1:l, lat3=1:l, lat4=1:l, row.names = c("N4-sem","P6","P3","P6-RTalign","P3-RTalign","P6-sem"))


filltable <- function(condition,binlats){
    sourcefile<-paste("/home/jona/Charvis",condition,"4binf-rts-lats.csv",sep="-")

    dat<-read.table(sourcefile,sep=",")

    F<-as.numeric(dat[1])
    binlats[condition,"F"]<-F
    binlats[condition,"pvals"] <- 1-pf(F,3,56)
    result<-oneWayAOV.Fstat(F, 20, 4, rscale = 1)
    binlats[condition,"BFs"] <-exp(result[['bf']])        
    binlats[[condition,"lats"]]<-as.numeric((dat[9:12])*10)
    binlats[[condition,"rts"]]<-as.numeric((dat[5:8]))
    corrs = cor.test( binlats[[condition,"rts"]] , binlats[[condition,"lats"]] , method = "spearman")
    binlats[condition,"rhos"]<-corrs[['estimate']]

	ess <-as.numeric(CI.eta.from.summary(F,df1,df2,N-1))

    binlats[[condition,"es"]]<-ess[1]
    binlats[[condition,"ci_l"]]<-ess[2]
    binlats[[condition,"ci_u"]]<-ess[3]

	binlats[[condition,"lat1"]]<-as.numeric((dat[9])*10)
	binlats[[condition,"lat2"]]<-as.numeric((dat[10])*10)
	binlats[[condition,"lat3"]]<-as.numeric((dat[11])*10)
	binlats[[condition,"lat4"]]<-as.numeric((dat[12])*10)

	binlats[[condition,"rt1"]]<-as.numeric((dat[5]))
	binlats[[condition,"rt2"]]<-as.numeric((dat[6]))
	binlats[[condition,"rt3"]]<-as.numeric((dat[7]))
	binlats[[condition,"rt4"]]<-as.numeric((dat[8]))


    binlats

}


CI.eta.from.summary <- function(F,df1,df2,N){
	etasquared <- F*df1/(F*df1+df2)
	r = sqrt(etasquared)
	Z = atanh(r)
	SE = 1/(N-3)
	CIlowerZ = Z-1.96*SE
	CIupperZ = Z+1.96*SE
	CIlowerEta = tanh(CIlowerZ)*tanh(CIlowerZ)
	CIupperEta = tanh(CIupperZ)*tanh(CIupperZ)
	esqrt = c(etasquared,CIlowerEta,CIupperEta)
	esqrt
}

conds<-c("N4-sem","P6","P3","P6-RTalign","P3-RTalign","P6-sem")

for (x in 1:length(conds)) { binlats <- (  filltable(conds[x],binlats)  )  }

rtss = c("rt1","rt2","rt3","rt4")
latss = c("lat1","lat2","lat3","lat4")

rt_all <- as.data.frame(binlats[,rtss])
lat_all <- as.data.frame(binlats[,latss])

rt_alls <- t(cbind(t(rt_all[,1]),t(rt_all[,2]),t(rt_all[,3]),t(rt_all[,4])))
lat_alls <- t(cbind(t(lat_all[,1]),t(lat_all[,2]),t(lat_all[,3]),t(lat_all[,4])))

abcd <- as.data.frame(cbind(as.integer(as.character(rt_alls)),as.integer(as.character(lat_alls)),as.character(row.names(rt_all))))


colnames(abcd)<-c("rts","lats","labels")

df <- abcd[order(abcd$labels),]

df$rts <- as.integer(as.character(abcd$rts))
df$lats <- as.integer(as.character(abcd$lats))
df$labels <- abcd$labels
df <- df[order(df$labels),]

cbPalette <- c("#3300FF", "#FF0000", "#FF0000", "#FF6600", "#FF6600", "#3300FF")
linetypescale <- c("dotted","solid","dashed","solid","dashed","solid")

dd <- ggplot(df, aes (x = rts, y = lats, colour = labels)) +
#geom_path(aes(linetype=labels)) +
scale_colour_manual(values=cbPalette) +
scale_linetype_manual(values = linetypescale) +
geom_point() + 
geom_smooth(method=lm, se=FALSE, alpha=.05, aes(linetype=labels)) +
theme(legend.position=c(1,1),legend.justification=c(1,1)) +
theme(legend.position="right") +
#guides(col = guide_legend(ncol=1), 
guides(colour = guide_legend(override.aes = list(size=0.7))) +
#theme(legend.key.width=unit(0.5,"cm"))
xlab("RTs (in msec)") +
ylab("Latencies (in msec)")
#dd
#remove(dd)

format.df(binlats[1:7],cdec=c(1,3,2,2,2,2,2),numeric.dollar=FALSE)


panderOptions('table.split.table',120)
pandoc.table(format.df(binlats[1:7],cdec=c(1,3,2,1,2,2,2),numeric.dollar=FALSE),justify="right")
#print(dd)

#ggsave(file="ggbins.pdf")