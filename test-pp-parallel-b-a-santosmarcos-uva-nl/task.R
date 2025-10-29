setwd('/app')
library(optparse)
library(jsonlite)

if (!requireNamespace("terra", quietly = TRUE)) {
	install.packages("terra", repos="http://cran.us.r-project.org")
}
library(terra)



print('option_list')
option_list = list(

make_option(c("--path_data"), action="store", default=NA, type="character", help="my description"),
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

print("Retrieving path_data")
var = opt$path_data
print(var)
var_len = length(var)
print(paste("Variable path_data has length", var_len))

path_data <- gsub("\"", "", opt$path_data)
id <- gsub('"', '', opt$id)


print("Running the cell")
tstart <- proc.time()




library(terra)
source(file = "../R/hampel.R")
source(file = "../R/whithen.R")




for (i in 1:7) {

  bi <- rast(paste0(path_data, "/b", i, "_d.tif"))

  bi_f <- approximate(bi)

  bi_fh <- app(x = bi_f, fun = hampel, cores = 3)

  bi_fhw <- app(x = bi_fh, fun = whithen, cores = 3)
}



ttime_par <- as.vector(proc.time() - tstart)
print(ttime_par)
# capturing outputs
print('Serialization of ttime_par')
file <- file(paste0('/tmp/ttime_par_', id, '.json'))
writeLines(toJSON(ttime_par, auto_unbox=TRUE), file)
close(file)
