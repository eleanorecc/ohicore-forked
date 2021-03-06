#' Conf reference class.
#' 
#' @param dir path to directory containing necessary files, e.g., eez2015/conf  
#' @return object reference class of Config containing:
#' \itemize{
#'   \item{\emph{config}}
#'   \item{\emph{functions}}
#'   \item{\emph{goals}}
#'   \item{\emph{pressures_matrix}}
#'   \item{\emph{resilience_matrix}}
#'   \item{\emph{resilience_categories}}
#'   \item{\emph{pressure_categories}}
#' }
#' @details This function creates an R object that combines into a single object all the information 
#' from the following files: config.R, functions.R, goals.csv, pressures_matrix.csv, resilience_matrix.csv, resilience_weights.csv.
#' To create this object, \code{Conf(dir)}. The \code{dir} is expected to have the following files:
#' \itemize{
#'   \item{\emph{config.R}}
#'   \item{\emph{functions.R}}
#'   \item{\emph{goals.csv}}
#'   \item{\emph{pressures_matrix.csv}}
#'   \item{\emph{resilience_matrix.csv}}
#'   \item{\emph{resilience_weights.csv}}
#'   \item{\emph{pressure_categories}}
#' }
#' See also \code{\link{Conf_write}()} to write the configuration back to disk.
#' @export Conf
#' @exportClass Conf

Conf = methods::setRefClass(
  'Conf', fields = list(
    config_txt = 'character',
    functions_txt = 'character',
    config = 'environment',
    functions = 'environment',
    goals = 'data.frame',
    pressures_matrix = 'data.frame',
    resilience_matrix = 'data.frame',
    resilience_categories = 'data.frame',
    pressure_categories = 'data.frame',
    scenario_data_years = 'data.frame'
    ),
  methods = list(
    initialize = function(dir) {      
          
      # check for files in dir
      for (f in c('config.R', 'functions.R','goals.csv','pressures_matrix.csv','resilience_matrix.csv','resilience_categories.csv', 'pressure_categories.csv')){
        if (!file.exists(file.path(dir, f))) { stop(sprintf('Required Conf file not found: %s', file.path(dir, f))) }
      }
      
      # read R files: config, functions
      .self$config_txt    = suppressWarnings(readLines(file.path(dir, 'config.R'   )))
      .self$functions_txt = suppressWarnings(readLines(file.path(dir, 'functions.R')))    
      .self$config    = new.env(); source(file.path(dir, 'config.R'   ), local=.self$config)
      .self$functions = new.env(); source(file.path(dir, 'functions.R'), local=.self$functions)      
      
      # set  data.frames: pressures_matrix, resilience_matrix, resilience_weights
      .self$goals              = read.csv(file.path(dir, 'goals.csv'             ), na.strings='', stringsAsFactors=F)
      .self$pressures_matrix   = read.csv(file.path(dir, 'pressures_matrix.csv'  ), na.strings='', stringsAsFactors=F)
      .self$resilience_matrix  = read.csv(file.path(dir, 'resilience_matrix.csv' ), na.strings='', stringsAsFactors=F)
      .self$resilience_categories = read.csv(file.path(dir, 'resilience_categories.csv'), na.strings='', stringsAsFactors=F)
      .self$pressure_categories = read.csv(file.path(dir, 'pressure_categories.csv'), na.strings='', stringsAsFactors=F)
      if(file.exists(file.path(dir, "scenario_data_years.csv"))){
        .self$scenario_data_years = read.csv(file.path(dir, 'scenario_data_years.csv'), na.strings='', stringsAsFactors=F)
      }
      
     },
    write = function(dir){
      if (!file.exists(dir)) dir.create(dir)
      
      # write R files
      writeLines(.self$config_txt   , file.path(dir, 'config.R'   ))
      writeLines(.self$functions_txt, file.path(dir, 'functions.R'   ))      
      
      # dump data.frames
      write.csv(.self$goals             , file.path(dir, 'goals.csv'             ), row.names=F, na='')
      write.csv(.self$pressures_matrix  , file.path(dir, 'pressures_matrix.csv'  ), row.names=F, na='')
      write.csv(.self$resilience_matrix , file.path(dir, 'resilience_matrix.csv' ), row.names=F, na='')
      write.csv(.self$resilience_categories, file.path(dir, 'resilience_categories.csv'), row.names=F, na='') 
      write.csv(.self$pressure_categories, file.path(dir, 'pressure_categories.csv'), row.names=F, na='') 
      if(file.exists(file.path(dir, "scenario_data_year.csv"))){
        write.csv(.self$scenario_data_years, file.path(dir, 'scenario_data_years.csv'), row.names=F, na='')
      }
      
          },
    show = function () {
      cat('config:\n')
      print(ls(.self$config))
      cat('functions:\n')
      print(ls(.self$functions))
      cat('goals:\n')
      print(summary(.self$goals))
      cat('pressures_matrix:\n')
      print(summary(.self$pressures_matrix))
      cat('resilience_matrix:\n')
      print(summary(.self$resilience_matrix))
      cat('resilience_categories:\n')
      print(summary(.self$resilience_categories))
      cat('pressure_categories:\n')
      print(summary(.self$pressure_categories))
      if(file.exists(file.path(dir, "scenario_data_years.csv"))){
        print(summary(.self$scenario_data_years))
      }
    })
)

#' @title Write the Conf to disk
#' @param dir path to directory where the Conf files should be output
#' @name Conf_write
#' @details Use this function to write the configuration to disk, like so \code{conf$write(dir)}. This is useful for modifying and then reloading with \code{\link{Conf}(dir)}.
NULL

