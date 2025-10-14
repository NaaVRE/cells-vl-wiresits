setwd('/app')
library(optparse)
library(jsonlite)

if (!requireNamespace("terra", quietly = TRUE)) {
	install.packages("terra", repos="http://cran.us.r-project.org")
}
library(terra)



print('option_list')
option_list = list(

make_option(c("--conf_path_tctg"), action="store", default=NA, type="character", help="my description"),
make_option(c("--conf_path_tctg_h"), action="store", default=NA, type="character", help="my description"),
make_option(c("--conf_path_tctg_s"), action="store", default=NA, type="character", help="my description"),
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

print("Retrieving conf_path_tctg")
var = opt$conf_path_tctg
print(var)
var_len = length(var)
print(paste("Variable conf_path_tctg has length", var_len))

conf_path_tctg <- gsub("\"", "", opt$conf_path_tctg)
print("Retrieving conf_path_tctg_h")
var = opt$conf_path_tctg_h
print(var)
var_len = length(var)
print(paste("Variable conf_path_tctg_h has length", var_len))

conf_path_tctg_h <- gsub("\"", "", opt$conf_path_tctg_h)
print("Retrieving conf_path_tctg_s")
var = opt$conf_path_tctg_s
print(var)
var_len = length(var)
print(paste("Variable conf_path_tctg_s has length", var_len))

conf_path_tctg_s <- gsub("\"", "", opt$conf_path_tctg_s)
id <- gsub('"', '', opt$id)

conf_path_tctg_h<-paste0
conf_path_tctg<-paste0
conf_path_tctg_s<-paste0

print("Running the cell")
library(terra)

tctg <- rast(conf_path_tctg)
tctg_h <- rast(conf_path_tctg_h)
tctg_s <- rast(conf_path_tctg_s)

extract2 <- function(x, y, method = "simple", ID = FALSE) {
  unlist(as.vector(terra::extract(x, y, method = method, ID = ID)))
}
pts <- roi |> vect() |> centroids() |> project(crs(b2))
tctg_pts <- extract2(tctg, pts)
tctg_h_pts <- extract2(tctg_h, pts)
tctg_s_pts <- extract2(tctg_s, pts)

options(repr.plot.width = 24, repr.plot.height = 8, repr.plot.res = 120, repr.plot.pointsize = 12)
plot(
    tctg_pts, col = "red", type = "l", las = 1,
    main = "Example time-series", xlab = "time index", ylab = "TCTG"
)
abline(h = 0, col = "lightgrey", lty = 3)
abline(v = 46 * c(0:21), col = "lightgrey", lty = 2)
lines(tctg_h_pts, col = "black", lwd = 2)
lines(tctg_s_pts, col = "blue", lwd = 4)
