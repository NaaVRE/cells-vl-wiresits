setwd('/app')
library(optparse)
library(jsonlite)




print('option_list')
option_list = list(

make_option(c("--param_batch_size"), action="store", default=NA, type="integer", help="my description"),
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

print("Retrieving param_batch_size")
var = opt$param_batch_size
print(var)
var_len = length(var)
print(paste("Variable param_batch_size has length", var_len))

param_batch_size = opt$param_batch_size
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
batched_raw_data <- list()
batched_raw_data <- split(raw_data, ceiling(seq_along(raw_data) / param_batch_size))
# capturing outputs
print('Serialization of batched_raw_data')
file <- file(paste0('/tmp/batched_raw_data_', id, '.json'))
writeLines(toJSON(batched_raw_data, auto_unbox=TRUE), file)
close(file)
