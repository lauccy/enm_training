#read the data from the CSV files
setwd("D:/工作/2013 PFS-Tropical Asia/PFS_Fixed_AFEC-X/AFEC-X 2021/PPTs etc/1111-12 QiaoHJ_SDM/enm_training")
occ<-read.csv("Data/occ.csv", stringsAsFactors = F)
#Now read it and inspect the values of the file
head(occ)
#
#remove the duplicate records
occ$species<-"full_occ"
write.csv(occ, "Data/full_occ.csv", row.names = F)
occ<-occ[, c(2:3)]
unique_occ <- unique(occ)
unique_occ$species<-"unique_occ"
unique_occ<-unique_occ[, c("species", "x", "y")]
write.csv(unique_occ, "Data/unique_occ.csv", row.names = F)

setwd("D:/工作/2013 PFS-Tropical Asia/PFS_Fixed_AFEC-X/AFEC-X 2021/PPTs etc/1111-12 QiaoHJ_SDM/enm_training/Data")
mask<-raster("mask.tif")
occ$mask<-raster::extract(mask, occ[, c("x", "y")])

points<-data.frame(rasterToPoints(mask))
occ_unique_cell<-points[which(points$mask %in% unique(occ$mask)),]
occ_unique_cell$species<-"occ_unique_cell"
occ_unique_cell<-occ_unique_cell[, c("species", "x", "y")]
write.csv(occ_unique_cell, "occ_unique_cell.csv", row.names = F)

bg <- randomPoints(predictors, 1000)

plot(mask)
points(occ_unique_cell$x, occ_unique_cell$y, pch = ".", col = "red")


#separate the occ into native and invaded area
getwd()
continents<-st_read("Archive/continent.shp")
plot(st_geometry(continents))
points(occ$x, occ$y)


# European_simp<-st_read("Archive/European_dT1.shp")
European<-st_read("Archive/European.shp")
longlat_proj<-"+proj=longlat +datum=WGS84 +no_defs"
points<-st_as_sf(x = occ[, 2:3], coords=c("x", "y"), crs=st_crs(longlat_proj))
european_points<-points[st_contains(European, points)[[1]],]
none_european_points<-points[-st_contains(European, points)[[1]],]
plot(st_geometry(european_points), add=T, col="red")

plot(st_geometry(European))
plot(st_geometry(european_points), add=T, col="red")
plot(st_geometry(none_european_points), add=T, col="blue")
plot(st_geometry(european_points), add=T, col="red")

st_write(european_points, "../Supp/occurrences/european_points.shp")
st_write(none_european_points, "../Supp/occurrences/none_european_points.shp")

European_buffer<-st_buffer(European, dist=1)
plot(st_geometry(European_buffer))
plot(st_geometry(European), add=T, border="red")
european_points_buffer<-points[st_contains(European_buffer, points)[[1]],]
none_european_points_buffer<-points[-st_contains(European_buffer, points)[[1]],]
st_write(european_points_buffer, "../Supp/occurrences/european_points_buffer.shp")
st_write(none_european_points_buffer, "../Supp/occurrences/none_european_points_buffer.shp")

st_write(European_buffer, "Archive/European_buffer.shp")
df_european_points_buffer<-data.frame(st_coordinates(european_points_buffer))
df_european_points_buffer$species<-"european_points_buffer"
df_european_points_buffer<-df_european_points_buffer[, c("species", "X", "Y")]
write.csv(df_european_points_buffer, "../Supp/occurrences/european_points_buffer.csv", row.names = F)
df_none_european_points_buffer<-data.frame(st_coordinates(none_european_points_buffer))
df_none_european_points_buffer$species<-"none_european_points_buffer"
df_none_european_points_buffer<-df_none_european_points_buffer[, c("species", "X", "Y")]
write.csv(df_none_european_points_buffer, "../Supp/occurrences/none_european_points_buffer.csv", row.names = F)







