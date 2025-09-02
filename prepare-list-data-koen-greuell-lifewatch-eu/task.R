setwd('/app')
library(optparse)
library(jsonlite)




print('option_list')
option_list = list(

make_option(c("--raw_list_data"), action="store", default=NA, type="character", help="my description"),
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

print("Retrieving raw_list_data")
var = opt$raw_list_data
print(var)
var_len = length(var)
print(paste("Variable raw_list_data has length", var_len))

print("------------------------Running var_serialization for raw_list_data-----------------------")
print(opt$raw_list_data)
raw_list_data = var_serialization(opt$raw_list_data)
print("---------------------------------------------------------------------------------")

id <- gsub('"', '', opt$id)


print("Running the cell")
data_as_list_to_batch_process <- list()
data_as_list_to_batch_process <- raw_list_data
# capturing outputs
print('Serialization of data_as_list_to_batch_process')
file <- file(paste0('/tmp/data_as_list_to_batch_process_', id, '.json'))
writeLines(toJSON(data_as_list_to_batch_process, auto_unbox=TRUE), file)
close(file)
