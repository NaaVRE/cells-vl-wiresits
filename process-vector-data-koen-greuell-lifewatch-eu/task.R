setwd('/app')
library(optparse)
library(jsonlite)




print('option_list')
option_list = list(

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
convert_binary_to_int <- function(binary_string) {
  return(strtoi(binary_string, base = 2))
}

processed_data <- list()
processed_data <- lapply(raw_data, function(batch) {
  lapply(batch, convert_binary_to_int)
})
# capturing outputs
print('Serialization of processed_data')
file <- file(paste0('/tmp/processed_data_', id, '.json'))
writeLines(toJSON(processed_data, auto_unbox=TRUE), file)
close(file)
