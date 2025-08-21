setwd('/app')
library(optparse)
library(jsonlite)




print('option_list')
option_list = list(

make_option(c("--processed_list_data"), action="store", default=NA, type="character", help="my description"),
make_option(c("--processed_vector_data"), action="store", default=NA, type="character", help="my description"),
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

print("Retrieving processed_list_data")
var = opt$processed_list_data
print(var)
var_len = length(var)
print(paste("Variable processed_list_data has length", var_len))

print("------------------------Running var_serialization for processed_list_data-----------------------")
print(opt$processed_list_data)
processed_list_data = var_serialization(opt$processed_list_data)
print("---------------------------------------------------------------------------------")

print("Retrieving processed_vector_data")
var = opt$processed_vector_data
print(var)
var_len = length(var)
print(paste("Variable processed_vector_data has length", var_len))

print("------------------------Running var_serialization for processed_vector_data-----------------------")
print(opt$processed_vector_data)
processed_vector_data = var_serialization(opt$processed_vector_data)
print("---------------------------------------------------------------------------------")

id <- gsub('"', '', opt$id)


print("Running the cell")
cat("processed_list_data \n")
print(processed_list_data)

cat("processed_vector_data \n")
print(processed_vector_data)
