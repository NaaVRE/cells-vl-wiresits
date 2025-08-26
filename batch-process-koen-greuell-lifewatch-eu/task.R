setwd('/app')
library(optparse)
library(jsonlite)

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
library(purrr)

convert_binary_to_int <- function(binary_string) {
  return(strtoi(binary_string, base = 2))
}

perform_calculation <- function(item) {
  return(convert_binary_to_int(item))
}

data_to_batch_process <- raw_vector_data


batch_size <- ceiling(length(data_to_batch_process)/param_number_of_batches)

start_indices <- seq(1, length(data_to_batch_process), by = batch_size)

result_vector <- purrr::map(start_indices, function(i) {
  end_index <- i + batch_size - 1
  
  if (end_index > length(data_to_batch_process)) {
    end_index <- length(data_to_batch_process)
  }
  
  current_batch <- data_to_batch_process[i:end_index]
  
  calculated_batch <- purrr::map(current_batch, perform_calculation)
  
  return(calculated_batch)
})

final_result_vector <- list()
final_result_vector <- unlist(result_vector)
# capturing outputs
print('Serialization of final_result_vector')
file <- file(paste0('/tmp/final_result_vector_', id, '.json'))
writeLines(toJSON(final_result_vector, auto_unbox=TRUE), file)
close(file)
