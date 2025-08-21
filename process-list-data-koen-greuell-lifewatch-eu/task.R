setwd('/app')
library(optparse)
library(jsonlite)




print('option_list')
option_list = list(

make_option(c("--raw_list_data_in_batches"), action="store", default=NA, type="character", help="my description"),
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

print("Retrieving raw_list_data_in_batches")
var = opt$raw_list_data_in_batches
print(var)
var_len = length(var)
print(paste("Variable raw_list_data_in_batches has length", var_len))

print("------------------------Running var_serialization for raw_list_data_in_batches-----------------------")
print(opt$raw_list_data_in_batches)
raw_list_data_in_batches = var_serialization(opt$raw_list_data_in_batches)
print("---------------------------------------------------------------------------------")

id <- gsub('"', '', opt$id)


print("Running the cell")
convert_binary_to_int <- function(binary_string) {
  return(strtoi(binary_string, base = 2))
}

cat("raw_list_data_in_batches \n")
print(raw_list_data_in_batches)

processed_list_data_in_batches <- list()
processed_list_data_in_batches <- lapply(raw_list_data_in_batches, function(batch) {
  lapply(batch, convert_binary_to_int)
})

cat("processed_list_data_in_batches \n")
print(processed_list_data_in_batches)
# capturing outputs
print('Serialization of processed_list_data_in_batches')
file <- file(paste0('/tmp/processed_list_data_in_batches_', id, '.json'))
writeLines(toJSON(processed_list_data_in_batches, auto_unbox=TRUE), file)
close(file)
