setwd('/app')
library(optparse)
library(jsonlite)




print('option_list')
option_list = list(

make_option(c("--batched_raw_data"), action="store", default=NA, type="character", help="my description"),
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

print("Retrieving batched_raw_data")
var = opt$batched_raw_data
print(var)
var_len = length(var)
print(paste("Variable batched_raw_data has length", var_len))

print("------------------------Running var_serialization for batched_raw_data-----------------------")
print(opt$batched_raw_data)
batched_raw_data = var_serialization(opt$batched_raw_data)
print("---------------------------------------------------------------------------------")

id <- gsub('"', '', opt$id)


print("Running the cell")
convert_binary_to_int <- function(binary_string) {
  return(strtoi(binary_string, base = 2))
}

batched_processed_data <- list()
batched_processed_data <- lapply(batched_raw_data, function(batch) {
  lapply(batch, convert_binary_to_int)
})
# capturing outputs
print('Serialization of batched_processed_data')
file <- file(paste0('/tmp/batched_processed_data_', id, '.json'))
writeLines(toJSON(batched_processed_data, auto_unbox=TRUE), file)
close(file)
