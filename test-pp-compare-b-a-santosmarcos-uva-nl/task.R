setwd('/app')
library(optparse)
library(jsonlite)

if (!requireNamespace("terra", quietly = TRUE)) {
	install.packages("terra", repos="http://cran.us.r-project.org")
}
library(terra)



print('option_list')
option_list = list(

make_option(c("--tstart_par"), action="store", default=NA, type="numeric", help="my description"),
make_option(c("--tstart_seq"), action="store", default=NA, type="numeric", help="my description"),
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

print("Retrieving tstart_par")
var = opt$tstart_par
print(var)
var_len = length(var)
print(paste("Variable tstart_par has length", var_len))

tstart_par = opt$tstart_par
print("Retrieving tstart_seq")
var = opt$tstart_seq
print(var)
var_len = length(var)
print(paste("Variable tstart_seq has length", var_len))

tstart_seq = opt$tstart_seq
id <- gsub('"', '', opt$id)


print("Running the cell")
tend <- proc.time()

tdiff <- data.frame(
  tseq = (tend - tstart_seq),
  tpar = (tend - tstart_par)
)

write.csv(tdiff, file = "./test_preproc_parallel.csv", row.names = TRUE)
