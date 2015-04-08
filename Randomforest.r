### FIRST PART

calcCurvature <- function(trip,nlag) {

  ib=seq(2,nrow(trip)-1)
  ia=ib-1
  ic=ib+1
  A_x = trip$x[ia]
  B_x = trip$x[ib]
  C_x = trip$x[ic]
  A_y = trip$y[ia]
  B_y = trip$y[ib]
  C_y = trip$y[ic]
  D = 2 * (A_x*(B_y - C_y) + B_x*(C_y - A_y) + C_x*(A_y - B_y) )
  U_x = ((A_x^2 + A_y^2) * (B_y - C_y) + (B_x^2 + B_y^2) * (C_y - A_y) + (C_x^2 + C_y^2) * (A_y - B_y)) / D
  U_y = ((A_x^2 + A_y^2) * (C_x - B_x) + (B_x^2 + B_y^2) * (A_x - C_x) + (C_x^2 + C_y^2) * (B_x - A_x)) / D
  R = sqrt((A_x - U_x)^2 + (A_y - U_y)^2)
  #   cur <- data.table(center_x = c(NA, U_x, NA),
  #                     center_y = c(NA, U_y, NA),
  #                     radius = c(NA, R, NA))
  mlag <- nlag
  if (nlag %% 2 == 0) {
    mlag <- nlag + 1
  }
  f21 <- rep(1/mlag,mlag)
  smth_x <- filter(U_x, f21, sides=2)
  smth_y <- filter(U_y, f21, sides=2)
  smth_R <- filter(R, f21, sides=2)
  cur_smooth <- data.table(center_x = c(NA, smth_x, NA),
                           center_y = c(NA, smth_y, NA),
                           radius = c(NA, smth_R, NA))
  return(cur_smooth)
}

speedDistribution <- function(trip)
{
  
  
  vitesse = 3.6*sqrt(diff(trip$x,1,1)^2 + diff(trip$y,1,1)^2)/20
  
  vitesse5 = 3.6*sqrt(diff(trip$x,5,1)^2 + diff(trip$y,5,1)^2)/20
  
  vitesse10 = 3.6*sqrt(diff(trip$x,10,1)^2 + diff(trip$y,10,1)^2)/20
  
  vitesse20 = 3.6*sqrt(diff(trip$x,20,1)^2 + diff(trip$y,20,1)^2)/20  
  
  tangacel = 3.6*sqrt(diff(trip$x,1,2)^2 + diff(trip$y,1,2)^2)/20
  
  tangacel5 = 3.6*sqrt(diff(trip$x,5,2)^2 + diff(trip$y,5,2)^2)/20
  
  tangacel10 = 3.6*sqrt(diff(trip$x,10,2)^2 + diff(trip$y,10,2)^2)/20
  
  tangacel20 = 3.6*sqrt(diff(trip$x,20,2)^2 + diff(trip$y,20,2)^2)/20

  cur <- calcCurvature(trip,1)
  cur5 <- calcCurvature(trip,5)
  cur10 <- calcCurvature(trip,10)
  cur20 <- calcCurvature(trip,20)
  
  acelnorm = c(rep(NA,1),vitesse)/cur$radius
  acelnorm5 = c(rep(NA,5),vitesse5)/cur5$radius
  acelnorm10 = c(rep(NA,10),vitesse10)/cur10$radius
  acelnorm20 = c(rep(NA,20),vitesse20)/cur20$radius
  
  aceltotal = acelnorm + c(rep(NA,2),tangacel)
  aceltotal5 = acelnorm5 + c(rep(NA,10),tangacel5)
  aceltotal10 = acelnorm10 + c(rep(NA,20),tangacel10)
  aceltotal20 = acelnorm20 + c(rep(NA,40),tangacel20)
  
  dist = sum(vitesse) 
  acel = diff(vitesse,1,1)
  
  features = c( cbind(quantile(vitesse, seq(0.05,1, by = 0.05)), 
                   quantile(vitesse5, seq(0.05,1, by = 0.05)), 
                   quantile(vitesse10, seq(0.05,1, by = 0.05)), 
                   quantile(vitesse20, seq(0.05,1, by = 0.05)), 
                   quantile(tangacel, seq(0.05,1, by = 0.05)), 
                   quantile(tangacel5, seq(0.05,1, by = 0.05)), 
                   quantile(tangacel10, seq(0.05,1, by = 0.05)), 
                   quantile(tangacel20, seq(0.05,1, by = 0.05)),
                   quantile(cur$radius[is.finite(cur$radius) ] , seq(0.05,1, by = 0.05), na.rm = T), 
                   quantile(cur5$radius[is.finite(cur5$radius) ] , seq(0.05,1, by = 0.05), na.rm = T), 
                   quantile(cur10$radius[is.finite(cur10$radius) ] , seq(0.05,1, by = 0.05), na.rm = T), 
                   quantile(cur20$radius[is.finite(cur20$radius) ] , seq(0.05,1, by = 0.05), na.rm = T), 
                   quantile(acelnorm, seq(0.05,1, by = 0.05), na.rm = T), 
                   quantile(acelnorm5, seq(0.05,1, by = 0.05), na.rm = T),
                   quantile(acelnorm10, seq(0.05,1, by = 0.05), na.rm = T), 
                   quantile(acelnorm20, seq(0.05,1, by = 0.05), na.rm = T), 
                   quantile(aceltotal, seq(0.05,1, by = 0.05), na.rm = T), 
                   quantile(aceltotal5, seq(0.05,1, by = 0.05), na.rm = T),
                   quantile(aceltotal10, seq(0.05,1, by = 0.05), na.rm = T), 
                   quantile(aceltotal20, seq(0.05,1, by = 0.05), na.rm = T),
                   quantile(acel, seq(0.05,1, by = 0.05)))
              ,
                   length(trip[,1]), var(vitesse), var(vitesse5), var(vitesse10), var(vitesse20),
                   var(tangacel), var(tangacel5), var(tangacel10), var(tangacel20),
                   var(acelnorm,na.rm = T), var(acelnorm5,na.rm = T), var(acelnorm10,na.rm = T), 
                   var(acelnorm20,na.rm = T), var(acel,na.rm = T))
  
  return(features)
}


### SECOND PART (BASED ON DEXUAN'S CODE)


features2 <- function(trip)
{
  v = NULL
  angle = NULL
  acceleration = NULL
  deceleration = NULL
  turning_speed = NULL
  distancesum = 0
  shift = -1

  for(i in 2:length(trip[,1])){
    dist = sqrt((trip$x[i-1] - trip$x[i])^2 + (trip$y[i-1] - trip$y[i])^2)
    v = rbind(v,dist)
    distancesum = distancesum + dist
    
    flag = 1
    if(i > 2){
      if(v[i-1] >= v[i-2]){
        acceleration = rbind(acceleration, (v[i-1]-v[i-2]))
        
        if(flag == 0){
          shift = shift + 1
          flag = 1
        }
        
      }
      else{
        deceleration = rbind(deceleration, (v[i-2]-v[i-1]))
        if(flag == 1){
          shift = shift + 1
          flag = 0
        }
        
      }
      
      dist_2 = sqrt((trip$x[i-2] - trip$x[i])^2 + (trip$y[i-2] - trip$y[i])^2)
      if(v[i-1]*v[i-2] != 0){
        cosin = (v[i-1]*2+v[i-2]*2-dist_2*2)/(2*v[i-1]*v[i-2])
      }        
      else{
        cosin = -1
      }
      angle = rbind(angle,(pi-acos(max(min(cosin, 1), -1))))
      temp = angle[i-2]*(v[i-1]+v[i-2])/2
      #if temp>0:
      turning_speed = rbind(turning_speed,temp)
    }  
    
  }
  
  features = c(cbind(quantile(v, seq(0.05,1, by = 0.05)),
                 quantile(angle, seq(0.05,1, by = 0.05)),
                 quantile(acceleration, seq(0.05,1, by = 0.05)),
                 quantile(deceleration, seq(0.05,1, by = 0.05)),
                 quantile(turning_speed, seq(0.05,1, by = 0.05))),
                 var(v),var(angle),var(acceleration),var(deceleration),
                 var(turning_speed),distancesum,shift)
  
  return(features)
  
}
