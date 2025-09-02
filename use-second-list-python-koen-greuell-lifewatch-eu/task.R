setwd('/app')
library(optparse)
library(jsonlite)




print('option_list')
option_list = list(

make_option(c("--list1"), action="store", default=NA, type="character", help="my description"),
make_option(c("--list2"), action="store", default=NA, type="character", help="my description"),
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

print("Retrieving list1")
var = opt$list1
print(var)
var_len = length(var)
print(paste("Variable list1 has length", var_len))

list1 <- gsub("\"", "", opt$list1)
print("Retrieving list2")
var = opt$list2
print(var)
var_len = length(var)
print(paste("Variable list2 has length", var_len))

list2 <- gsub("\"", "", opt$list2)
id <- gsub('"', '', opt$id)


print("Running the cell")
print(list1)
print(list2)
