######图10.17：2008年美国本土航线图
rm(list=ls())
library(maps)
library(igraph)
location <- read.csv('airports.csv', stringsAsFactors=F) #注意存储路径
test_time <- read.csv('2008.csv', stringsAsFactors = F) #注意存储路径

############ NA #############
ind <- which(is.na(test_time$Origin) | test_time$Dest == 0)
if (length(ind) !=0 ){
  test_time <- test_time[-ind,]
}
##########find longitude and latitude
test_time <- merge(test_time, location[, c('iata','state','lat', 'long')], by.x='Dest', by.y='iata', all.x=T)
colnames(test_time)[(ncol(test_time)-2) : ncol(test_time)] <- c('Dest_ST','Dest_lat', 'Dest_long')

test_time <- merge(test_time, location[, c('iata','state', 'lat', 'long')], by.x='Origin', by.y='iata', all.x=T)
colnames(test_time)[(ncol(test_time)-2) : ncol(test_time)] <- c('Origin_ST','Origin_lat', 'Origin_long')


###############construct graph data##########
airport_Origin <- unique(test_time [, c('Origin', 'Origin_lat', 'Origin_long')])
onlyDest <- setdiff(test_time$Dest, test_time$Origin)
if (length(onlyDest) != 0 ){
  allairport <- rbind(airport_Origin, 
                    unique(test_time[onlyDest, c('Origin', 'Origin_lat', 'Origin_long')]))
}
airport <- data.frame(unique (test_time[, c('Origin', 'Dest', 'Origin_lat',
                                            'Origin_long', 'Dest_lat', 'Dest_long' )]))
pdf('allPath_mainland.pdf', height=12, width=14) #注意存储路径
map('state')
for (j in 1:nrow(airport)){
  arrows(airport$Origin_long[j], airport$Origin_lat[j],
         airport$Dest_long[j], airport$Dest_lat[j],
         lwd=2,
         col='green')
}
for (i in 1:nrow(allairport)){
  points(x = allairport$Origin_long[i],
         y = allairport$Origin_lat[i])
  text(x = allairport$Origin_long[i],
       y = allairport$Origin_lat[i],
       allairport$Origin[i],
       col='blue',pos=2)
}
dev.off()

###########图10.18：2008年美国境内航线图

pdf('allPath_all.pdf', height=12, width=14) #注意存储路径
m <- map("state", interior = FALSE, plot=FALSE)
###change names to abbs
data(state.fips)
m$names <- as.vector(state.fips$abb)
m.world <- map("world", c("USA", 'hawaii'), xlim=c(-180,-60), ylim=c(15,72), interior = FALSE)
map("state", add=T)
map("world", c("USA:Alaska"), add=T)
for (j in 1:nrow(airport)){
  arrows(airport$Origin_long[j], airport$Origin_lat[j],
         airport$Dest_long[j], airport$Dest_lat[j],
         lwd=2,
         col='green')
}
for (i in 1:nrow(allairport)){
  points(x = allairport$Origin_long[i],
         y = allairport$Origin_lat[i])
  text(x = allairport$Origin_long[i],
       y = allairport$Origin_lat[i],
       allairport$Origin[i],
       col='blue',pos=2)
}
dev.off()

################图10.19：2008年飞往阿拉斯加航线
################ to Alaska ###############
AKrange <- which(test_time$Dest_ST == 'AK' & test_time$Origin_ST != 'AK')
test_time <- test_time[AKrange, ]

###############construct graph data##########
airport_Origin <- unique(test_time [, c('Origin', 'Origin_lat', 'Origin_long')])
onlyDest <- setdiff(test_time$Dest, test_time$Origin)
if (length(onlyDest) != 0 ){
  allairport <- rbind(airport_Origin, 
                      unique(test_time[onlyDest, c('Origin', 'Origin_lat', 'Origin_long')]))
}

airport <- data.frame(unique (test_time[, c('Origin', 'Dest', 'Origin_lat',
                                            'Origin_long', 'Dest_lat', 'Dest_long' )]))

toAK <- unique(test_time$Origin_ST)

pdf('allPath_toAL.pdf', height=12, width=14) #注意存储路径
###change names to abbs
data(state.fips)
toAK <- state.fips[which(state.fips$abb %in% toAK), 'polyname']
map("world", c("USA", 'hawaii', 'Alaska'), xlim=c(-180,-65), ylim=c(17,72), interior = FALSE)
map("state", add=T, col = 'grey', fill = T)
map('state', regions = toAK, col = 'white', fill=T, add=T)
for (j in 1:nrow(airport)){
  arrows(airport$Origin_long[j], airport$Origin_lat[j],
         airport$Dest_long[j], airport$Dest_lat[j],
         lwd=2,
         col='green')
}
for (i in 1:nrow(allairport)){
  points(x = allairport$Origin_long[i],
         y = allairport$Origin_lat[i])
  text(x = allairport$Origin_long[i],
       y = allairport$Origin_lat[i],
       allairport$Origin[i],
       col='blue',pos=2)
}
dev.off()


####最短路径

rm(list=ls())
library(igraph)
library(maps)
set.seed(1234)

###############sampling
years <- paste(1988:2008, 'csv', sep='.')
JFKtoANC <- list()
for (i in 1:length(years)) {
  data <- read.csv(years[i], stringsAsFactors=F) #注意存储路径
  valid_data_date <- which(data$Month == 7 & data$DayofMonth == 4 |
                             data$Month == 7 & data$DayofMonth == 5)
  data <- data[valid_data_date, ]
  valid_data_path <- which(data$Origin == 'JFK' | data$Dest == 'ANC')
  JFKtoANC [[i]] <- data[valid_data_path, ]
  rm(data)
}
test_time <- do.call(rbind.data.frame, JFKtoANC)

#########NA data##########
ind <- which(is.na(test_time$CRSDepTime) | is.na(test_time$ArrTime))
test_time <- test_time[-ind,]

######arr >24 to the second day
ind.mis <- which(test_time$ArrTime < test_time$CRSDepTime)
test_time$DayofMonth_Arr <- test_time$DayofMonth
test_time$DayOfWeek_Arr <- test_time$DayOfWeek
test_time$DayofMonth_Arr[ind.mis] <- test_time$DayofMonth_Arr[ind.mis]+1
test_time$DayOfWeek_Arr[ind.mis] <- test_time$DayOfWeek[ind.mis]+1

##########find longitude and latitude
location <- read.csv('airports.csv', stringsAsFactors=F) #注意存储路径

test_time <- merge(test_time, location[, c('iata', 'lat', 'long')], by.x='Dest', by.y='iata', all.x=T)
colnames(test_time)[(ncol(test_time)-1) : ncol(test_time)] <- c('Dest_lat', 'Dest_long')

test_time <- merge(test_time, location[, c('iata', 'lat', 'long')], by.x='Origin', by.y='iata', all.x=T)
colnames(test_time)[(ncol(test_time)-1) : ncol(test_time)] <- c('Origin_lat', 'Origin_long')


#######sampling########transfer=1#########
#####Origins on 5th, with CRSDepTime~=24 but ArrTime<24 should be omitted
ind <- which(test_time$DayofMonth == 5
             & test_time$ArrTime < test_time$CRSDepTime)
test_time <- test_time[-ind, ]
whole <- test_time

duration <- c(1988 : 2008)
year <- 1
cascade <- list()

for (c in duration) {
  test_time <- whole[which(whole$Year == c), ]
  unique.transfer <- unique(test_time$Dest)
  omit.ANC <- which(unique.transfer == 'ANC')
  unique.transfer <- unique.transfer[-omit.ANC]
  cascade.year <- list()
  for (i in 1: length(unique.transfer)) {
    ind.unique <- which(test_time$Dest == unique.transfer[i])
    for (j in 1:length(ind.unique)) {
      transfer <- ind.unique[j]
      ind <- which(test_time$Origin == test_time$Origin[transfer])
      if (length(ind)!=0) {
        if (test_time$DayofMonth_Arr[transfer] == 5) {
          cascade.1 <- which(test_time$Origin == test_time$Dest[transfer]
                             & test_time$DayofMonth == 5 
                             & test_time$CRSDepTime >= test_time$CRSArrTime[transfer])
        } else {
          cascade.1 <- which(test_time$Origin == test_time$Dest[transfer]
                             & ((test_time$DayofMonth == 4
                                 & test_time$CRSDepTime >= test_time$CRSArrTime[transfer])
                                | test_time$DayofMonth == 5))
        }
        if (length(cascade.1) != 0) {
          cascade.year[[i]] <- test_time[c(transfer, cascade.1), ]
          break
        }
      } 
    }
  }
  cascade[[year]] <- do.call(rbind.data.frame, cascade.year)
  year = year+1
}

test_time <- do.call(rbind.data.frame, cascade)
test_time$DepTime <- formatC(test_time$DepTime, width=4, flag=0)
test_time$ArrTime <- formatC(test_time$ArrTime, width=4, flag=0)
test_time$CRSDepTime <- formatC(test_time$CRSDepTime, width=4, flag=0)
test_time$CRSArrTime <- formatC(test_time$CRSArrTime, width=4, flag=0)
test_time <- transform(test_time, Arr.Date=as.Date(paste(Year, Month, DayofMonth_Arr, sep='-')))
test_time <- transform(test_time, CRSDep.Date=as.Date(paste(Year, Month, DayofMonth, sep='-')))

attach(test_time)
##################attach weight ##############
weight <- array(0, nrow(test_time))
weight_comb <- matrix('', nrow(test_time), 6)

ind.JFK <- which(Origin == 'JFK')
for (c in duration) {
  ind <- which(Year == c)
  c.JFK <- ind.JFK[which(ind.JFK %in% ind)]
  for (i in c.JFK){
    weight[i] <- CRSElapsedTime[i]
    weight_comb[i,] <- c(Origin[i], Dest[i], Origin_lat[i], Origin_long[i],
                         Dest_lat[i], Dest_long[i])
  }
  no.JFK <- setdiff(ind, c.JFK)
  no.JFK.list <- unique( Origin [no.JFK])
  for (i in 1:length(no.JFK.list)) {
    JFK.arr <- which(Dest == no.JFK.list[i])
    JFK.arr <- ind[which(ind %in% JFK.arr)]
    JFK.leave <- which(  Origin == no.JFK.list[i])
    JFK.leave <- ind[which(ind %in% JFK.leave)]
    for (j in JFK.leave){
      weight[j] <- CRSElapsedTime[j]
      weight[j] <- weight[j] + difftime(strptime(paste(CRSDep.Date[j], CRSDepTime[j]), '%Y-%m-%d %H%M'),
                                        strptime(paste(Arr.Date[JFK.arr], ArrTime[JFK.arr]), '%Y-%m-%d %H%M'), units='mins')
      weight_comb[j,] <- c(Origin[j], Dest[j], Origin_lat[j], Origin_long[j],
                           Dest_lat[j], Dest_long[j])
    }
  }
}
colnames(weight_comb) <- c('Origin', 'Dest', 'Origin_lat', 'Origin_long',
                           'Dest_lat', 'Dest_long')
weight_comb <- data.frame(Origin = weight_comb[, 'Origin'],
                          Origin_lat = as.numeric(weight_comb[, 'Origin_lat']),
                          Origin_long = as.numeric(weight_comb[, 'Origin_long']),
                          Dest = weight_comb[, 'Dest'],
                          Dest_lat = as.numeric(weight_comb[, 'Dest_lat']),
                          Dest_long = as.numeric(weight_comb[, 'Dest_long']))

###average weight
unique_combination <- unique(weight_comb)
comb_weight <- matrix(, nrow(unique_combination))
for (i in 1:nrow(unique_combination)){
  ind <- which(weight_comb[,'Origin']== unique_combination[i, 1] &
                 weight_comb[,'Dest'] == unique_combination[i, 2] )
  comb_weight[i] <- sum(weight[ind])/length(ind)
}
whole <- test_time
test_time <- unique_combination

##################plot
library(maps)
library(igraph)
airport <- data.frame(airport = unique (unlist (test_time[, c('Origin', 'Dest')] )))
delay <- data.frame(from = test_time[, 'Origin'],
                    to = test_time[, 'Dest'],
                    Origin.lat = test_time[, 'Origin_lat'],
                    Origin.long = test_time[, 'Origin_long'],
                    Dest.lat = test_time[, 'Dest_lat'],
                    Dest.long = test_time[, 'Dest_long'])
g <- graph_from_data_frame(delay, directed=T)
E(g)$weight <- comb_weight
shortest <- shortest_paths(g, from='JFK', to='ANC')$vpath
optimal.transfer <- as.vector(shortest[[1]][2])
all.path <- all_simple_paths(g, which(V(g)$name=='JFK'), which(V(g)$name=='ANC'))

pdf('allPath_minTotal.pdf', height=12, width=14) #注意存储路径
iArrows <- igraph:::igraph.Arrows
m <- map("state", interior = FALSE, plot=FALSE)
###change names to abbs
data(state.fips)
m$names <- as.vector(state.fips$abb)
m.world <- map("world", c("USA","hawaii"), xlim=c(-180,-65), ylim=c(19,72),interior = FALSE)
map("state", boundary = TRUE,  add = TRUE, fill=F, interior=T )
#map("world", c("hawaii"), boundary = TRUE, add = TRUE)
map("world", c("USA:Alaska"), boundary = TRUE, add = TRUE)
for (i in 1:length(all.path)) {
  path.airport <- V(g)$name[as.vector(all.path[[i]])]
  airport1 <- which(test_time[, 'Origin'] == path.airport[1])[1]
  airport2 <- which(test_time[, 'Origin'] == path.airport[2])[1]
  airport3 <- which(test_time[, 'Dest'] == path.airport[3])[1]
  points(x=test_time[airport1, 'Origin_long'],
         y=test_time[airport1, 'Origin_lat'],
         col='red',cex=2)
  points(x=test_time[airport2, 'Origin_long'],
         y=test_time[airport2, 'Origin_lat'],
         col='red',cex=2)
  text(x=test_time[airport2, 'Origin_long'],
       y=test_time[airport2, 'Origin_lat'],
       path.airport[2],
       col='blue',pos=2)
  if (path.airport[2] == V(g)$name[optimal.transfer]){
    iArrows(test_time[airport1, 'Origin_long'], test_time[airport1, 'Origin_lat'],
            test_time[airport2, 'Origin_long'],  test_time[airport2, 'Origin_lat'],
            h.lwd=2, sh.lwd=5, sh.col='green',
            curve=1 - (i %% 2), sh.lty=2, width=1, size=0.7)
    points(x=test_time[airport3, 'Dest_long'],
           y=test_time[airport3, 'Dest_lat'],
           col='red',cex=2)
    iArrows(test_time[airport2, 'Origin_long'], test_time[airport2, 'Origin_lat'],
            test_time[airport3, 'Dest_long'],  test_time[airport3, 'Dest_lat'],
            h.lwd=2, sh.lwd=5, sh.col='green',
            curve=1 - (i %% 2), sh.lty=2, width=1, size=0.7)
  } else{
    arrows(test_time[airport1, 'Origin_long'], test_time[airport1, 'Origin_lat'],
           test_time[airport2, 'Origin_long'],  test_time[airport2, 'Origin_lat'],
           lwd=2)
    points(x=test_time[airport3, 'Dest_long'],
           y=test_time[airport3, 'Dest_lat'],
           col='red',cex=2)
    iArrows(test_time[airport2, 'Origin_long'], test_time[airport2, 'Origin_lat'],
            test_time[airport3, 'Dest_long'], test_time[airport3, 'Dest_lat'],
            h.lwd=2, sh.lwd=2, 
            curve=0.5 - 1.2*(i %% 2), width=1, size=0.7)
  }
}
text(x=test_time[airport1, 'Origin_long'],
     y=test_time[airport1, 'Origin_lat'],
     path.airport[1],
     col='blue', pos=2)
dev.off()
