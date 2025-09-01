setwd('/app')
library(optparse)
library(jsonlite)

if (!requireNamespace("cli", quietly = TRUE)) {
	install.packages("cli", repos="http://cran.us.r-project.org")
}
library(cli)



print('option_list')
option_list = list(

make_option(c("--data_to_batch_process"), action="store", default=NA, type="character", help="my description"),
make_option(c("--int_data_to_batch_process"), action="store", default=NA, type="character", help="my description"),
make_option(c("--int_to_process"), action="store", default=NA, type="integer", help="my description"),
make_option(c("--raw_int_data"), action="store", default=NA, type="character", help="my description"),
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

print("Retrieving int_data_to_batch_process")
var = opt$int_data_to_batch_process
print(var)
var_len = length(var)
print(paste("Variable int_data_to_batch_process has length", var_len))

print("------------------------Running var_serialization for int_data_to_batch_process-----------------------")
print(opt$int_data_to_batch_process)
int_data_to_batch_process = var_serialization(opt$int_data_to_batch_process)
print("---------------------------------------------------------------------------------")

print("Retrieving int_to_process")
var = opt$int_to_process
print(var)
var_len = length(var)
print(paste("Variable int_to_process has length", var_len))

int_to_process = opt$int_to_process
print("Retrieving raw_int_data")
var = opt$raw_int_data
print(var)
var_len = length(var)
print(paste("Variable raw_int_data has length", var_len))

print("------------------------Running var_serialization for raw_int_data-----------------------")
print(opt$raw_int_data)
raw_int_data = var_serialization(opt$raw_int_data)
print("---------------------------------------------------------------------------------")

id <- gsub('"', '', opt$id)


print("Running the cell")
print(data_to_batch_process)
print(int_data_to_batch_process)
print(int_to_process)
print(raw_int_data)
