#' Get Uniswap Factory Stats
#' @return Data on the Uniswap Factory contract
#'
#' @export
#'
#' @importFrom jsonlite fromJSON
#'
#' @examples
#'
#' factory_stats_v2()
factory_stats_v2 <- function() 
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
#' token_stats_v2(token_address = "0x1f9840a85d5af5bf1d1762f925bdaddc4201f984")
token_stats_v2 <- function(token_address = "0x1f9840a85d5af5bf1d1762f925bdaddc4201f984") 
{
    qcon <- initialize_queries()
    con <- qcon[[1]]
    qry <- qcon[[2]]
    fromJSON(con$exec(qry$queries$token_stats,list(tokenAdd = token_address)))$data$tokens
}


#' Get Token Historical Stats (Max 1000 Entries)
#' @param token_address Token's Address
#' @return Historical Data on a particular Token
#'
#' @export
#'
#' @importFrom jsonlite fromJSON
#'
#' @examples
#'
#' token_stats_hist_v2(token_address = "0x1f9840a85d5af5bf1d1762f925bdaddc4201f984")
token_stats_hist_v2 <- function(token_address = "0x1f9840a85d5af5bf1d1762f925bdaddc4201f984") 
{
    qcon <- initialize_queries()
    con <- qcon[[1]]
    qry <- qcon[[2]]
    fromJSON(con$exec(qry$queries$token_stats_hist,list(tokenAdd = token_address)))$data$tokens$tokenDayData[[1]]
}


#' Get Token's associated pairs
#' @param token_address Token's Address
#' @return Sssociated Pairs of a particular Token
#'
#' @export
#'
#' @importFrom jsonlite fromJSON
#'
#' @examples
#'
#' token_pair_map_v2(token_address = "0x1f9840a85d5af5bf1d1762f925bdaddc4201f984")
token_pair_map_v2 <- function(token_address = "0x1f9840a85d5af5bf1d1762f925bdaddc4201f984") 
{
    qcon <- initialize_queries()
    con <- qcon[[1]]
    qry <- qcon[[2]]
    
    ## Token as Base
    c_timestamp <- as.integer(Sys.time())
    base_data <- data.frame()
    while(TRUE)
    {
        base_data_t <- fromJSON(con$exec(qry$queries$token_pairBase_map,list(tokenAdd = token_address,timestamp=c_timestamp)))$data$tokens$pairBase[[1]]
        if(length(base_data_t)==0) break()
        base_data <- bind_rows(base_data,base_data_t)
        c_timestamp <- as.numeric(tail(base_data_t$createdAtTimestamp,1))
        message(paste0("Fetched ",nrow(base_data)," Base Entries\n"))
    }

    ## Token as Quote
    c_timestamp <- as.integer(Sys.time())
    quote_data <- data.frame()
    while(TRUE)
    {
        quote_data_t <- fromJSON(con$exec(qry$queries$token_pairBase_map,list(tokenAdd = token_address,timestamp=c_timestamp)))$data$tokens$pairBase[[1]]
        if(length(quote_data_t)==0) break()
        quote_data <- bind_rows(base_data,quote_data_t)
        c_timestamp <- as.numeric(tail(quote_data_t$createdAtTimestamp,1))
        message(paste0("Fetched ",nrow(quote_data)," Quote Entries\n"))
    }

    ## Return
    return(bind_rows(base_data,quote_data))
}


#' Get Pair Stats
#' @param pair_address Pair's Address
#' @return Data on a particular Pair
#'
#' @export
#'
#' @importFrom jsonlite fromJSON
#'
#' @examples
#'
#' pair_stats_v2(pair_address = "0xd3d2e2692501a5c9ca623199d38826e513033a17")
pair_stats_v2 <- function(pair_address = "0xd3d2e2692501a5c9ca623199d38826e513033a17") 
{
    qcon <- initialize_queries()
    con <- qcon[[1]]
    qry <- qcon[[2]]
    fromJSON(con$exec(qry$queries$pair_stats,list(pairAdd = pair_address)))$data$pairs
}