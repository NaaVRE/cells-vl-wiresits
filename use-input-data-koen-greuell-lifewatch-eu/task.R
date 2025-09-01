setwd('/app')
library(optparse)
library(jsonlite)

if (!requireNamespace("cli", quietly = TRUE)) {
	install.packages("cli", repos="http://cran.us.r-project.org")
}
library(cli)



print('option_list')
option_list = list(

make_option(c("--batch_size"), action="store", default=NA, type="integer", help="my description"),
make_option(c("--data_to_batch_process"), action="store", default=NA, type="character", help="my description"),
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

id <- gsub('"', '', opt$id)


print("Running the cell")
print(data_to_batch_process)
print(batch_size)
cli::cli_text("{.arg data_to_batch_process}: {data_to_batch_process}")
cli::cli_text("{.arg batch_size}: {batch_size}")
