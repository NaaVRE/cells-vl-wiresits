setwd('/app')
library(optparse)
library(jsonlite)




print('option_list')
option_list = list(

make_option(c("--processed_vector_data_in_batches"), action="store", default=NA, type="character", help="my description"),
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

print("Retrieving processed_vector_data_in_batches")
var = opt$processed_vector_data_in_batches
print(var)
var_len = length(var)
print(paste("Variable processed_vector_data_in_batches has length", var_len))

print("------------------------Running var_serialization for processed_vector_data_in_batches-----------------------")
print(opt$processed_vector_data_in_batches)
processed_vector_data_in_batches = var_serialization(opt$processed_vector_data_in_batches)
print("---------------------------------------------------------------------------------")

id <- gsub('"', '', opt$id)


print("Running the cell")
processed_vector_data <- list()
processed_vector_data <- unlist(processed_vector_data_in_batches, recursive = FALSE)
# capturing outputs
print('Serialization of processed_vector_data')
file <- file(paste0('/tmp/processed_vector_data_', id, '.json'))
writeLines(toJSON(processed_vector_data, auto_unbox=TRUE), file)
close(file)
