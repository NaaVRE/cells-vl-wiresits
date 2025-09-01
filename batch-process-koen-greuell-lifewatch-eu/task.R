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

make_option(c("--batch_size"), action="store", default=NA, type="integer", help="my description"),
make_option(c("--data_to_batch_process"), action="store", default=NA, type="character", help="my description"),
make_option(c("--start_indices"), action="store", default=NA, type="character", help="my description"),
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

print("Retrieving batch_size")
var = opt$batch_size
print(var)
var_len = length(var)
print(paste("Variable batch_size has length", var_len))

batch_size = opt$batch_size
print("Retrieving data_to_batch_process")
var = opt$data_to_batch_process
print(var)
var_len = length(var)
print(paste("Variable data_to_batch_process has length", var_len))

print("------------------------Running var_serialization for data_to_batch_process-----------------------")
print(opt$data_to_batch_process)
data_to_batch_process = var_serialization(opt$data_to_batch_process)
print("---------------------------------------------------------------------------------")

print("Retrieving start_indices")
var = opt$start_indices
print(var)
var_len = length(var)
print(paste("Variable start_indices has length", var_len))

print("------------------------Running var_serialization for start_indices-----------------------")
print(opt$start_indices)
start_indices = var_serialization(opt$start_indices)
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


result_vector <- purrr::map(start_indices, function(i) {
  end_index <- i + batch_size - 1
  if (end_index > length(data_to_batch_process)) {
    end_index <- length(data_to_batch_process)
  }
  current_batch <- data_to_batch_process[i:end_index]
  calculated_batch <- purrr::map(current_batch, perform_calculation)
  return(calculated_batch)
})

print(result_vector)
final_result_vector <- list()
final_result_vector <- unlist(result_vector)
# capturing outputs
print('Serialization of final_result_vector')
file <- file(paste0('/tmp/final_result_vector_', id, '.json'))
writeLines(toJSON(final_result_vector, auto_unbox=TRUE), file)
close(file)
