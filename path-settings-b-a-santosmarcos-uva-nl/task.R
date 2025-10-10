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
if (!requireNamespace("SecretsProvider", quietly = TRUE)) {
	install.packages("SecretsProvider", repos="http://cran.us.r-project.org")
}
library(SecretsProvider)
if (!requireNamespace("modisfast", quietly = TRUE)) {
	install.packages("modisfast", repos="http://cran.us.r-project.org")
}
library(modisfast)
if (!requireNamespace("ptw", quietly = TRUE)) {
	install.packages("ptw", repos="http://cran.us.r-project.org")
}
library(ptw)



print('option_list')
option_list = list(

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

id <- gsub('"', '', opt$id)


print("Running the cell")
conf_wd <- getwd()

conf_data <- paste(conf_wd, "data", sep = "/")
if (!dir.exists(conf_data)) {
  dir.create(conf_data)
}

Sys.setenv(PROJ_LIB = paste0(conf_wd, ".conda/share/proj"))
# capturing outputs
print('Serialization of conf_data')
file <- file(paste0('/tmp/conf_data_', id, '.json'))
writeLines(toJSON(conf_data, auto_unbox=TRUE), file)
close(file)
print('Serialization of conf_wd')
file <- file(paste0('/tmp/conf_wd_', id, '.json'))
writeLines(toJSON(conf_wd, auto_unbox=TRUE), file)
close(file)
