library("BEST")
library("ggplot2")
library("gridExtra")


setwd("/home/jona/Desktop/charvis/best2")
source("/home/jona/Desktop/charvis/best2/BEST1G.R")

getITCs <- function(condition,ITC){
    sourcefile<-paste("/home/jona/experiments/charvis/csv/Charvis",condition,"ITC.csv",sep="-")

    dat<-as.numeric(read.table(sourcefile,sep=","))

	# Bayesian Estimation
	mcmcChain = BEST1Gmcmc( dat )
	hpdz <- hdi(mcmcChain,credMass = .95)
	hpd <- tanh(hpdz[1:2,1])
	
	# Classical frequentist analytic CI
	freqz <- t.test(dat)
	freq <- tanh(freqz$conf.int[1:2])

	meanm <- tanh(mean(dat))

	ITC[condition,] = c(meanm, as.numeric(hpd[1]), as.numeric(hpd[2]), as.numeric(freq[1]), as.numeric(freq[2]), condition)
	ITC
}

getWoodys <- function(condition,Woody){
    sourcefile<-paste("/home/jona/experiments/charvis/csv/Charvis-Woody-zscores-",condition,".csv",sep="")

    dat<-as.numeric(read.table(sourcefile,sep=","))

	# Bayesian Estimation
	mcmcChain = BEST1Gmcmc( dat )
	hpdz <- hdi(mcmcChain,credMass = .95)
	hpd <- tanh(hpdz[1:2,1])
	
	# Classical frequentist analytic CI
	freqz <- t.test(dat)
	freq <- tanh(freqz$conf.int[1:2])

	meanm <- tanh(mean(dat))

	Woody[condition,] = c(meanm, as.numeric(hpd[1]), as.numeric(hpd[2]), as.numeric(freq[1]), as.numeric(freq[2]), condition)
	Woody
}


conds<-c("N4-Pz","P6-sem","P6","P3")
l = length(conds)
ITC <- data.frame(meanmu=1:l, hpdl=1:l, hpdu=1:l, CIl=1:l, CIu=1:l, conditions=1:l, row.names = conds)

Woody <- data.frame(meanmu=1:l, hpdl=1:l, hpdu=1:l, CIl=1:l, CIu=1:l, conditions=1:l, row.names = conds)


	

for (x in 1:length(conds)) { ITC <- (  getITCs(conds[x],ITC)  )  }
for (x in 1:length(conds)) { Woody <- (  getWoodys(conds[x],Woody)  )  }


 
model1Frame <- data.frame(Condition = conds,
                          PLI = as.numeric(ITC$meanmu),
                          lower = as.numeric(ITC$CIl),
                          upper = as.numeric(ITC$CIu),
                          Interval = "Frequentist")

model2Frame <- data.frame(Condition = conds,
                          PLI = as.numeric(ITC$meanmu),
                          lower = as.numeric(ITC$hpdl),
                          upper = as.numeric(ITC$hpdu),
                          Interval = "Bayesian")

allModelFrame <- data.frame(rbind(model1Frame,model2Frame))

itcplot <- ggplot(allModelFrame, aes(colour = Interval))
itcplot <- itcplot + geom_hline(yintercept = c(-0.05,0.05), colour = gray(2/3), lty = 2, linetype = "Indecision region")

itcplot <- itcplot + geom_hline(yintercept = c(-0.08,0.08), colour = gray(1/3), lty = 3, linetype = "Corroboration/Rejection region")

itcplot <- itcplot + geom_linerange(aes(x = Condition, y = PLI, ymin = lower,ymax = upper),
	lwd = 1, position = position_dodge(width = 1/2))
itcplot <- itcplot + geom_pointrange(aes(x = Condition, y = PLI, ymin = lower,ymax = upper),
	lwd = 1/2, position = position_dodge(width = 1/2),shape = 21, fill = "WHITE")


itcplot <- itcplot + coord_flip() # + theme_bw()
itcplot <- itcplot + ggtitle("RT- vs. Stimulus-aligned PLI")
itcplot <- itcplot+ ylab("ITC (ratio)")

#print(itcplot)


 
model1Frame <- data.frame(Condition = conds,
                          r = as.numeric(Woody$meanmu),
                          lower = as.numeric(Woody$CIl),
                          upper = as.numeric(Woody$CIu),
                          Interval = "Frequentist")

model2Frame <- data.frame(Condition = conds,
                          r = as.numeric(Woody$meanmu),
                          lower = as.numeric(Woody$hpdl),
                          upper = as.numeric(Woody$hpdu),
                          Interval = "Bayesian")

allModelFrame <- data.frame(rbind(model1Frame,model2Frame))

woodyplot <- ggplot(allModelFrame, aes(colour = Interval))
woodyplot <- woodyplot + geom_hline(yintercept = c(0.12,0.34), colour = gray(1/3), lty = 3, linetype = "Indecision region")

#woodyplot <- woodyplot + geom_hline(yintercept = c(0.34), colour = gray(2/3), lty = 2)


woodyplot <- woodyplot + geom_linerange(aes(x = Condition, y = r, ymin = lower,ymax = upper),
	lwd = 1, position = position_dodge(width = 1/2))
woodyplot <- woodyplot + geom_pointrange(aes(x = Condition, y = r, ymin = lower,ymax = upper),
	lwd = 1/2, position = position_dodge(width = 1/2),shape = 21, fill = "WHITE")


woodyplot <- woodyplot + coord_flip() # + theme_bw()
woodyplot <- woodyplot + ggtitle("Woody-Filter estimated latencies")
woodyplot <- woodyplot+ ylab("Latencies ~ RTs (Pearson's r)")



grid.arrange(itcplot, woodyplot, ncol=2)


#ggsave(file="ggparams.pdf")


#pdf("save.pdf",width = 8, height = 3); arrange_ggplot2(itcplot, woodyplot, ncol=2); dev.off()

#dev.off()