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

#' Get Token Stats
#' @param token_address Token's Address
#' @return Data on a particular Token
#'
#' @export
#'
#' @importFrom jsonlite fromJSON
#'
#' @examples
#'
#' token_stats(token_address = "0x1f9840a85d5af5bf1d1762f925bdaddc4201f984")
token_stats <- function(token_address = "0x1f9840a85d5af5bf1d1762f925bdaddc4201f984") 
{
    qcon <- initialize_queries()
    con <- qcon[[1]]
    qry <- qcon[[2]]
    fromJSON(con$exec(qry$queries$token_stats,list(tokenAdd = token_address)))$data$tokens
}

#' Get Pair Stats
#' @import jsonlite
#' @param pair_address Pair's Address
#' @return Data on a particular Pair
#'
#' @export
#'
#' @importFrom jsonlite fromJSON
#'
#' @examples
#'
#' pair_stats(pair_address = "0xd3d2e2692501a5c9ca623199d38826e513033a17")
pair_stats <- function(pair_address = "0xd3d2e2692501a5c9ca623199d38826e513033a17") 
{
    qcon <- initialize_queries()
    con <- qcon[[1]]
    qry <- qcon[[2]]
    flatten(fromJSON(con$exec(qry$queries$pair_stats,list(pairAdd = pair_address)))$data$pairs)
}