#' Get Uniswap Factory Stats
#' @return Data on the Uniswap Factory contract
#'
#' @export
#'
#' @importFrom jsonlite fromJSON
#'
#' @examples
#'
#' factory_stats()
factory_stats <- function() 
{
    qcon <- initialize_queries()
    con <- qcon[[1]]
    qry <- qcon[[2]]
    fromJSON(con$exec(qry$queries$factory_stats))$data$uniswapFactories
}