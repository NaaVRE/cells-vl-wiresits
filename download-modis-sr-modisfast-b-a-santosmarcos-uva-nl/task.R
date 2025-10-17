setwd('/app')
library(optparse)
library(jsonlite)

if (!requireNamespace("SecretsProvider", quietly = TRUE)) {
	install.packages("SecretsProvider", repos="http://cran.us.r-project.org")
}
library(SecretsProvider)
if (!requireNamespace("modisfast", quietly = TRUE)) {
	install.packages("modisfast", repos="http://cran.us.r-project.org")
}
library(modisfast)
if (!requireNamespace("sf", quietly = TRUE)) {
	install.packages("sf", repos="http://cran.us.r-project.org")
}
library(sf)
if (!requireNamespace("terra", quietly = TRUE)) {
	install.packages("terra", repos="http://cran.us.r-project.org")
}
library(terra)


secret_pw = Sys.getenv('secret_pw')
secret_un = Sys.getenv('secret_un')

print('option_list')
option_list = list(

make_option(c("--param_enddate"), action="store", default=NA, type="character", help="my description"),
make_option(c("--param_layersid"), action="store", default=NA, type="character", help="my description"),
make_option(c("--param_productid"), action="store", default=NA, type="character", help="my description"),
make_option(c("--param_roiid"), action="store", default=NA, type="character", help="my description"),
make_option(c("--param_roipath"), action="store", default=NA, type="character", help="my description"),
make_option(c("--param_startdate"), action="store", default=NA, type="character", help="my description"),
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

print("Retrieving param_enddate")
var = opt$param_enddate
print(var)
var_len = length(var)
print(paste("Variable param_enddate has length", var_len))

param_enddate <- gsub("\"", "", opt$param_enddate)
print("Retrieving param_layersid")
var = opt$param_layersid
print(var)
var_len = length(var)
print(paste("Variable param_layersid has length", var_len))

print("------------------------Running var_serialization for param_layersid-----------------------")
print(opt$param_layersid)
param_layersid = var_serialization(opt$param_layersid)
print("---------------------------------------------------------------------------------")

print("Retrieving param_productid")
var = opt$param_productid
print(var)
var_len = length(var)
print(paste("Variable param_productid has length", var_len))

param_productid <- gsub("\"", "", opt$param_productid)
print("Retrieving param_roiid")
var = opt$param_roiid
print(var)
var_len = length(var)
print(paste("Variable param_roiid has length", var_len))

param_roiid <- gsub("\"", "", opt$param_roiid)
print("Retrieving param_roipath")
var = opt$param_roipath
print(var)
var_len = length(var)
print(paste("Variable param_roipath has length", var_len))

param_roipath <- gsub("\"", "", opt$param_roipath)
print("Retrieving param_startdate")
var = opt$param_startdate
print(var)
var_len = length(var)
print(paste("Variable param_startdate has length", var_len))

param_startdate <- gsub("\"", "", opt$param_startdate)
id <- gsub('"', '', opt$id)


print("Running the cell")
library(SecretsProvider)
library(modisfast)
library(sf)
library(terra)

param_startdate <- "2001-01-01"
param_enddate <- "2021-12-31"
param_productid <- "MOD09A1.061"
param_layersid <- paste0("sur_refl_b0", 1:7)
param_roiid <- "test_roi"

path_wd <- getwd()
Sys.setenv(PROJ_LIB = paste0(path_wd, ".conda/share/proj"))
path_data <- paste0(path_wd, "/data")
if (!dir.exists(path_data)) {
  dir.create(path_data)
}
path_roi <- paste0(path_wd, "/data/test_roi.geojson")
path_modisfast <- paste0(path_wd, "/data/modisfast")
path_roidir <- paste0(path_modisfast, "/data/", param_roiid)
path_dl <- paste0(path_roidir, "/resdl.rds")
path_sr <- paste0(path_data, "/modis_sr")

secretsProvider <- SecretsProvider()
secret_un <- secretsProvider$get_secret("earthdata_username")
secret_pw <- secretsProvider$get_secret("earthdata_password")



roi <- st_read(path_roi)
urls <- mf_get_url(
  collection = param_productid,
  variables = param_layersid,
  roi = roi,
  time_range = as.Date(c(param_startdate, param_enddate)),
  output_format = "nc4",
  single_netcdf = FALSE,
  credentials = c(secret_un, secret_pw)
)

resdl <- mf_download_data(
  df_to_dl = urls,
  path = path_modisfast,
  parallel = TRUE,
  credentials = c(secret_un, secret_pw)
)
saveRDS(resdl, file = path_dl)



r <- mf_import_data(
  path = dirname(resdl$destfile[1]),
  collection = param_productid
)

names(r) <- names(r) |>
  strsplit("_") |>
  lapply(FUN = function(x) x[3]) |>
  unlist() |>
  paste(gsub("-", "", time(r)), sep = "_")

rt <- names(r) |>
  strsplit("_") |>
  lapply(FUN = function(x) x[1]) |>
  unlist()

if (!dir.exists(path_sr)) {
  dir.create(path_sr)
}
path_sr_bands <- paste0(path_sr, "/b", 1:7, ".tif")
for (i in 1:7) {
  subset(r, which(rt == paste0("b0", i)), file = path_sr_bands[i], overwrite = TRUE)
}
# capturing outputs
print('Serialization of path_dl')
file <- file(paste0('/tmp/path_dl_', id, '.json'))
writeLines(toJSON(path_dl, auto_unbox=TRUE), file)
close(file)
print('Serialization of path_sr')
file <- file(paste0('/tmp/path_sr_', id, '.json'))
writeLines(toJSON(path_sr, auto_unbox=TRUE), file)
close(file)
