setwd('/app')
library(optparse)
library(jsonlite)

if (!requireNamespace("cli", quietly = TRUE)) {
	install.packages("cli", repos="http://cran.us.r-project.org")
}
library(cli)



print('option_list')
option_list = list(

make_option(c("--raw_int_data"), action="store", default=NA, type="character", help="my description"),
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

print("Retrieving raw_int_data")
var = opt$raw_int_data
print(var)
var_len = length(var)
print(paste("Variable raw_int_data has length", var_len))

print("------------------------Running var_serialization for raw_int_data-----------------------")
print(opt$raw_int_data)
raw_int_data = var_serialization(opt$raw_int_data)
print("---------------------------------------------------------------------------------")

id <- gsub('"', '', opt$id)


print("Running the cell")
cli::cli_text("{.arg raw_vector_data}: {raw_vector_data}")
int_data_to_batch_process <- list()
int_data_to_batch_process <- raw_int_data
# capturing outputs
print('Serialization of int_data_to_batch_process')
file <- file(paste0('/tmp/int_data_to_batch_process_', id, '.json'))
writeLines(toJSON(int_data_to_batch_process, auto_unbox=TRUE), file)
close(file)
