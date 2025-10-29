setwd('/app')
library(optparse)
library(jsonlite)

if (!requireNamespace("terra", quietly = TRUE)) {
	install.packages("terra", repos="http://cran.us.r-project.org")
}
library(terra)



print('option_list')
option_list = list(

make_option(c("--paths_data"), action="store", default=NA, type="character", help="my description"),
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

print("Retrieving paths_data")
var = opt$paths_data
print(var)
var_len = length(var)
print(paste("Variable paths_data has length", var_len))

paths_data <- gsub("\"", "", opt$paths_data)
id <- gsub('"', '', opt$id)


print("Running the cell")
tstart_seq <- proc.time()

library(terra)
source(file = "../R/hampel.R")
source(file = "../R/whithen.R")

for (i in length(paths_data)) {

  bi <- rast(path_data[i])

  bi_f <- approximate(bi)

  bi_fh <- app(x = bi_f, fun = hampel, cores = 1)

  bi_fhw <- app(x = bi_fh, fun = whithen, cores = 1)
}
# capturing outputs
print('Serialization of tstart_seq')
file <- file(paste0('/tmp/tstart_seq_', id, '.json'))
writeLines(toJSON(tstart_seq, auto_unbox=TRUE), file)
close(file)
