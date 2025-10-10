setwd('/app')
library(optparse)
library(jsonlite)

if (!requireNamespace("sf", quietly = TRUE)) {
	install.packages("sf", repos="http://cran.us.r-project.org")
}
library(sf)
if (!requireNamespace("terra", quietly = TRUE)) {
	install.packages("terra", repos="http://cran.us.r-project.org")
}
library(terra)
if (!requireNamespace("dplyr", quietly = TRUE)) {
	install.packages("dplyr", repos="http://cran.us.r-project.org")
}
library(dplyr)



print('option_list')
option_list = list(

make_option(c("--param_roi_bdr"), action="store", default=NA, type="integer", help="my description"),
make_option(c("--param_roi_crs"), action="store", default=NA, type="character", help="my description"),
make_option(c("--param_roi_id"), action="store", default=NA, type="character", help="my description"),
make_option(c("--id"), action="store", default=NA, type="character", help="task id")
)


opt = parse_args(OptionParser(option_list=option_list))

var_serialization <- function(var){
    if (is.null(var)){
        print("Variable is null")
        exit(1)
    }
    tryCatch(
        {
            var <- fromJSON(var)
            print("Variable deserialized")
            return(var)
        },
        error=function(e) {
            print("Error while deserializing the variable")
            print(var)
            var <- gsub("'", '"', var)
            var <- fromJSON(var)
            print("Variable deserialized")
            return(var)
        },
        warning=function(w) {
            print("Warning while deserializing the variable")
            var <- gsub("'", '"', var)
            var <- fromJSON(var)
            print("Variable deserialized")
            return(var)
        }
    )
}

print("Retrieving param_roi_bdr")
var = opt$param_roi_bdr
print(var)
var_len = length(var)
print(paste("Variable param_roi_bdr has length", var_len))

param_roi_bdr = opt$param_roi_bdr
print("Retrieving param_roi_crs")
var = opt$param_roi_crs
print(var)
var_len = length(var)
print(paste("Variable param_roi_crs has length", var_len))

param_roi_crs <- gsub("\"", "", opt$param_roi_crs)
print("Retrieving param_roi_id")
var = opt$param_roi_id
print(var)
var_len = length(var)
print(paste("Variable param_roi_id has length", var_len))

param_roi_id <- gsub("\"", "", opt$param_roi_id)
id <- gsub('"', '', opt$id)

conf_dd<-paste

print("Running the cell")
library(sf)
library(terra)
library(dplyr)


param_roi_bdr <- c(xmin = 558000, ymin = 4520000, xmax = 587000, ymax = 4535000)

param_roi_crs <- "EPSG:32629"

param_roi_id <- "sample_ba"


roi <- ext(
  param_roi_bdr["xmin"], param_roi_bdr["xmax"],
  param_roi_bdr["ymin"], param_roi_bdr["ymax"]
) |>
  vect(crs = "EPSG:32629") |>
  st_as_sf() |>
  st_transform(st_crs(param_roi_crs))
roi$id <- param_roi_id

conf_rois <- paste(conf_dd, "rois", sep = "/")
if (!dir.exists(conf_rois)) {
  dir.create(conf_rois)
}
conf_roi_sampleba <- paste0(conf_rois, "/", param_roi_id, ".geojson")
if (!file.exists(conf_roi_sampleba)) {
  st_write(roi, dsn = conf_roi_sampleba, driver = "GeoJSON", append = FALSE)
}
# capturing outputs
print('Serialization of conf_roi_sampleba')
file <- file(paste0('/tmp/conf_roi_sampleba_', id, '.json'))
writeLines(toJSON(conf_roi_sampleba, auto_unbox=TRUE), file)
close(file)
