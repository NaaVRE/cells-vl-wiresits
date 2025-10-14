setwd('/app')
library(optparse)
library(jsonlite)

if (!requireNamespace("terra", quietly = TRUE)) {
	install.packages("terra", repos="http://cran.us.r-project.org")
}
library(terra)
if (!requireNamespace("ptw", quietly = TRUE)) {
	install.packages("ptw", repos="http://cran.us.r-project.org")
}
library(ptw)



print('option_list')
option_list = list(

make_option(c("--conf_data"), action="store", default=NA, type="character", help="my description"),
make_option(c("--conf_path_tctb_h"), action="store", default=NA, type="character", help="my description"),
make_option(c("--conf_path_tctg_h"), action="store", default=NA, type="character", help="my description"),
make_option(c("--conf_path_tctw_h"), action="store", default=NA, type="character", help="my description"),
make_option(c("--param_wh_lambda"), action="store", default=NA, type="integer", help="my description"),
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
print("Retrieving conf_path_tctb_h")
var = opt$conf_path_tctb_h
print(var)
var_len = length(var)
print(paste("Variable conf_path_tctb_h has length", var_len))

conf_path_tctb_h <- gsub("\"", "", opt$conf_path_tctb_h)
print("Retrieving conf_path_tctg_h")
var = opt$conf_path_tctg_h
print(var)
var_len = length(var)
print(paste("Variable conf_path_tctg_h has length", var_len))

conf_path_tctg_h <- gsub("\"", "", opt$conf_path_tctg_h)
print("Retrieving conf_path_tctw_h")
var = opt$conf_path_tctw_h
print(var)
var_len = length(var)
print(paste("Variable conf_path_tctw_h has length", var_len))

conf_path_tctw_h <- gsub("\"", "", opt$conf_path_tctw_h)
print("Retrieving param_wh_lambda")
var = opt$param_wh_lambda
print(var)
var_len = length(var)
print(paste("Variable param_wh_lambda has length", var_len))

param_wh_lambda = opt$param_wh_lambda
id <- gsub('"', '', opt$id)

conf_wd<-getwd
conf_data<-paste

print("Running the cell")
library(terra)
library(ptw)

source(paste0(conf_wd, "/R/whithen.R"))

modis_tct_path <- paste0(conf_data, "/modis_tct")
if (!dir.exists(modis_tct_path)) {
  dir.create(modis_tct_path)
}
conf_path_tctb_s <- paste0(modis_tct_path, "/tctb_s.tif")
conf_path_tctg_s <- paste0(modis_tct_path, "/tctg_s.tif")
conf_path_tctw_s <- paste0(modis_tct_path, "/tctw_s.tif")

tctb_h <- rast(paste0(modis_tct_path, "/tctb_h.tif"))
tctg_h <- rast(paste0(modis_tct_path, "/tctg_h.tif"))
tctw_h <- rast(paste0(modis_tct_path, "/tctw_h.tif"))

cat("TCTB... ")
tctb_s <- app(tctb_h, fun = whithen, cores = 3)
writeRaster(x = tctb_s, filename = conf_path_tctb_s, overwrite = TRUE)
cat("TCTG... ")
tctg_s <- app(tctg_h, fun = whithen, cores = 3)
writeRaster(x = tctg_s, filename = conf_path_tctg_s, overwrite = TRUE)
cat("TCTW... ")
tctw_s <- app(tctw_h, fun = whithen, cores = 3)
writeRaster(x = tctw_s, filename = conf_path_tctw_s, overwrite = TRUE)
cat("Done.\n")
# capturing outputs
print('Serialization of conf_path_tctb_s')
file <- file(paste0('/tmp/conf_path_tctb_s_', id, '.json'))
writeLines(toJSON(conf_path_tctb_s, auto_unbox=TRUE), file)
close(file)
print('Serialization of conf_path_tctg_s')
file <- file(paste0('/tmp/conf_path_tctg_s_', id, '.json'))
writeLines(toJSON(conf_path_tctg_s, auto_unbox=TRUE), file)
close(file)
print('Serialization of conf_path_tctw_s')
file <- file(paste0('/tmp/conf_path_tctw_s_', id, '.json'))
writeLines(toJSON(conf_path_tctw_s, auto_unbox=TRUE), file)
close(file)
