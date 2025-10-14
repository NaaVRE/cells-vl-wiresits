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
make_option(c("--conf_path_tctb"), action="store", default=NA, type="character", help="my description"),
make_option(c("--conf_path_tctg"), action="store", default=NA, type="character", help="my description"),
make_option(c("--conf_path_tctw"), action="store", default=NA, type="character", help="my description"),
make_option(c("--param_hampel_k"), action="store", default=NA, type="integer", help="my description"),
make_option(c("--param_hampel_t0"), action="store", default=NA, type="integer", help="my description"),
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
print("Retrieving conf_path_tctb")
var = opt$conf_path_tctb
print(var)
var_len = length(var)
print(paste("Variable conf_path_tctb has length", var_len))

conf_path_tctb <- gsub("\"", "", opt$conf_path_tctb)
print("Retrieving conf_path_tctg")
var = opt$conf_path_tctg
print(var)
var_len = length(var)
print(paste("Variable conf_path_tctg has length", var_len))

conf_path_tctg <- gsub("\"", "", opt$conf_path_tctg)
print("Retrieving conf_path_tctw")
var = opt$conf_path_tctw
print(var)
var_len = length(var)
print(paste("Variable conf_path_tctw has length", var_len))

conf_path_tctw <- gsub("\"", "", opt$conf_path_tctw)
print("Retrieving param_hampel_k")
var = opt$param_hampel_k
print(var)
var_len = length(var)
print(paste("Variable param_hampel_k has length", var_len))

param_hampel_k = opt$param_hampel_k
print("Retrieving param_hampel_t0")
var = opt$param_hampel_t0
print(var)
var_len = length(var)
print(paste("Variable param_hampel_t0 has length", var_len))

param_hampel_t0 = opt$param_hampel_t0
id <- gsub('"', '', opt$id)

conf_wd<-getwd
conf_data<-paste

print("Running the cell")
library(terra)

source(paste0(conf_wd, "/R/hampel.R"))

modis_tct_path <- paste0(conf_data, "/modis_tct")
if (!dir.exists(modis_tct_path)) {
  dir.create(modis_tct_path)
}
conf_path_tctb_h <- paste0(modis_tct_path, "/tctb_h.tif")
conf_path_tctg_h <- paste0(modis_tct_path, "/tctg_h.tif")
conf_path_tctw_h <- paste0(modis_tct_path, "/tctw_h.tif")

tctb <- rast(paste0(modis_tct_path, "/tctb.tif"))
tctg <- rast(paste0(modis_tct_path, "/tctg.tif"))
tctw <- rast(paste0(modis_tct_path, "/tctw.tif"))

cat("TCTB... ")
tctb_h <- app(tctb, fun = hampel, cores = 3)
cat("TCTG... ")
tctg_h <- app(tctg, fun = hampel, cores = 3)
cat("TCTW... ")
tctw_h <- app(tctw, fun = hampel, cores = 3)
cat("Done.\n")
# capturing outputs
print('Serialization of conf_path_tctb_h')
file <- file(paste0('/tmp/conf_path_tctb_h_', id, '.json'))
writeLines(toJSON(conf_path_tctb_h, auto_unbox=TRUE), file)
close(file)
print('Serialization of conf_path_tctg_h')
file <- file(paste0('/tmp/conf_path_tctg_h_', id, '.json'))
writeLines(toJSON(conf_path_tctg_h, auto_unbox=TRUE), file)
close(file)
print('Serialization of conf_path_tctw_h')
file <- file(paste0('/tmp/conf_path_tctw_h_', id, '.json'))
writeLines(toJSON(conf_path_tctw_h, auto_unbox=TRUE), file)
close(file)
