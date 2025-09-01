setwd('/app')
library(optparse)
library(jsonlite)

if (!requireNamespace("purrr", quietly = TRUE)) {
	install.packages("purrr", repos="http://cran.us.r-project.org")
}
library(purrr)



print('option_list')
option_list = list(

make_option(c("--prepared_data"), action="store", default=NA, type="character", help="my description"),
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

print("Retrieving prepared_data")
var = opt$prepared_data
print(var)
var_len = length(var)
print(paste("Variable prepared_data has length", var_len))

print("------------------------Running var_serialization for prepared_data-----------------------")
print(opt$prepared_data)
prepared_data = var_serialization(opt$prepared_data)
print("---------------------------------------------------------------------------------")

id <- gsub('"', '', opt$id)


print("Running the cell")
filter_letters <- function(string_) {
  return(gsub("[^a-zA-Z]", "", string_))
}

processed_data <- list()
processed_data <- purrr::map(prepared_data, filter_letters)
# capturing outputs
print('Serialization of processed_data')
file <- file(paste0('/tmp/processed_data_', id, '.json'))
writeLines(toJSON(processed_data, auto_unbox=TRUE), file)
close(file)
