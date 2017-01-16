##Assignment Lesson 6
#Arias, Francisco ; Araza Arnan

#Clean workspace
rm(list=ls())

#Import Libraries
library(sp)
library(rgdal)
library(rgeos)

#Calling Download function
source('R/Download.R')

# Downloads source files

RailwaysFolder <- download('http://www.mapcruzin.com/download-shapefile/netherlands-railways-shape.zip')
PlacesFolder <- download('http://www.mapcruzin.com/download-shapefile/netherlands-places-shape.zip')

# Reading shape files 
railways_shp <- list.files(path = paste0('data/',RailwaysFolder),pattern = '.*.shp', full.names = T)
places_shp <- list.files(path = paste0('data/',PlacesFolder),pattern = '.*.shp', full.names = T)

#Reading files 

places <- readOGR(places_shp,layer= ogrListLayers(places_shp))

railways <- readOGR(railways_shp ,layer= ogrListLayers(railways_shp ))

# Project files into RD
prj_string_RD <- CRS("+proj=sterea +lat_0=52.15616055555555 +lon_0=5.38763888888889 +k=0.9999079 +x_0=155000 +y_0=463000 +ellps=bessel +towgs84=565.2369,
                     50.0087,465.658,-0.406857330322398,0.350732676542563,-1.8703473836068,4.0812 +units=m +no_defs")

places_RD <- spTransform(places, prj_string_RD)
railways_RD <- spTransform(railways, prj_string_RD)

# Selecting Railways industrial Type from railways SpatialLinesDataFrame

industrial_rway <- railways_RD[railways$type== "industrial",]
str (industrial_rway)

#Buffering the industrial railways
industrial_rway_buffer <- gBuffer(industrial_rway, width=1000, byid=TRUE, quadsegs=10, capStyle="ROUND")
plot (industrial_rway_buffer)

#Intersecting the Buffer area with the layer "places"
#The tool gIntersection give a Spatialobject. We loose information of the data frame associated at the places layer. 
# to solve that, we assign an ID from the places layer as an argument of the gIntersection function.

places_intersec <- gIntersection(places_RD,industrial_rway_buffer,id= as.character(places_RD$osm_id), byid = TRUE)

#Subseting from the projected places layer the cities that falls in the buffer zone.

city_inside <- places_RD[places_RD$osm_id == rownames(places_intersec@coords),]

# City name and the population of it
city_name <- city_inside$name
city_pop <- city_inside$population


# Plotting of the buffer, the points, and the name of the city



plot(industrial_rway_buffer, col = c("gray60"))
plot(places_RD, add = TRUE, col="red", pch=19, cex=1.5)
text(places_RD,city_inside$name,cex = 0.8)
box()
mtext("Map of the city inside a Buffer Zone around Industrial Railways",side =3)


# printing the population of the city (Utrecht)
print(paste("The population of", city_name, "is", city_pop, "people.", sep=" "))



#city name : Utrecht
#Population: 100000
