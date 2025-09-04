setwd('/app')
library(optparse)
library(jsonlite)

if (!requireNamespace("purrr", quietly = TRUE)) {
	install.packages("purrr", repos="http://cran.us.r-project.org")
}
library(purrr)



print('option_list')
option_list = list(

make_option(c("--dummy_n2"), action="store", default=NA, type="character", help="my description"),
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

print("Retrieving dummy_n2")
var = opt$dummy_n2
print(var)
var_len = length(var)
print(paste("Variable dummy_n2 has length", var_len))

print("------------------------Running var_serialization for dummy_n2-----------------------")
print(opt$dummy_n2)
dummy_n2 = var_serialization(opt$dummy_n2)
print("---------------------------------------------------------------------------------")

id <- gsub('"', '', opt$id)


print("Running the cell")
print_content <- function(string_) {
  print(string_)
}

purrr::map(dummy_n2, print_content)
