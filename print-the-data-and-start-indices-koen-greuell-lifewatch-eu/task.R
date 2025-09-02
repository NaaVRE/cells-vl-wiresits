setwd('/app')
library(optparse)
library(jsonlite)

if (!requireNamespace("cli", quietly = TRUE)) {
	install.packages("cli", repos="http://cran.us.r-project.org")
}
library(cli)
if (!requireNamespace("purrr", quietly = TRUE)) {
	install.packages("purrr", repos="http://cran.us.r-project.org")
}
library(purrr)



print('option_list')
option_list = list(

make_option(c("--data_to_batch_process"), action="store", default=NA, type="character", help="my description"),
make_option(c("--start_indices"), action="store", default=NA, type="character", help="my description"),
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

print("Retrieving data_to_batch_process")
var = opt$data_to_batch_process
print(var)
var_len = length(var)
print(paste("Variable data_to_batch_process has length", var_len))

print("------------------------Running var_serialization for data_to_batch_process-----------------------")
print(opt$data_to_batch_process)
data_to_batch_process = var_serialization(opt$data_to_batch_process)
print("---------------------------------------------------------------------------------")

print("Retrieving start_indices")
var = opt$start_indices
print(var)
var_len = length(var)
print(paste("Variable start_indices has length", var_len))

print("------------------------Running var_serialization for start_indices-----------------------")
print(opt$start_indices)
start_indices = var_serialization(opt$start_indices)
print("---------------------------------------------------------------------------------")

id <- gsub('"', '', opt$id)


print("Running the cell")
print(data_to_batch_process)
print(start_indices)
