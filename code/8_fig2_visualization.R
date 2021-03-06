#########
#FIGURE 2: How does the value of information change as a function of 
#########

#load packages, parameters, and MSE model
source("code/0_libraries.R") #load packages that are relevant
source("code/2_model_parameters.R") # base parameters
source("code/3_mse_model.R") #load MSE model "est.NPV" and wrapper to repeat model "repeat.model2"



#ar has 5 dimensions: 1) pFmsy, 2) response variable, 3)  phi-uncertainty, 4) a values, 5) starting biomass 
#so division or subtraction of the array is just the values of NPV 

# get simulation outputs
load("output/simulation/fig2_mcs_2020-09-17_10.RData") #this is the original simulation. dataframe = ar

Fig2 <- function(outputs = ar){
  npv_ratio <- (outputs[, 1, 1 ,1,] / outputs[, 1, 5 ,1,])  # ROI = NPV(CV=0.1)/NPV(CV=0.5)
  npv_ratio <- melt(npv_ratio)
  names(npv_ratio) <- c("pFmsy","B.start","roi")
  
  #npv_ratio2 <- subset(npv_ratio,pFmsy %in% c(0.0,0.2,0.4,0.6,0.8,1.0,1.2,1.4,1.6,1.8,2.0))
  npv_ratio2 <- npv_ratio
  npv_ratio2$prox <- -1*(npv_ratio2$B.start) # starting biomass
  #npv_ratio2 <- subset(npv_ratio2,pFmsy %in% c(0.0,0.2,0.4,0.6,0.8,1.0,1.2,1.4,1.6,1.8,2.0))
  
  gs_ratio3 <- npv_ratio2 %>%
                ggplot(aes(x=prox,y=roi,group=pFmsy)) +
                geom_vline(xintercept=-10,lty=2,colour="grey",size=1) +
                geom_vline(xintercept=-0.25*Bmsy,lty=3,colour="darkgrey",size=1) +
                geom_line(aes(colour=pFmsy)) +
                scale_colour_gradient(low="dodgerblue",high="firebrick",name="pHmsy") +
                scale_x_continuous(limits=c(-100,-5),breaks=c(-100,-75,-50,-25)) +
                xlab("Proximity to Tipping Point") +
                ylab("Return on Investment (NPV(CV.1) / NPV(CV.5)") +
                theme_pubr(legend="right")
  gs_ratio3
}

Fig2(outputs = ar)

Fig2b <- function(outputs = ar){
  npv_ratio <- (outputs[,1, 1 ,1,] / outputs[,1, 5 ,1,])  # ROI = NPV(CV=0.1)/NPV(CV=0.5)
  t_near_tp <- outputs[,9, 1 ,1,]
  
  t_near_tp <- melt(t_near_tp)
  names(t_near_tp) <- c("pFmsy","B.start","time.in.dangerzone")
  
  npv_ratio <- melt(npv_ratio)
  names(npv_ratio) <- c("pFmsy","B.start","roi")
  
  #npv_ratio2 <- subset(npv_ratio,pFmsy %in% c(0.0,0.2,0.4,0.6,0.8,1.0,1.2,1.4,1.6,1.8,2.0))
  npv_ratio2 <- npv_ratio %>% 
    left_join(t_near_tp,by = c('pFmsy','B.start'))
  
  #npv_ratio2$prox <- -1*(npv_ratio2$B.start) # starting biomass
  #npv_ratio2 <- subset(npv_ratio2,pFmsy %in% c(0.0,0.2,0.4,0.6,0.8,1.0,1.2,1.4,1.6,1.8,2.0))
  
  timeplot <- npv_ratio2 %>%
    filter(!is.na(roi)) %>%
    ggplot(aes(x=time.in.dangerzone,y=roi,group=pFmsy)) +
    geom_point(aes(colour=pFmsy)) +
    facet_wrap(~B.start, scales = "free_y") + 
    scale_colour_gradient(low="dodgerblue",high="firebrick",name="pHmsy") +
    xlab("Time below (A + K/2)") +
    ylab("Return on Investment (NPV(CV.1) / NPV(CV.5)") +
    theme_pubr(legend="right")
  timeplot
}

Fig2b(outputs = ar)
