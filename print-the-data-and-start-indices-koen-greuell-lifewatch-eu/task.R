setwd('/app')
library(optparse)
library(jsonlite)




print('option_list')
option_list = list(

make_option(c("--data_as_list_to_batch_process"), action="store", default=NA, type="character", help="my description"),
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

print("Retrieving data_as_list_to_batch_process")
var = opt$data_as_list_to_batch_process
print(var)
var_len = length(var)
print(paste("Variable data_as_list_to_batch_process has length", var_len))

print("------------------------Running var_serialization for data_as_list_to_batch_process-----------------------")
print(opt$data_as_list_to_batch_process)
data_as_list_to_batch_process = var_serialization(opt$data_as_list_to_batch_process)
print("---------------------------------------------------------------------------------")

id <- gsub('"', '', opt$id)


print("Running the cell")
print(data_as_list_to_batch_process)
