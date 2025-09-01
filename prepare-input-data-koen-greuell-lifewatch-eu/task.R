setwd('/app')
library(optparse)
library(jsonlite)

if (!requireNamespace("cli", quietly = TRUE)) {
	install.packages("cli", repos="http://cran.us.r-project.org")
}
library(cli)
if (!requireNamespace("purrr", quietly = TRUE)) {
	install.packages("purrr", repos="http://cran.us.r-project.org")
}
library(purrr)



print('option_list')
option_list = list(

make_option(c("--param_number_of_batches"), action="store", default=NA, type="integer", help="my description"),
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

print("Retrieving param_number_of_batches")
var = opt$param_number_of_batches
print(var)
var_len = length(var)
print(paste("Variable param_number_of_batches has length", var_len))

param_number_of_batches = opt$param_number_of_batches
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
cli::cli_text("{.arg raw_vector_data}: {raw_vector_data}")
data_to_batch_process <- list()
data_to_batch_process <- raw_vector_data

batch_size <- 0
batch_size <- ceiling(length(data_to_batch_process)/param_number_of_batches)
# capturing outputs
print('Serialization of batch_size')
file <- file(paste0('/tmp/batch_size_', id, '.json'))
writeLines(toJSON(batch_size, auto_unbox=TRUE), file)
close(file)
print('Serialization of data_to_batch_process')
file <- file(paste0('/tmp/data_to_batch_process_', id, '.json'))
writeLines(toJSON(data_to_batch_process, auto_unbox=TRUE), file)
close(file)
