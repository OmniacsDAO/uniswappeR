#' Write out the data object given file name
#' @param data_to_export Object containing data we want to export
#' @param path_to_export Path of the CSV file, we want to export to
#' @return Status of the write
#'
#' @export
#' @importFrom utils write.csv
#'
#' @examples
#' data_to_export <- token_stats_hist_v2(token_address = "0x1f9840a85d5af5bf1d1762f925bdaddc4201f984")
#' path_to_export <- "~/Desktop/uniswappeR_export.csv"
#' export_data(data_to_export,path_to_export)
export_data <- function(data_to_export,path_to_export) 
{
    write.csv(data_to_export,path_to_export,row.names=FALSE)
    return("Data Export Complete")
}


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


#' Get Uniswap Historical Stats
#' @return Historical Data on the Uniswap Platform
#'
#' @export
#'
#' @importFrom jsonlite fromJSON
#' @import dplyr
#'
#' @examples
#'
#' uniswap_stats_hist_v2()
uniswap_stats_hist_v2 <- function() 
{
    qcon <- initialize_queries()
    con <- qcon[[1]]
    qry <- qcon[[2]]

    ## Loop historical
    c_timestamp <- as.integer(Sys.time())
    uni_data <- data.frame()
    while(TRUE)
    {
        uni_data_t <- fromJSON(con$exec(qry$queries$uni_stats_hist,list(timestamp=c_timestamp)))$data$uniswapDayDatas
        if(length(uni_data_t)==0) break()
        uni_data <- bind_rows(uni_data,uni_data_t)
        c_timestamp <- as.numeric(tail(uni_data_t$date,1))
        message(paste0("Fetched ",nrow(uni_data)," Entries"))
    }
    return(uni_data)
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


#' Get Token Historical Stats
#' @param token_address Token's Address
#' @return Historical Data on a particular Token
#'
#' @export
#'
#' @importFrom jsonlite fromJSON
#' @import dplyr
#'
#' @examples
#'
#' token_stats_hist_v2(token_address = "0x1f9840a85d5af5bf1d1762f925bdaddc4201f984")
token_stats_hist_v2 <- function(token_address = "0x1f9840a85d5af5bf1d1762f925bdaddc4201f984") 
{
    qcon <- initialize_queries()
    con <- qcon[[1]]
    qry <- qcon[[2]]

    ## Loop historical
    c_timestamp <- as.integer(Sys.time())
    token_data <- data.frame()
    while(TRUE)
    {
        token_data_t <- fromJSON(con$exec(qry$queries$token_stats_hist,list(tokenAdd = token_address,timestamp=c_timestamp)))$data$tokens$tokenDayData[[1]]
        if(length(token_data_t)==0) break()
        token_data <- bind_rows(token_data,token_data_t)
        c_timestamp <- as.numeric(tail(token_data_t$date,1))
        message(paste0("Fetched ",nrow(token_data)," Entries"))
    }
    return(token_data)
    
}


#' Get Token's associated pairs
#' @param token_address Token's Address
#' @return Sssociated Pairs of a particular Token
#'
#' @export
#'
#' @importFrom jsonlite fromJSON
#' @import dplyr
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
        message(paste0("Fetched ",nrow(base_data)," Base Entries"))
    }

    ## Token as Quote
    c_timestamp <- as.integer(Sys.time())
    quote_data <- data.frame()
    while(TRUE)
    {
        quote_data_t <- fromJSON(con$exec(qry$queries$token_pairQuote_map,list(tokenAdd = token_address,timestamp=c_timestamp)))$data$tokens$pairQuote[[1]]
        if(length(quote_data_t)==0) break()
        quote_data <- bind_rows(quote_data,quote_data_t)
        c_timestamp <- as.numeric(tail(quote_data_t$createdAtTimestamp,1))
        message(paste0("Fetched ",nrow(quote_data)," Quote Entries"))
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
#' pair_stats_v2(pair_address = "0xf00e80f0de9aea0b33aa229a4014572777e422ee")
pair_stats_v2 <- function(pair_address = "0xf00e80f0de9aea0b33aa229a4014572777e422ee") 
{
    qcon <- initialize_queries()
    con <- qcon[[1]]
    qry <- qcon[[2]]
    fromJSON(con$exec(qry$queries$pair_stats,list(pairAdd = pair_address)))$data$pairs
}


#' Get Hourly Pair Historical Stats
#' @param pair_address Pair's Address
#' @return Hourly Historical Data on a particular Pair
#'
#' @export
#'
#' @importFrom jsonlite fromJSON
#' @import dplyr
#'
#' @examples
#'
#' pair_stats_hist_hourly_v2(pair_address = "0xf00e80f0de9aea0b33aa229a4014572777e422ee")
pair_stats_hist_hourly_v2 <- function(pair_address = "0xf00e80f0de9aea0b33aa229a4014572777e422ee")
{
    qcon <- initialize_queries()
    con <- qcon[[1]]
    qry <- qcon[[2]]

    ## Loop historical
    c_timestamp <- as.integer(Sys.time())
    pair_data <- data.frame()
    while(TRUE)
    {
        pair_data_t <- fromJSON(con$exec(qry$queries$pair_stats_hist_hourly,list(pairAdd = pair_address,timestamp=c_timestamp)))$data$pairs$pairHourData[[1]]
        if(length(pair_data_t)==0) break()
        pair_data <- bind_rows(pair_data,pair_data_t)
        c_timestamp <- as.numeric(tail(pair_data_t$hourStartUnix,1))
        message(paste0("Fetched ",nrow(pair_data)," Entries"))
    }
    return(pair_data)
}


#' Get Daily Pair Historical Stats
#' @param pair_address Pair's Address
#' @return Daily Historical Data on a particular Pair
#'
#' @export
#'
#' @importFrom jsonlite fromJSON
#' @import dplyr
#'
#' @examples
#'
#' pair_stats_hist_daily_v2(pair_address = "0xf00e80f0de9aea0b33aa229a4014572777e422ee")
pair_stats_hist_daily_v2 <- function(pair_address = "0xf00e80f0de9aea0b33aa229a4014572777e422ee")
{
    qcon <- initialize_queries()
    con <- qcon[[1]]
    qry <- qcon[[2]]

    ## Loop historical
    c_timestamp <- as.integer(Sys.time())
    pair_data <- data.frame()
    while(TRUE)
    {
        pair_data_t <- fromJSON(con$exec(qry$queries$pair_stats_hist_daily,list(pairAdd = pair_address,timestamp=c_timestamp)))$data$pairDayDatas
        if(length(pair_data_t)==0) break()
        pair_data <- bind_rows(pair_data,pair_data_t)
        c_timestamp <- as.numeric(tail(pair_data_t$date,1))
        message(paste0("Fetched ",nrow(pair_data)," Entries"))
    }
    return(pair_data)
}

#' Get Current Liquidity Positions in a pair
#' @param pair_address Pair's Address
#' @return Current Liquidity Positions in a pair
#'
#' @export
#'
#' @importFrom jsonlite fromJSON
#' @import dplyr
#'
#' @examples
#'
#' pair_liq_positions_v2(pair_address = "0xf00e80f0de9aea0b33aa229a4014572777e422ee")
pair_liq_positions_v2 <- function(pair_address = "0xf00e80f0de9aea0b33aa229a4014572777e422ee")
{
    qcon <- initialize_queries()
    con <- qcon[[1]]
    qry <- qcon[[2]]

    ## Loop historical
    id_last = ""
    pair_data <- data.frame()
    while(TRUE)
    {
        pair_data_t <- fromJSON(con$exec(qry$queries$liq_positions,list(pairAdd = pair_address,idlast=id_last)))$data$pairs$liquidityPositions[[1]]
        if(length(pair_data_t)==0) break()
        pair_data <- bind_rows(pair_data,pair_data_t)
        id_last <- tail(pair_data_t$id,1)
        message(paste0("Fetched ",nrow(pair_data)," Entries"))
    }
    return(pair_data)
}

#' Get Historical Liquidity Positions in a pair
#' @param pair_address Pair's Address
#' @return Historical Liquidity Positions in a pair
#'
#' @export
#'
#' @importFrom jsonlite fromJSON
#' @import dplyr
#'
#' @examples
#'
#' pair_liq_positions_hist_v2(pair_address = "0xf00e80f0de9aea0b33aa229a4014572777e422ee")
pair_liq_positions_hist_v2 <- function(pair_address = "0xf00e80f0de9aea0b33aa229a4014572777e422ee")
{
    qcon <- initialize_queries()
    con <- qcon[[1]]
    qry <- qcon[[2]]

    ## Loop historical
    id_last = ""
    pair_data <- data.frame()
    while(TRUE)
    {
        pair_data_t <- fromJSON(con$exec(qry$queries$liq_positions_hist,list(pairAdd = pair_address,idlast=id_last)))$data$pairs$liquidityPositionSnapshots[[1]]
        if(length(pair_data_t)==0) break()
        pair_data <- bind_rows(pair_data,pair_data_t)
        id_last <- tail(pair_data_t$id,1)
        message(paste0("Fetched ",nrow(pair_data)," Entries"))
    }
    return(pair_data)
}


#' Get Mint Transactions in a pair
#' @param pair_address Pair's Address
#' @return Mint Transactions in a pair
#'
#' @export
#'
#' @importFrom jsonlite fromJSON
#' @import dplyr
#'
#' @examples
#'
#' pair_mint_txs_v2(pair_address = "0xf00e80f0de9aea0b33aa229a4014572777e422ee")
pair_mint_txs_v2 <- function(pair_address = "0xf00e80f0de9aea0b33aa229a4014572777e422ee")
{
    qcon <- initialize_queries()
    con <- qcon[[1]]
    qry <- qcon[[2]]

    ## Loop historical
    c_timestamp <- as.integer(Sys.time())
    pair_data <- data.frame()
    while(TRUE)
    {
        pair_data_t <- fromJSON(con$exec(qry$queries$mints_pair,list(pairAdd = pair_address,timestamp=c_timestamp)))$data$pairs$mints[[1]]
        if(length(pair_data_t)==0) break()
        pair_data <- bind_rows(pair_data,pair_data_t)
        c_timestamp <- as.numeric(tail(pair_data_t$timestamp,1))
        message(paste0("Fetched ",nrow(pair_data)," Entries"))
    }
    return(pair_data)
}


#' Get Burn Transactions in a pair
#' @param pair_address Pair's Address
#' @return Burn Transactions in a pair
#'
#' @export
#'
#' @importFrom jsonlite fromJSON
#' @import dplyr
#'
#' @examples
#'
#' pair_burn_txs_v2(pair_address = "0xf00e80f0de9aea0b33aa229a4014572777e422ee")
pair_burn_txs_v2 <- function(pair_address = "0xf00e80f0de9aea0b33aa229a4014572777e422ee")
{
    qcon <- initialize_queries()
    con <- qcon[[1]]
    qry <- qcon[[2]]

    ## Loop historical
    c_timestamp <- as.integer(Sys.time())
    pair_data <- data.frame()
    while(TRUE)
    {
        pair_data_t <- fromJSON(con$exec(qry$queries$burns_pair,list(pairAdd = pair_address,timestamp=c_timestamp)))$data$pairs$burns[[1]]
        if(length(pair_data_t)==0) break()
        pair_data <- bind_rows(pair_data,pair_data_t)
        c_timestamp <- as.numeric(tail(pair_data_t$timestamp,1))
        message(paste0("Fetched ",nrow(pair_data)," Entries"))
    }
    return(pair_data)
}


#' Get Swap Transactions in a pair
#' @param pair_address Pair's Address
#' @return Swap Transactions in a pair
#'
#' @export
#'
#' @importFrom jsonlite fromJSON
#' @import dplyr
#'
#' @examples
#'
#' pair_swap_txs_v2(pair_address = "0xf00e80f0de9aea0b33aa229a4014572777e422ee")
pair_swap_txs_v2 <- function(pair_address = "0xf00e80f0de9aea0b33aa229a4014572777e422ee")
{
    qcon <- initialize_queries()
    con <- qcon[[1]]
    qry <- qcon[[2]]

    ## Loop historical
    c_timestamp <- as.integer(Sys.time())
    pair_data <- data.frame()
    while(TRUE)
    {
        pair_data_t <- fromJSON(con$exec(qry$queries$swaps_pair,list(pairAdd = pair_address,timestamp=c_timestamp)))$data$pairs$swaps[[1]]
        if(length(pair_data_t)==0) break()
        pair_data <- bind_rows(pair_data,pair_data_t)
        c_timestamp <- as.numeric(tail(pair_data_t$timestamp,1))
        message(paste0("Fetched ",nrow(pair_data)," Entries"))
    }
    return(pair_data)
}


#' Get User Liquidity Positions
#' @param user_address User's Address
#' @return User Liquidity Positions
#'
#' @export
#'
#' @importFrom jsonlite fromJSON
#' @import dplyr
#'
#' @examples
#'
#' user_lps_v2(user_address = "0x2502f65d77ca13f183850b5f9272270454094a08")
user_lps_v2 <- function(user_address = "0x2502f65d77ca13f183850b5f9272270454094a08")
{
    qcon <- initialize_queries()
    con <- qcon[[1]]
    qry <- qcon[[2]]
    ## Loop historical
    id_last = ""
    lp_data <- data.frame()
    while(TRUE)
    {
        lp_data_t <- fromJSON(con$exec(qry$queries$lps_user,list(userAdd = user_address,idlast=id_last)))$data$liquidityPositions
        if(length(lp_data_t)==0) break()
        lp_data <- bind_rows(lp_data,lp_data_t)
        id_last <- tail(lp_data_t$id,1)
        message(paste0("Fetched ",nrow(lp_data)," Entries"))
    }
    return(lp_data)
}


#' Get Historical User Liquidity Positions
#' @param user_address User's Address
#' @return Historical User Liquidity Positions
#'
#' @export
#'
#' @importFrom jsonlite fromJSON
#' @import dplyr
#'
#' @examples
#'
#' user_hist_lps_v2(user_address = "0x2502f65d77ca13f183850b5f9272270454094a08")
user_hist_lps_v2 <- function(user_address = "0x2502f65d77ca13f183850b5f9272270454094a08")
{
    qcon <- initialize_queries()
    con <- qcon[[1]]
    qry <- qcon[[2]]
    ## Loop historical
    id_last = ""
    lp_data <- data.frame()
    while(TRUE)
    {
        lp_data_t <- fromJSON(con$exec(qry$queries$lps_hist_user,list(userAdd = user_address,idlast=id_last)))$data$liquidityPositionSnapshots
        if(length(lp_data_t)==0) break()
        lp_data <- bind_rows(lp_data,lp_data_t)
        id_last <- tail(lp_data_t$id,1)
        message(paste0("Fetched ",nrow(lp_data)," Entries"))
    }
    return(lp_data)
}


#' Get User Swap Txs
#' @param user_address User's Address
#' @return User Swap Txs
#'
#' @export
#'
#' @importFrom jsonlite fromJSON
#' @import dplyr
#'
#' @examples
#'
#' user_swaps_v2(user_address = "0xcd8aa390e6eabbd2169b3580c1f7ce854675fd03")
user_swaps_v2 <- function(user_address = "0xcd8aa390e6eabbd2169b3580c1f7ce854675fd03")
{
    qcon <- initialize_queries()
    con <- qcon[[1]]
    qry <- qcon[[2]]
    ## Loop historical
    id_last = ""
    tx_data <- data.frame()
    while(TRUE)
    {
        tx_data_t <- fromJSON(con$exec(qry$queries$swap_user,list(userAdd = user_address,idlast=id_last)))$data$swaps
        if(length(tx_data_t)==0) break()
        tx_data <- bind_rows(tx_data,tx_data_t)
        id_last <- tail(tx_data$id,1)
        message(paste0("Fetched ",nrow(tx_data)," Entries"))
    }
    return(tx_data)
}


#' Get User Mint Txs
#' @param user_address User's Address
#' @return User Mint Txs
#'
#' @export
#'
#' @importFrom jsonlite fromJSON
#' @import dplyr
#'
#' @examples
#'
#' user_mints_v2(user_address = "0xcd8aa390e6eabbd2169b3580c1f7ce854675fd03")
user_mints_v2 <- function(user_address = "0xcd8aa390e6eabbd2169b3580c1f7ce854675fd03")
{
    qcon <- initialize_queries()
    con <- qcon[[1]]
    qry <- qcon[[2]]
    ## Loop historical
    id_last = ""
    tx_data <- data.frame()
    while(TRUE)
    {
        tx_data_t <- fromJSON(con$exec(qry$queries$mint_user,list(userAdd = user_address,idlast=id_last)))$data$mints
        if(length(tx_data_t)==0) break()
        tx_data <- bind_rows(tx_data,tx_data_t)
        id_last <- tail(tx_data$id,1)
        message(paste0("Fetched ",nrow(tx_data)," Entries"))
    }
    return(tx_data)
}


#' Get User Burn Txs
#' @param user_address User's Address
#' @return User Burn Txs
#'
#' @export
#'
#' @importFrom jsonlite fromJSON
#' @import dplyr
#'
#' @examples
#'
#' user_burns_v2(user_address = "0xcd8aa390e6eabbd2169b3580c1f7ce854675fd03")
user_burns_v2 <- function(user_address = "0xcd8aa390e6eabbd2169b3580c1f7ce854675fd03")
{
    qcon <- initialize_queries()
    con <- qcon[[1]]
    qry <- qcon[[2]]
    ## Loop historical
    id_last = ""
    tx_data <- data.frame()
    while(TRUE)
    {
        tx_data_t <- fromJSON(con$exec(qry$queries$burn_user,list(userAdd = user_address,idlast=id_last)))$data$burns
        if(length(tx_data_t)==0) break()
        tx_data <- bind_rows(tx_data,tx_data_t)
        id_last <- tail(tx_data$id,1)
        message(paste0("Fetched ",nrow(tx_data)," Entries"))
    }
    return(tx_data)
}


