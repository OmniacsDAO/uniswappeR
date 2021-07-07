#' Gets the Infura Node
#'
#' @return Your Infura Node, if set
#' @export
#' @examples
#' \dontrun{
#' get_infura_node()
#' }
get_infura_node <- function() {
  env <- Sys.getenv("INFURA_NODE")
  if (!identical(env, "")) return(env)

  if (!interactive()) {
    stop("Please set the environment variable INFURA_NODE to your Infura Node", call. = FALSE)
  }

  message("Please enter your INFURA NODE and press enter:")

  infura_node <- readline(": ")

  if (identical(infura_node, "")) {
    stop("Invalid INFURA NODE", call. = FALSE)
  }

  message("Updating INFURA_NODE environment variable.")
  Sys.setenv(INFURA_NODE = infura_node)

  return(infura_node)
}

#' Sets the Infura Node
#'
#' @name set_infura_node
#' @param pass The Infura Node
#' @return A boolean TRUE if the INFURA NODE was successfully set
#' @export
#' @examples
#' \dontrun{
#' set_infura_node("https://mainnet.infura.io/v3/XXXXXXXXXXXXXXXXXXX")
#' }
set_infura_node <- function(infura_node) {
  if (identical(infura_node, "")) {
    stop("Invalid Password", call. = FALSE)
  }

  Sys.setenv(INFURA_NODE = infura_node)

  return(TRUE)
}

#################################################################
## Helper Functions
#################################################################
#' Python builtin functions
#' @import reticulate
py_int <- function() return(import_builtins(convert = FALSE)$int)

#' python object to R
#' @param val Numeric converter to export
r_num <- function(val) as.numeric(as.character(val))


#' Start the python session
#'
#' @param node The Infura Node
#' @param pvt_key Private Key of the user Address
#'
#' @return The python session uniswap endpoint
#'
#' @export
#'
#' @import reticulate
#' @import jsonlite
uniswap_session <- function(node = get_infura_node(),user_add=NULL,pvt_key=NULL){
    ## Select which python to use
    # use_python("/usr/bin/python3")

    ## Set infura Node as 
    py_run_string(paste0('import os;os.environ["PROVIDER"] = "',node,'"'))

    ## Initialise uniswap endpooint
    uniswap <- import("uniswap",convert=FALSE)
    uniswap$Uniswap(user_add,pvt_key, version=2)
}














