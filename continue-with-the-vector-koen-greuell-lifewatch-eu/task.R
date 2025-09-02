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

make_option(c("--result_vector"), action="store", default=NA, type="character", help="my description"),
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

print("Retrieving result_vector")
var = opt$result_vector
print(var)
var_len = length(var)
print(paste("Variable result_vector has length", var_len))

print("------------------------Running var_serialization for result_vector-----------------------")
print(opt$result_vector)
result_vector = var_serialization(opt$result_vector)
print("---------------------------------------------------------------------------------")

id <- gsub('"', '', opt$id)


print("Running the cell")
final_result_vector <- list()
final_result_vector <- unlist(result_vector)
print(final_result_vector)
