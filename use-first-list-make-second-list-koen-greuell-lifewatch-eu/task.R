setwd('/app')
library(optparse)
library(jsonlite)




print('option_list')
option_list = list(

make_option(c("--first_list"), action="store", default=NA, type="character", help="my description"),
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

print("Retrieving first_list")
var = opt$first_list
print(var)
var_len = length(var)
print(paste("Variable first_list has length", var_len))

print("------------------------Running var_serialization for first_list-----------------------")
print(opt$first_list)
first_list = var_serialization(opt$first_list)
print("---------------------------------------------------------------------------------")

id <- gsub('"', '', opt$id)


print("Running the cell")
print(first_list)
second_list <- list(4,5,6)
# capturing outputs
print('Serialization of second_list')
file <- file(paste0('/tmp/second_list_', id, '.json'))
writeLines(toJSON(second_list, auto_unbox=TRUE), file)
close(file)
