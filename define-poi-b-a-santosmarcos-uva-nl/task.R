setwd('/app')
library(optparse)
library(jsonlite)

if (!requireNamespace("dplyr", quietly = TRUE)) {
	install.packages("dplyr", repos="http://cran.us.r-project.org")
}
library(dplyr)
if (!requireNamespace("sf", quietly = TRUE)) {
	install.packages("sf", repos="http://cran.us.r-project.org")
}
library(sf)
if (!requireNamespace("terra", quietly = TRUE)) {
	install.packages("terra", repos="http://cran.us.r-project.org")
}
library(terra)



print('option_list')
option_list = list(

make_option(c("--param_poi_end"), action="store", default=NA, type="character", help="my description"),
make_option(c("--param_poi_start"), action="store", default=NA, type="character", help="my description"),
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

print("Retrieving param_poi_end")
var = opt$param_poi_end
print(var)
var_len = length(var)
print(paste("Variable param_poi_end has length", var_len))

param_poi_end <- gsub("\"", "", opt$param_poi_end)
print("Retrieving param_poi_start")
var = opt$param_poi_start
print(var)
var_len = length(var)
print(paste("Variable param_poi_start has length", var_len))

param_poi_start <- gsub("\"", "", opt$param_poi_start)
id <- gsub('"', '', opt$id)


print("Running the cell")
param_poi_start <- "2001-01-01"

param_poi_end <- "2021-12-31"
# capturing outputs
print('Serialization of param_poi_end')
file <- file(paste0('/tmp/param_poi_end_', id, '.json'))
writeLines(toJSON(param_poi_end, auto_unbox=TRUE), file)
close(file)
print('Serialization of param_poi_start')
file <- file(paste0('/tmp/param_poi_start_', id, '.json'))
writeLines(toJSON(param_poi_start, auto_unbox=TRUE), file)
close(file)
