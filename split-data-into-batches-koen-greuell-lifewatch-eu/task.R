setwd('/app')
library(optparse)
library(jsonlite)




print('option_list')
option_list = list(

make_option(c("--param_number_of_batches"), action="store", default=NA, type="integer", help="my description"),
make_option(c("--raw_data"), action="store", default=NA, type="character", help="my description"),
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

print("Retrieving param_number_of_batches")
var = opt$param_number_of_batches
print(var)
var_len = length(var)
print(paste("Variable param_number_of_batches has length", var_len))

param_number_of_batches = opt$param_number_of_batches
print("Retrieving raw_data")
var = opt$raw_data
print(var)
var_len = length(var)
print(paste("Variable raw_data has length", var_len))

print("------------------------Running var_serialization for raw_data-----------------------")
print(opt$raw_data)
raw_data = var_serialization(opt$raw_data)
print("---------------------------------------------------------------------------------")

id <- gsub('"', '', opt$id)


print("Running the cell")
split_into_batches <- function(list_, number_of_batches) {
    return(split(list_, rep_len(1:number_of_batches, length(list_))))
}

raw_data_in_batches <- list()
raw_data_in_batches <- split_into_batches(raw_data, param_number_of_batches)
# capturing outputs
print('Serialization of raw_data_in_batches')
file <- file(paste0('/tmp/raw_data_in_batches_', id, '.json'))
writeLines(toJSON(raw_data_in_batches, auto_unbox=TRUE), file)
close(file)
