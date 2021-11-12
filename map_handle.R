library(raster)
library(icosa)
library(tmaptools)
library(geosphere)
library(rgdal)
library(sf)
library(tidyverse)

#create a mask with random numbers
getwd()
# mask <- raster("../Data/bioclim/10minus/bio1.asc") # Cannot create a RasterLayer object from this file. (file does not exist)

setwd("D:/工作/2013 PFS-Tropical Asia/PFS_Fixed_AFEC-X/AFEC-X 2021/PPTs etc/1111-12 QiaoHJ_SDM/enm_training/Data/bioclim/10minus")
mask <- raster::raster("bio1.asc")
plot(mask)

# values(mask)[!is.na(values(mask))]<-c(1:length(values(mask)[!is.na(values(mask))])) # does not work

# ?values # two r packages have the same function use raster::values

raster::values(mask)[!is.na(raster::values(mask))]<-c(1:length(raster::values(mask)[!is.na(raster::values(mask))])) # works now # why do this ?

plot(mask)

setwd("D:/工作/2013 PFS-Tropical Asia/PFS_Fixed_AFEC-X/AFEC-X 2021/PPTs etc/1111-12 QiaoHJ_SDM/enm_training/Data")

raster::writeRaster(mask, "mask.tif", overwrite=TRUE)
# ?writeRaster

#greate circle distance

#earth circumference = 2pi*radius
2 * pi * 6378137
40075017/360
40075017/360/6
p<-c(0, 0)
p_north<-c(0.166667, 0)
p_south<-c(-0.166667, 0)
distHaversine(p, p_north, r=6378137)
distHaversine(p, p_south, r=6378137)

#55°40′34″N 12°34′08″E Copenhagen: 55.676111, 12.568889
#55°50′34″N 12°34′08″E 10 Minutes North to Copenhagen: 55.842778, 12.568889
#55°30′34″N 12°34′08″E 10 Minutes South to Copenhagen: 55.509444, 12.568889

p_Copenhagen<-c(55.676111, 12.568889)
p_north_Copenhagen<-c(55.842778, 12.568889)
p_south_Copenhagen<-c(55.509444, 12.568889)
distHaversine(p_Copenhagen, p_north_Copenhagen, r=6378137)
distHaversine(p_Copenhagen, p_south_Copenhagen, r=6378137)

#37°36′00″N 14°00′55″E Sicilia: 37.6, 14.015278
#37°46′00″N 14°00′55″E 10 Minutes North to Sicilia: 37.766667, 14.015278
#37°26′00″N 14°00′55″E 10 Minutes South to Sicilia: 37.433333, 14.015278
p_Sicilia<-c(37.6, 14.015278)
p_north_Sicilia<-c(37.766667, 14.015278)
p_south_Sicilia<-c(37.433333, 14.015278)
distHaversine(p_Sicilia, p_north_Sicilia, r=6378137)
distHaversine(p_Sicilia, p_south_Sicilia, r=6378137)

#show maps
# bio1<-raster("../Supp/bioclim/10minus/bio1.asc")
setwd("D:/工作/2013 PFS-Tropical Asia/PFS_Fixed_AFEC-X/AFEC-X 2021/PPTs etc/1111-12 QiaoHJ_SDM/enm_training/Data/bioclim/10minus")
bio1<-raster("bio1.asc")

x <- 116.38
y <- 39.91

p <- data.frame(x, y)
class(p)
p

head(occ)

raster::extract(bio1, p)

beijingpoint <- sf::st_as_sf(p, coords = c("x","y"),
             crs = st_crs(longlat_proj))

setwd("D:/工作/2013 PFS-Tropical Asia/PFS_Fixed_AFEC-X/AFEC-X 2021/PPTs etc/1111-12 QiaoHJ_SDM/enm_training")
occ<-read.csv("Data/occ.csv", stringsAsFactors = F)
plot(bio1)
points(occ$x, occ$y, pch=".")

#reprojection
get_proj4("eck4", output="character")
get_proj4("longlat", output="character")
#get_proj4("aeqd", output="character")
get_proj4("EPSG:3035", output="character")

longlat_proj<-"+proj=longlat +datum=WGS84 +no_defs"
aeqd_proj<-"+proj=aeqd +datum=WGS84 +no_defs"
aeqd_proj_gcb<-"+proj=laea +lat_0=52 +lon_0=10 +x_0=4321000 +y_0=3210000 +ellps=GRS80 +units=m +no_defs"
eck4_proj<-"+proj=eck4 +ellps=WGS84 +datum=WGS84 +units=m +no_defs"
crs(bio1)<-longlat_proj
bio1_eck4<-projectRaster(bio1, crs=eck4_proj, res=c(10000, 10000))
plot(bio1_eck4)
bio1_aeqd<-projectRaster(bio1, crs=aeqd_proj, res=c(10000, 10000))
plot(bio1_aeqd)
bio1_gcb<-projectRaster(bio1, crs=aeqd_proj_gcb, res=c(10000, 10000))
plot(bio1_gcb)

#Regular icosahedron
hLow <- hexagrid(3)
# plot it in 3d
plot3d(hLow, guides=F)

#crop 
#continents<-readOGR(dsn="../Supp/continents", layer="continent")
#plot(continents)
#European<-continents[which(continents$CONTINENT=="Europe"),]
#plot(European)

# continents<-st_read("../Supp/continents/continent.shp")

continents<-st_read("Data/Archive/continent.shp") #ljx modified according to my own folders 
st_crs(continents)<-st_crs(bio1)
European<-continents[which(continents$CONTINENT=="Europe"),]
plot(st_geometry(European))
st_write(European, "Data/Archive//European.shp")
European_simp<-st_simplify(European)
plot(st_geometry(European_simp))

European_simp<-st_simplify(European, dTolerance=1)
plot(st_geometry(European_simp))
st_write(European_simp, "../Supp/continents/European_dT1.shp")
European_simp<-st_simplify(European, dTolerance=0.5)
plot(st_geometry(European_simp))
st_write(European_simp, "../Supp/continents/European_dT0.5.shp")

continents_gcb<-st_transform(continents, crs=st_crs(aeqd_proj_gcb))
plot(st_geometry(continents_gcb))
European_gcb<-continents_gcb[which(continents_gcb$CONTINENT=="Europe"),]
plot(st_geometry(European_gcb))
European_gcb_simp<-st_simplify(European_gcb, dTolerance = 100000)
plot(st_geometry(European_gcb_simp))
European_gcb_simp<-st_simplify(European_gcb, dTolerance = 10000)
plot(st_geometry(European_gcb_simp))

bio1_gcb_crop<-crop(bio1_gcb, extent(European_gcb_simp))
plot(bio1_gcb_crop)
bio1_gcb_mask<-mask(bio1_gcb_crop, European_gcb_simp)
plot(bio1_gcb_mask)

for (i in c(1:19)){
  print(i)
  r<-raster(sprintf("../Supp/bioclim/10minus/bio%d.asc", i))
  crs(r)<-crs(longlat_proj)
  r_rough<-projectRaster(r, crs=crs(r), res=c(1.666667, 1.666667))
  writeRaster(r_rough, sprintf("../Supp/bioclim/1degree/bio%d.tif", i), overwrite=T)
}




