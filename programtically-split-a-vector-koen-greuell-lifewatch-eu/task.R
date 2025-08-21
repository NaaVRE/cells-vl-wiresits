setwd('/app')
library(optparse)
library(jsonlite)




print('option_list')
option_list = list(

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

id <- gsub('"', '', opt$id)


print("Running the cell")
raw_vector_data <- c("0001", "0010", "0011", "0100", "0101", "0110", "0111", "1000", "1001", "1010", "1011")

n_chunks <- 10

chunk_size <- ceiling(length(raw_vector_data) / n_chunks)

raw_vector_data <- split(raw_vector_data, ceiling(seq_along(raw_vector_data) / chunk_size))

print(raw_vector_data)
# capturing outputs
print('Serialization of raw_vector_data')
file <- file(paste0('/tmp/raw_vector_data_', id, '.json'))
writeLines(toJSON(raw_vector_data, auto_unbox=TRUE), file)
close(file)
