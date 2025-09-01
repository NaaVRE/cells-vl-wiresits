setwd('/app')
library(optparse)
library(jsonlite)

if (!requireNamespace("cli", quietly = TRUE)) {
	install.packages("cli", repos="http://cran.us.r-project.org")
}
library(cli)



print('option_list')
option_list = list(

make_option(c("--single_integer"), action="store", default=NA, type="integer", help="my description"),
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

print("Retrieving single_integer")
var = opt$single_integer
print(var)
var_len = length(var)
print(paste("Variable single_integer has length", var_len))

single_integer = opt$single_integer
id <- gsub('"', '', opt$id)


print("Running the cell")
int_to_process <- 0
int_to_process <- single_integer
# capturing outputs
print('Serialization of int_to_process')
file <- file(paste0('/tmp/int_to_process_', id, '.json'))
writeLines(toJSON(int_to_process, auto_unbox=TRUE), file)
close(file)
