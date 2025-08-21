setwd('/app')
library(optparse)
library(jsonlite)




print('option_list')
option_list = list(

make_option(c("--data_in_c_to_process"), action="store", default=NA, type="character", help="my description"),
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

print("Retrieving data_in_c_to_process")
var = opt$data_in_c_to_process
print(var)
var_len = length(var)
print(paste("Variable data_in_c_to_process has length", var_len))

print("------------------------Running var_serialization for data_in_c_to_process-----------------------")
print(opt$data_in_c_to_process)
data_in_c_to_process = var_serialization(opt$data_in_c_to_process)
print("---------------------------------------------------------------------------------")

id <- gsub('"', '', opt$id)


print("Running the cell")
process_data <- function(item) {
  processed_item <- gsub("raw", "processed", item)
  return(processed_item)
}

processed_c_data <- c()
processed_c_data <- lapply(data_in_c_to_process, process_data)
# capturing outputs
print('Serialization of processed_c_data')
file <- file(paste0('/tmp/processed_c_data_', id, '.json'))
writeLines(toJSON(processed_c_data, auto_unbox=TRUE), file)
close(file)
