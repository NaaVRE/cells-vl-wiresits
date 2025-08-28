setwd('/app')
library(optparse)
library(jsonlite)

if (!requireNamespace("purrr", quietly = TRUE)) {
	install.packages("purrr", repos="http://cran.us.r-project.org")
}
library(purrr)



print('option_list')
option_list = list(

make_option(c("--raw_vector_data"), action="store", default=NA, type="character", help="my description"),
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

print("Retrieving raw_vector_data")
var = opt$raw_vector_data
print(var)
var_len = length(var)
print(paste("Variable raw_vector_data has length", var_len))

print("------------------------Running var_serialization for raw_vector_data-----------------------")
print(opt$raw_vector_data)
raw_vector_data = var_serialization(opt$raw_vector_data)
print("---------------------------------------------------------------------------------")

id <- gsub('"', '', opt$id)


print("Running the cell")
data_to_batch_process <- list()
data_to_batch_process <- raw_vector_data


batch_size <- 0
batch_size <- ceiling(length(data_to_batch_process)/param_number_of_batches)
start_indices <- list()
start_indices <- seq(1, length(data_to_batch_process), by = batch_size)
# capturing outputs
print('Serialization of batch_size')
file <- file(paste0('/tmp/batch_size_', id, '.json'))
writeLines(toJSON(batch_size, auto_unbox=TRUE), file)
close(file)
print('Serialization of data_to_batch_process')
file <- file(paste0('/tmp/data_to_batch_process_', id, '.json'))
writeLines(toJSON(data_to_batch_process, auto_unbox=TRUE), file)
close(file)
print('Serialization of start_indices')
file <- file(paste0('/tmp/start_indices_', id, '.json'))
writeLines(toJSON(start_indices, auto_unbox=TRUE), file)
close(file)
