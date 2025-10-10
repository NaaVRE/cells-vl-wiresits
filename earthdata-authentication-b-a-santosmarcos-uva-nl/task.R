setwd('/app')
library(optparse)
library(jsonlite)

if (!requireNamespace("SecretsProvider", quietly = TRUE)) {
	install.packages("SecretsProvider", repos="http://cran.us.r-project.org")
}
library(SecretsProvider)


secret_pw = Sys.getenv('secret_pw')
secret_un = Sys.getenv('secret_un')

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
library(SecretsProvider)
secretsProvider <- SecretsProvider()
secret_un <- secretsProvider$get_secret("earthdata_username")
secret_pw <- secretsProvider$get_secret("earthdata_password")
# capturing outputs
print('Serialization of secret_pw')
file <- file(paste0('/tmp/secret_pw_', id, '.json'))
writeLines(toJSON(secret_pw, auto_unbox=TRUE), file)
close(file)
print('Serialization of secret_un')
file <- file(paste0('/tmp/secret_un_', id, '.json'))
writeLines(toJSON(secret_un, auto_unbox=TRUE), file)
close(file)
