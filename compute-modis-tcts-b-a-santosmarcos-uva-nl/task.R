setwd('/app')
library(optparse)
library(jsonlite)

if (!requireNamespace("terra", quietly = TRUE)) {
	install.packages("terra", repos="http://cran.us.r-project.org")
}
library(terra)



print('option_list')
option_list = list(

make_option(c("--conf_data"), action="store", default=NA, type="character", help="my description"),
make_option(c("--conf_wd"), action="store", default=NA, type="character", help="my description"),
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

print("Retrieving conf_data")
var = opt$conf_data
print(var)
var_len = length(var)
print(paste("Variable conf_data has length", var_len))

conf_data <- gsub("\"", "", opt$conf_data)
print("Retrieving conf_wd")
var = opt$conf_wd
print(var)
var_len = length(var)
print(paste("Variable conf_wd has length", var_len))

conf_wd <- gsub("\"", "", opt$conf_wd)
id <- gsub('"', '', opt$id)

conf_wd<-getwd
conf_data<-paste

print("Running the cell")
library(terra)

source(paste0(conf_wd, "/R/modis_tct.R"))

modis_tct_path <- paste0(conf_data, "/modis_tct")
if (!dir.exists(modis_tct_path)) {
  dir.create(modis_tct_path)
}
conf_path_tctb <- paste0(modis_tct_path, "/tctb.tif")
conf_path_tctg <- paste0(modis_tct_path, "/tctg.tif")
conf_path_tctw <- paste0(modis_tct_path, "/tctw.tif")

b1 <- rast(paste0(conf_data, "/modis_sr/b1_dgf.tif"))
b2 <- rast(paste0(conf_data, "/modis_sr/b2_dgf.tif"))
b3 <- rast(paste0(conf_data, "/modis_sr/b3_dgf.tif"))
b4 <- rast(paste0(conf_data, "/modis_sr/b4_dgf.tif"))
b5 <- rast(paste0(conf_data, "/modis_sr/b5_dgf.tif"))
b6 <- rast(paste0(conf_data, "/modis_sr/b6_dgf.tif"))
b7 <- rast(paste0(conf_data, "/modis_sr/b7_dgf.tif"))

cat("TCTB... ")
tctb <- modis_tctb(b1, b2, b3, b4, b5, b6, b7)
writeRaster(tctb, filename = conf_path_tctb, overwrite = TRUE)
cat("TCTG... ")
tctg <- modis_tctg(b1, b2, b3, b4, b5, b6, b7)
writeRaster(tctg, filename = conf_path_tctg, overwrite = TRUE)
cat("TCTW... ")
tctw <- modis_tctw(b1, b2, b3, b4, b5, b6, b7)
writeRaster(tctw, filename = conf_path_tctw, overwrite = TRUE)
cat("Done.\n")
# capturing outputs
print('Serialization of conf_path_tctb')
file <- file(paste0('/tmp/conf_path_tctb_', id, '.json'))
writeLines(toJSON(conf_path_tctb, auto_unbox=TRUE), file)
close(file)
print('Serialization of conf_path_tctg')
file <- file(paste0('/tmp/conf_path_tctg_', id, '.json'))
writeLines(toJSON(conf_path_tctg, auto_unbox=TRUE), file)
close(file)
print('Serialization of conf_path_tctw')
file <- file(paste0('/tmp/conf_path_tctw_', id, '.json'))
writeLines(toJSON(conf_path_tctw, auto_unbox=TRUE), file)
close(file)
