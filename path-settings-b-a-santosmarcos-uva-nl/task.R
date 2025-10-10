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

conf_dd <- paste(conf_wd, "data", sep = "/")
if (!dir.exists(conf_dd)) {
  dir.create(conf_dd)
}

conf_cf <- paste(conf_wd, "R", sep = "/")

conf_env <- paste(conf_wd, ".conda/", sep = "/")
conf_proj_lib <- paste0(conf_env, "share/proj")
Sys.setenv(PROJ_LIB = conf_proj_lib)
# capturing outputs
print('Serialization of conf_cf')
file <- file(paste0('/tmp/conf_cf_', id, '.json'))
writeLines(toJSON(conf_cf, auto_unbox=TRUE), file)
close(file)
print('Serialization of conf_dd')
file <- file(paste0('/tmp/conf_dd_', id, '.json'))
writeLines(toJSON(conf_dd, auto_unbox=TRUE), file)
close(file)
print('Serialization of conf_env')
file <- file(paste0('/tmp/conf_env_', id, '.json'))
writeLines(toJSON(conf_env, auto_unbox=TRUE), file)
close(file)
print('Serialization of conf_proj_lib')
file <- file(paste0('/tmp/conf_proj_lib_', id, '.json'))
writeLines(toJSON(conf_proj_lib, auto_unbox=TRUE), file)
close(file)
print('Serialization of conf_wd')
file <- file(paste0('/tmp/conf_wd_', id, '.json'))
writeLines(toJSON(conf_wd, auto_unbox=TRUE), file)
close(file)
