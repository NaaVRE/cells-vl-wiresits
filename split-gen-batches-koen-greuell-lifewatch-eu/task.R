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
make_option(c("--param_max_batch_count"), action="store", default=NA, type="integer", help="my description"),
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

print("Retrieving param_max_batch_count")
var = opt$param_max_batch_count
print(var)
var_len = length(var)
print(paste("Variable param_max_batch_count has length", var_len))

param_max_batch_count = opt$param_max_batch_count
id <- gsub('"', '', opt$id)


print("Running the cell")
start_indices <- list()
start_indices <- seq(1, length(data_to_batch_process), by = batch_size)
start_indices <- ifelse(
    param_max_batch_count > 1, 
    start_indices <- seq(1, length(data_to_batch_process), by = batch_size), 
    start_indices <- c(1))
cli::cli_text("{.arg start_indices}: {start_indices}")
# capturing outputs
print('Serialization of start_indices')
file <- file(paste0('/tmp/start_indices_', id, '.json'))
writeLines(toJSON(start_indices, auto_unbox=TRUE), file)
close(file)
