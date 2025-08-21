setwd('/app')
library(optparse)
library(jsonlite)




print('option_list')
option_list = list(

make_option(c("--batched_processed_data"), action="store", default=NA, type="character", help="my description"),
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

print("Retrieving batched_processed_data")
var = opt$batched_processed_data
print(var)
var_len = length(var)
print(paste("Variable batched_processed_data has length", var_len))

print("------------------------Running var_serialization for batched_processed_data-----------------------")
print(opt$batched_processed_data)
batched_processed_data = var_serialization(opt$batched_processed_data)
print("---------------------------------------------------------------------------------")

id <- gsub('"', '', opt$id)


print("Running the cell")
processed_data <- list()
processed_data <- unlist(batched_processed_data, recursive = FALSE)
# capturing outputs
print('Serialization of processed_data')
file <- file(paste0('/tmp/processed_data_', id, '.json'))
writeLines(toJSON(processed_data, auto_unbox=TRUE), file)
close(file)
