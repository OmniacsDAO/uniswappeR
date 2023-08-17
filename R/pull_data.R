#' Write out the data object given file name
#' @param data_to_export Object containing data we want to export
#' @param path_to_export Path of the CSV file, we want to export to
#' @return Character vector indicating status of the write
#'
#' @export
#' @importFrom utils write.csv
#'
#' @examples
#' \dontrun{
#' data_to_export <- token_stats_hist_v2(token_address = "0x1f9840a85d5af5bf1d1762f925bdaddc4201f984")
#' path_to_export <- "~/Desktop/uniswappeR_export.csv"
#' export_data(data_to_export,path_to_export)
#' }
export_data <- function(data_to_export,path_to_export)
{
    write.csv(data_to_export,path_to_export,row.names=FALSE)
    return("Data Export Complete")
}


#' Get UniswapV2 Factory Stats
#' @return List representing data on the UniswapV2 Factory contract
#'
#' @export
#'
#' @importFrom jsonlite fromJSON
#'
#' @examples
#' \dontrun{
#' factory_stats_v2()
#' }
factory_stats_v2 <- function()
{
    qcon <- initialize_queries()
    con <- qcon[[1]]
    qry <- qcon[[2]]
    fromJSON(con$exec(qry$queries$factory_stats))$data$uniswapFactories
}


#' Get UniswapV3 Factory Stats
#' @return List representing data on the UniswapV3 Factory contract
#'
#' @export
#'
#' @importFrom jsonlite fromJSON
#'
#' @examples
#' \dontrun{
#' factory_stats_v3()
#' }
factory_stats_v3 <- function()
{
    qcon <- initialize_queries_v3()
    con <- qcon[[1]]
    qry <- qcon[[2]]
    fromJSON(con$exec(qry$queries$factory_stats))$data$factories
}


#' Get UniswapV2 Historical Stats
#' @return data frame representing historical Data on the Uniswap Platform
#'
#' @export
#'
#' @importFrom jsonlite fromJSON
#' @importFrom utils tail
#' @import dplyr
#'
#' @examples
#' \dontrun{
#' uniswap_stats_hist_v2()
#' }
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


#' Get UniswapV3 Historical Stats
#' @return data frame representing historical Data on the Uniswap Platform
#'
#' @export
#'
#' @importFrom jsonlite fromJSON
#' @importFrom utils tail
#' @import dplyr
#'
#' @examples
#' \dontrun{
#' uniswap_stats_hist_v3()
#' }
uniswap_stats_hist_v3 <- function()
{
    qcon <- initialize_queries_v3()
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


#' Get UniswapV2 Token Stats
#' @param token_address Token's Address
#' @return List representing data on a particular Token
#'
#' @export
#'
#' @importFrom jsonlite fromJSON
#'
#' @examples
#' \dontrun{
#' token_stats_v2(token_address = "0x1f9840a85d5af5bf1d1762f925bdaddc4201f984")
#' }
token_stats_v2 <- function(token_address = "0x1f9840a85d5af5bf1d1762f925bdaddc4201f984")
{
    token_address <- tolower(token_address)
    qcon <- initialize_queries()
    con <- qcon[[1]]
    qry <- qcon[[2]]
    fromJSON(con$exec(qry$queries$token_stats,list(tokenAdd = token_address)))$data$tokens
}


#' Get UniswapV3 Token Stats
#' @param token_address Token's Address
#' @return List representing data on a particular Token
#'
#' @export
#'
#' @importFrom jsonlite fromJSON
#'
#' @examples
#' \dontrun{
#' token_stats_v3(token_address = "0x1f9840a85d5af5bf1d1762f925bdaddc4201f984")
#' }
token_stats_v3 <- function(token_address = "0x1f9840a85d5af5bf1d1762f925bdaddc4201f984")
{
    token_address <- tolower(token_address)
    qcon <- initialize_queries_v3()
    con <- qcon[[1]]
    qry <- qcon[[2]]
    fromJSON(con$exec(qry$queries$token_stats,list(tokenAdd = token_address)))$data$tokens
}


#' Get UniswapV2 Token Historical Stats
#' @param token_address Token's Address
#' @return Data frame representing historical Data on a particular Token
#'
#' @export
#'
#' @importFrom jsonlite fromJSON
#' @importFrom utils tail
#' @import dplyr
#'
#' @examples
#' \dontrun{
#' token_stats_hist_v2(token_address = "0x1f9840a85d5af5bf1d1762f925bdaddc4201f984")
#' }
token_stats_hist_v2 <- function(token_address = "0x1f9840a85d5af5bf1d1762f925bdaddc4201f984")
{
    token_address <- tolower(token_address)
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


#' Get UniswapV3 Token Historical Stats
#' @param token_address Token's Address
#' @return Data frame representing historical Data on a particular Token
#'
#' @export
#'
#' @importFrom jsonlite fromJSON
#' @importFrom utils tail
#' @import dplyr
#'
#' @examples
#' \dontrun{
#' token_stats_hist_v3(token_address = "0x1f9840a85d5af5bf1d1762f925bdaddc4201f984")
#' }
token_stats_hist_v3 <- function(token_address = "0x1f9840a85d5af5bf1d1762f925bdaddc4201f984")
{
    token_address <- tolower(token_address)
    qcon <- initialize_queries_v3()
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


#' Get UniswapV2 Token's associated pairs
#' @param token_address Token's Address
#' @return Data frame representing associated Pairs of a particular Token
#'
#' @export
#'
#' @importFrom jsonlite fromJSON
#' @importFrom utils tail
#' @import dplyr
#'
#' @examples
#' \dontrun{
#' token_pair_map_v2(token_address = "0x1f9840a85d5af5bf1d1762f925bdaddc4201f984")
#' }
token_pair_map_v2 <- function(token_address = "0x1f9840a85d5af5bf1d1762f925bdaddc4201f984")
{
    token_address <- tolower(token_address)
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


#' Get UniswapV3 Token's associated pairs
#' @param token_address Token's Address
#' @return Data frame representing associated Pairs of a particular Token
#'
#' @export
#'
#' @importFrom jsonlite fromJSON
#' @import dplyr
#'
#' @examples
#' \dontrun{
#' token_pair_map_v3(token_address = "0x1f9840a85d5af5bf1d1762f925bdaddc4201f984")
#' }
token_pair_map_v3 <- function(token_address = "0x1f9840a85d5af5bf1d1762f925bdaddc4201f984")
{
    token_address <- tolower(token_address)
    qcon <- initialize_queries_v3()
    con <- qcon[[1]]
    qry <- qcon[[2]]

    ## Token as Base
    c_timestamp <- as.integer(Sys.time())
    base_data <- data.frame()
    while(TRUE)
    {
        base_data_t <- fromJSON(con$exec(qry$queries$token_pairBase_map,list(tokenAdd = token_address,timestamp=c_timestamp)))$data$pools
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
        quote_data_t <- fromJSON(con$exec(qry$queries$token_pairQuote_map,list(tokenAdd = token_address,timestamp=c_timestamp)))$data$pools
        if(length(quote_data_t)==0) break()
        quote_data <- bind_rows(quote_data,quote_data_t)
        c_timestamp <- as.numeric(tail(quote_data_t$createdAtTimestamp,1))
        message(paste0("Fetched ",nrow(quote_data)," Quote Entries"))
    }

    ## Return
    return(bind_rows(base_data,quote_data))
}


#' Get UniswapV2 All Pairs
#' @return Data frame representing All Pair Data
#'
#' @export
#'
#' @importFrom jsonlite fromJSON
#' @import dplyr
#'
#' @examples
#' \dontrun{
#' pairs_all_v2()
#' }
pairs_all_v2 <- function()
{
    qcon <- initialize_queries()
    con <- qcon[[1]]
    qry <- qcon[[2]]
    ## Loop historical
    c_timestamp <- as.integer(Sys.time())
    pair_data <- data.frame()
    while(TRUE)
    {
        pair_data_tt <- fromJSON(con$exec(qry$queries$all_pairs,list(timestamp=c_timestamp)))
        if(!is.null(pair_data_tt$errors)) next()
        pair_data_t <- pair_data_tt$data$pairs
        if(length(pair_data_t)==0) break()
        pair_data <- bind_rows(pair_data,pair_data_t)
        c_timestamp <- as.numeric(tail(pair_data_t$createdAtTimestamp,1))
        message(paste0("Fetched ",nrow(pair_data)," Entries"))
        #Sys.sleep(0)
    }
    return(pair_data)
}


#' Get UniswapV3 All Pairs
#' @return Data frame representing All Pair Data
#'
#' @export
#'
#' @importFrom jsonlite fromJSON
#' @import dplyr
#'
#' @examples
#' \dontrun{
#' pairs_all_v3()
#' }
pairs_all_v3 <- function()
{
    qcon <- initialize_queries_v3()
    con <- qcon[[1]]
    qry <- qcon[[2]]
    ## Loop historical
    c_timestamp <- as.integer(Sys.time())
    pair_data <- data.frame()
    while(TRUE)
    {
        pair_data_t <- fromJSON(con$exec(qry$queries$all_pairs,list(timestamp=c_timestamp)))$data$pools
        if(length(pair_data_t)==0) break()
        pair_data <- bind_rows(pair_data,pair_data_t)
        c_timestamp <- as.numeric(tail(pair_data_t$createdAtTimestamp,1))
        message(paste0("Fetched ",nrow(pair_data)," Entries"))
    }
    return(pair_data)
}


#' Get UniswapV2 Pair Stats
#' @param pair_address Pair's Address
#' @return List data on a particular Pair
#'
#' @export
#'
#' @importFrom jsonlite fromJSON
#'
#' @examples
#' \dontrun{
#' pair_stats_v2(pair_address = "0xf00e80f0de9aea0b33aa229a4014572777e422ee")
#' }
pair_stats_v2 <- function(pair_address = "0xf00e80f0de9aea0b33aa229a4014572777e422ee")
{
    pair_address <- tolower(pair_address)
    qcon <- initialize_queries()
    con <- qcon[[1]]
    qry <- qcon[[2]]
    fromJSON(con$exec(qry$queries$pair_stats,list(pairAdd = pair_address)))$data$pairs
}


#' Get UniswapV3 Pair Stats
#' @param pair_address Pair's Address
#' @return List data on a particular Pair
#'
#' @export
#'
#' @importFrom jsonlite fromJSON
#'
#' @examples
#' \dontrun{
#' pair_stats_v3(pair_address = "0x1d42064fc4beb5f8aaf85f4617ae8b3b5b8bd801")
#' }
pair_stats_v3 <- function(pair_address = "0x1d42064fc4beb5f8aaf85f4617ae8b3b5b8bd801")
{
    pair_address <- tolower(pair_address)
    qcon <- initialize_queries_v3()
    con <- qcon[[1]]
    qry <- qcon[[2]]
    fromJSON(con$exec(qry$queries$pair_stats,list(pairAdd = pair_address)))$data$pools
}


#' Get UniswapV2 Hourly Pair Historical Stats
#' @param pair_address Pair's Address
#' @return Data frame representing Hourly Historical Data on a particular Pair
#'
#' @export
#'
#' @importFrom jsonlite fromJSON
#' @import dplyr
#'
#' @examples
#' \dontrun{
#' pair_stats_hist_hourly_v2(pair_address = "0xf00e80f0de9aea0b33aa229a4014572777e422ee")
#' }
pair_stats_hist_hourly_v2 <- function(pair_address = "0xf00e80f0de9aea0b33aa229a4014572777e422ee")
{
    pair_address <- tolower(pair_address)
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


#' Get UniswapV3 Hourly Pair Historical Stats
#' @param pair_address Pair's Address
#' @return Data frame representing Hourly Historical Data on a particular Pair
#'
#' @export
#'
#' @importFrom jsonlite fromJSON
#' @import dplyr
#'
#' @examples
#' \dontrun{
#' pair_stats_hist_hourly_v3(pair_address = "0x1d42064fc4beb5f8aaf85f4617ae8b3b5b8bd801")
#' }
pair_stats_hist_hourly_v3 <- function(pair_address = "0x1d42064fc4beb5f8aaf85f4617ae8b3b5b8bd801")
{
    pair_address <- tolower(pair_address)
    qcon <- initialize_queries_v3()
    con <- qcon[[1]]
    qry <- qcon[[2]]

    ## Loop historical
    c_timestamp <- as.integer(Sys.time())
    pair_data <- data.frame()
    while(TRUE)
    {
        pair_data_t <- fromJSON(con$exec(qry$queries$pair_stats_hist_hourly,list(pairAdd = pair_address,timestamp=c_timestamp)))$data$pools$poolHourData[[1]]
        if(length(pair_data_t)==0) break()
        pair_data <- bind_rows(pair_data,pair_data_t)
        c_timestamp <- as.numeric(tail(pair_data_t$periodStartUnix,1))
        message(paste0("Fetched ",nrow(pair_data)," Entries"))
    }
    return(pair_data)
}


#' Get UniswapV2 Daily Pair Historical Stats
#' @param pair_address Pair's Address
#' @return Data frame representing Daily Historical Data on a particular Pair
#'
#' @export
#'
#' @importFrom jsonlite fromJSON
#' @import dplyr
#'
#' @examples
#' \dontrun{
#' pair_stats_hist_daily_v2(pair_address = "0xf00e80f0de9aea0b33aa229a4014572777e422ee")
#' }
pair_stats_hist_daily_v2 <- function(pair_address = "0xf00e80f0de9aea0b33aa229a4014572777e422ee")
{
    pair_address <- tolower(pair_address)
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


#' Get UniswapV3 Daily Pair Historical Stats
#' @param pair_address Pair's Address
#' @return Data frame representing Daily Historical Data on a particular Pair
#'
#' @export
#'
#' @importFrom jsonlite fromJSON
#' @import dplyr
#'
#' @examples
#' \dontrun{
#' pair_stats_hist_daily_v3(pair_address = "0x1d42064fc4beb5f8aaf85f4617ae8b3b5b8bd801")
#' }
pair_stats_hist_daily_v3 <- function(pair_address = "0x1d42064fc4beb5f8aaf85f4617ae8b3b5b8bd801")
{
    pair_address <- tolower(pair_address)
    qcon <- initialize_queries_v3()
    con <- qcon[[1]]
    qry <- qcon[[2]]

    ## Loop historical
    c_timestamp <- as.integer(Sys.time())
    pair_data <- data.frame()
    while(TRUE)
    {
        pair_data_t <- fromJSON(con$exec(qry$queries$pair_stats_hist_daily,list(pairAdd = pair_address,timestamp=c_timestamp)))$data$pools$poolDayData[[1]]
        if(length(pair_data_t)==0) break()
        pair_data <- bind_rows(pair_data,pair_data_t)
        c_timestamp <- as.numeric(tail(pair_data_t$date,1))
        message(paste0("Fetched ",nrow(pair_data)," Entries"))
    }
    return(pair_data)
}


#' Get UniswapV2 Current Liquidity Positions in a pair
#' @param pair_address Pair's Address
#' @return Data frame representing Current Liquidity Positions in a pair
#'
#' @export
#'
#' @importFrom jsonlite fromJSON
#' @import dplyr
#'
#' @examples
#' \dontrun{
#' pair_liq_positions_v2(pair_address = "0xf00e80f0de9aea0b33aa229a4014572777e422ee")
#' }
pair_liq_positions_v2 <- function(pair_address = "0xf00e80f0de9aea0b33aa229a4014572777e422ee")
{
    pair_address <- tolower(pair_address)
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


#' Get UniswapV3 Current Liquidity Positions in a pair
#' @param pair_address Pair's Address
#' @return Data frame representing Current Liquidity Positions in a pair
#'
#' @export
#'
#' @importFrom jsonlite fromJSON
#' @import dplyr
#'
#' @examples
#' \dontrun{
#' pair_liq_positions_v3(pair_address = "0x1d42064fc4beb5f8aaf85f4617ae8b3b5b8bd801")
#' }
pair_liq_positions_v3 <- function(pair_address = "0x1d42064fc4beb5f8aaf85f4617ae8b3b5b8bd801")
{
    pair_address <- tolower(pair_address)
    qcon <- initialize_queries_v3()
    con <- qcon[[1]]
    qry <- qcon[[2]]

    ## Loop historical
    id_last = ""
    pair_data <- data.frame()
    while(TRUE)
    {
        pair_data_t <- fromJSON(con$exec(qry$queries$liq_positions,list(pairAdd = pair_address,idlast=id_last)))$data$positions
        if(length(pair_data_t)==0) break()
        pair_data <- bind_rows(pair_data,pair_data_t)
        id_last <- tail(pair_data_t$id,1)
        message(paste0("Fetched ",nrow(pair_data)," Entries"))
    }
    return(pair_data)
}


#' Get Unsiwap2 Historical Liquidity Positions in a pair
#' @param pair_address Pair's Address
#' @return Data frame representing Historical Liquidity Positions in a pair
#'
#' @export
#'
#' @importFrom jsonlite fromJSON
#' @import dplyr
#'
#' @examples
#' \dontrun{
#' pair_liq_positions_hist_v2(pair_address = "0xf00e80f0de9aea0b33aa229a4014572777e422ee")
#' }
pair_liq_positions_hist_v2 <- function(pair_address = "0xf00e80f0de9aea0b33aa229a4014572777e422ee")
{
    pair_address <- tolower(pair_address)
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


#' Get Unsiwap3 Historical Liquidity Positions in a pair
#' @param pair_address Pair's Address
#' @return Data frame representing Historical Liquidity Positions in a pair
#'
#' @export
#'
#' @importFrom jsonlite fromJSON
#' @import dplyr
#'
#' @examples
#' \dontrun{
#' pair_liq_positions_hist_v3(pair_address = "0x1d42064fc4beb5f8aaf85f4617ae8b3b5b8bd801")
#' }
pair_liq_positions_hist_v3 <- function(pair_address = "0x1d42064fc4beb5f8aaf85f4617ae8b3b5b8bd801")
{
    pair_address <- tolower(pair_address)
    qcon <- initialize_queries_v3()
    con <- qcon[[1]]
    qry <- qcon[[2]]

    ## Loop historical
    id_last = ""
    pair_data <- data.frame()
    while(TRUE)
    {
        pair_data_t <- fromJSON(con$exec(qry$queries$liq_positions_hist,list(pairAdd = pair_address,idlast=id_last)))$data$positionSnapshots
        if(length(pair_data_t)==0) break()
        pair_data <- bind_rows(pair_data,pair_data_t)
        id_last <- tail(pair_data_t$id,1)
        message(paste0("Fetched ",nrow(pair_data)," Entries"))
    }
    return(pair_data)
}


#' Get UniswapV2 Mint Transactions in a pair
#' @param pair_address Pair's Address
#' @return Data frame representing Mint Transactions in a pair
#'
#' @export
#'
#' @importFrom jsonlite fromJSON
#' @import dplyr
#'
#' @examples
#' \dontrun{
#' pair_mint_txs_v2(pair_address = "0xf00e80f0de9aea0b33aa229a4014572777e422ee")
#' }
pair_mint_txs_v2 <- function(pair_address = "0xf00e80f0de9aea0b33aa229a4014572777e422ee")
{
    pair_address <- tolower(pair_address)
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


#' Get UniswapV3 Mint Transactions in a pair
#' @param pair_address Pair's Address
#' @return Data frame representing Mint Transactions in a pair
#'
#' @export
#'
#' @importFrom jsonlite fromJSON
#' @import dplyr
#'
#' @examples
#' \dontrun{
#' pair_mint_txs_v3(pair_address = "0x1d42064fc4beb5f8aaf85f4617ae8b3b5b8bd801")
#' }
pair_mint_txs_v3 <- function(pair_address = "0x1d42064fc4beb5f8aaf85f4617ae8b3b5b8bd801")
{
    pair_address <- tolower(pair_address)
    qcon <- initialize_queries_v3()
    con <- qcon[[1]]
    qry <- qcon[[2]]

    ## Loop historical
    c_timestamp <- as.integer(Sys.time())
    pair_data <- data.frame()
    while(TRUE)
    {
        pair_data_t <- fromJSON(con$exec(qry$queries$mints_pair,list(pairAdd = pair_address,timestamp=c_timestamp)))$data$pools$mints[[1]]
        if(length(pair_data_t)==0) break()
        pair_data <- bind_rows(pair_data,pair_data_t)
        c_timestamp <- as.numeric(tail(pair_data_t$timestamp,1))
        message(paste0("Fetched ",nrow(pair_data)," Entries"))
    }
    return(pair_data)
}


#' Get UniswapV2 Burn Transactions in a pair
#' @param pair_address Pair's Address
#' @return Data frame representing Burn Transactions in a pair
#'
#' @export
#'
#' @importFrom jsonlite fromJSON
#' @importFrom utils tail
#' @import dplyr
#'
#' @examples
#' \dontrun{
#' pair_burn_txs_v2(pair_address = "0xf00e80f0de9aea0b33aa229a4014572777e422ee")
#' }
pair_burn_txs_v2 <- function(pair_address = "0xf00e80f0de9aea0b33aa229a4014572777e422ee")
{
    pair_address <- tolower(pair_address)
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


#' Get UniswapV3 Burn Transactions in a pair
#' @param pair_address Pair's Address
#' @return Data frame representing Burn Transactions in a pair
#'
#' @export
#'
#' @importFrom jsonlite fromJSON
#' @importFrom utils tail
#' @import dplyr
#'
#' @examples
#' \dontrun{
#' pair_burn_txs_v3(pair_address = "0x1d42064fc4beb5f8aaf85f4617ae8b3b5b8bd801")
#' }
pair_burn_txs_v3 <- function(pair_address = "0x1d42064fc4beb5f8aaf85f4617ae8b3b5b8bd801")
{
    pair_address <- tolower(pair_address)
    qcon <- initialize_queries_v3()
    con <- qcon[[1]]
    qry <- qcon[[2]]

    ## Loop historical
    c_timestamp <- as.integer(Sys.time())
    pair_data <- data.frame()
    while(TRUE)
    {
        pair_data_t <- fromJSON(con$exec(qry$queries$burns_pair,list(pairAdd = pair_address,timestamp=c_timestamp)))$data$pools$burns[[1]]
        if(length(pair_data_t)==0) break()
        pair_data <- bind_rows(pair_data,pair_data_t)
        c_timestamp <- as.numeric(tail(pair_data_t$timestamp,1))
        message(paste0("Fetched ",nrow(pair_data)," Entries"))
    }
    return(pair_data)
}


#' Get UniswapV2 Swap Transactions in a pair
#' @param pair_address Pair's Address
#' @return Data frame representing Swap Transactions in a pair
#'
#' @export
#'
#' @importFrom jsonlite fromJSON
#' @importFrom utils tail
#' @import dplyr
#'
#' @examples
#' \dontrun{
#' pair_swap_txs_v2(pair_address = "0xf00e80f0de9aea0b33aa229a4014572777e422ee")
#' }
pair_swap_txs_v2 <- function(pair_address = "0xf00e80f0de9aea0b33aa229a4014572777e422ee")
{
    pair_address <- tolower(pair_address)
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


#' Get UniswapV3 Swap Transactions in a pair
#' @param pair_address Pair's Address
#' @return Data frame representing Swap Transactions in a pair
#'
#' @export
#'
#' @importFrom jsonlite fromJSON
#' @importFrom utils tail
#' @import dplyr
#'
#' @examples
#' \dontrun{
#' pair_swap_txs_v3(pair_address = "0x1d42064fc4beb5f8aaf85f4617ae8b3b5b8bd801")
#' }
pair_swap_txs_v3 <- function(pair_address = "0x1d42064fc4beb5f8aaf85f4617ae8b3b5b8bd801")
{
    pair_address <- tolower(pair_address)
    qcon <- initialize_queries_v3()
    con <- qcon[[1]]
    qry <- qcon[[2]]

    ## Loop historical
    c_timestamp <- as.integer(Sys.time())
    pair_data <- data.frame()
    while(TRUE)
    {
        pair_data_t <- fromJSON(con$exec(qry$queries$swaps_pair,list(pairAdd = pair_address,timestamp=c_timestamp)))$data$pools$swaps[[1]]
        if(length(pair_data_t)==0) break()
        pair_data <- bind_rows(pair_data,pair_data_t)
        c_timestamp <- as.numeric(tail(pair_data_t$timestamp,1))
        message(paste0("Fetched ",nrow(pair_data)," Entries"))
    }
    return(pair_data)
}


#' Get UniswapV2 User Liquidity Positions
#' @param user_address User's Address
#' @return Data frame representing User Liquidity Positions
#'
#' @export
#'
#' @importFrom jsonlite fromJSON
#' @importFrom utils tail
#' @import dplyr
#'
#' @examples
#' \dontrun{
#' user_lps_v2(user_address = "0x2502f65d77ca13f183850b5f9272270454094a08")
#' }
user_lps_v2 <- function(user_address = "0x2502f65d77ca13f183850b5f9272270454094a08")
{
    user_address <- tolower(user_address)
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


#' Get UniswapV3 User Liquidity Positions
#' @param user_address User's Address
#' @return Data frame representing User Liquidity Positions
#'
#' @export
#'
#' @importFrom jsonlite fromJSON
#' @importFrom utils tail
#' @import dplyr
#'
#' @examples
#' \dontrun{
#' user_lps_v3(user_address = "0xF1c206dd83ee2b8E6Ea675Cf827C93c58486B972")
#' }
user_lps_v3 <- function(user_address = "0xF1c206dd83ee2b8E6Ea675Cf827C93c58486B972")
{
    user_address <- tolower(user_address)
    qcon <- initialize_queries_v3()
    con <- qcon[[1]]
    qry <- qcon[[2]]
    ## Loop historical
    id_last = ""
    lp_data <- data.frame()
    while(TRUE)
    {
        lp_data_t <- fromJSON(con$exec(qry$queries$lps_user,list(userAdd = user_address,idlast=id_last)))$data$positions
        if(length(lp_data_t)==0) break()
        lp_data <- bind_rows(lp_data,lp_data_t)
        id_last <- tail(lp_data_t$id,1)
        message(paste0("Fetched ",nrow(lp_data)," Entries"))
    }
    return(lp_data)
}


#' Get UniswapV2 Historical User Liquidity Positions
#' @param user_address User's Address
#' @return Data frame representing Historical User Liquidity Positions
#'
#' @export
#'
#' @importFrom jsonlite fromJSON
#' @importFrom utils tail
#' @import dplyr
#'
#' @examples
#' \dontrun{
#' user_hist_lps_v2(user_address = "0x2502f65d77ca13f183850b5f9272270454094a08")
#' }
user_hist_lps_v2 <- function(user_address = "0x2502f65d77ca13f183850b5f9272270454094a08")
{
    user_address <- tolower(user_address)
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

#' Get UniswapV3 Historical User Liquidity Positions
#' @param user_address User's Address
#' @return Data frame representing Historical User Liquidity Positions
#'
#' @export
#'
#' @importFrom jsonlite fromJSON
#' @importFrom utils tail
#' @import dplyr
#'
#' @examples
#' \dontrun{
#' user_hist_lps_v3(user_address = "0xF1c206dd83ee2b8E6Ea675Cf827C93c58486B972")
#' }
user_hist_lps_v3 <- function(user_address = "0xF1c206dd83ee2b8E6Ea675Cf827C93c58486B972")
{
    user_address <- tolower(user_address)
    qcon <- initialize_queries_v3()
    con <- qcon[[1]]
    qry <- qcon[[2]]
    ## Loop historical
    id_last = ""
    lp_data <- data.frame()
    while(TRUE)
    {
        lp_data_t <- fromJSON(con$exec(qry$queries$lps_hist_user,list(userAdd = user_address,idlast=id_last)))$data$positionSnapshots
        if(length(lp_data_t)==0) break()
        lp_data <- bind_rows(lp_data,lp_data_t)
        id_last <- tail(lp_data_t$id,1)
        message(paste0("Fetched ",nrow(lp_data)," Entries"))
    }
    return(lp_data)
}


#' Get UniswapV2 User Swap Txs
#' @param user_address User's Address
#' @return Data frame representing User Swap Txs
#'
#' @export
#'
#' @importFrom jsonlite fromJSON
#' @importFrom utils tail
#' @import dplyr
#'
#' @examples
#' \dontrun{
#' user_swaps_v2(user_address = "0xcd8aa390e6eabbd2169b3580c1f7ce854675fd03")
#' }
user_swaps_v2 <- function(user_address = "0xcd8aa390e6eabbd2169b3580c1f7ce854675fd03")
{
    user_address <- tolower(user_address)
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


#' Get UniswapV3 User Swap Txs
#' @param user_address User's Address
#' @return Data frame representing User Swap Txs
#'
#' @export
#'
#' @importFrom jsonlite fromJSON
#' @importFrom utils tail
#' @import dplyr
#'
#' @examples
#' \dontrun{
#' user_swaps_v3(user_address = "0x431B5A84aCC1297Eda88259f300262F1bc3A74f3")
#' }
user_swaps_v3 <- function(user_address = "0x431B5A84aCC1297Eda88259f300262F1bc3A74f3")
{
    user_address <- tolower(user_address)
    qcon <- initialize_queries_v3()
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


#' Get UniswapV2 User Mint Txs
#' @param user_address User's Address
#' @return Data frame representing User Mint Txs
#'
#' @export
#'
#' @importFrom jsonlite fromJSON
#' @importFrom utils tail
#' @import dplyr
#'
#' @examples
#' \dontrun{
#' user_mints_v2(user_address = "0xcd8aa390e6eabbd2169b3580c1f7ce854675fd03")
#' }
user_mints_v2 <- function(user_address = "0xcd8aa390e6eabbd2169b3580c1f7ce854675fd03")
{
    user_address <- tolower(user_address)
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


#' Get UniswapV3 User Mint Txs
#' @param user_address User's Address
#' @return Data frame representing User Mint Txs
#'
#' @export
#'
#' @importFrom jsonlite fromJSON
#' @importFrom utils tail
#' @import dplyr
#'
#' @examples
#' \dontrun{
#' user_mints_v3(user_address = "0x431B5A84aCC1297Eda88259f300262F1bc3A74f3")
#' }
user_mints_v3 <- function(user_address = "0x431B5A84aCC1297Eda88259f300262F1bc3A74f3")
{
    user_address <- tolower(user_address)
    qcon <- initialize_queries_v3()
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


#' Get UniswapV2 User Burn Txs
#' @param user_address User's Address
#' @return Data frame representing User Burn Txs
#'
#' @export
#'
#' @importFrom jsonlite fromJSON
#' @importFrom utils tail
#' @import dplyr
#'
#' @examples
#' \dontrun{
#' user_burns_v2(user_address = "0xcd8aa390e6eabbd2169b3580c1f7ce854675fd03")
#' }
user_burns_v2 <- function(user_address = "0xcd8aa390e6eabbd2169b3580c1f7ce854675fd03")
{
    user_address <- tolower(user_address)
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


#' Get UniswapV3 User Burn Txs
#' @param user_address User's Address
#' @return Data frame representing User Burn Txs
#'
#' @export
#'
#' @importFrom jsonlite fromJSON
#' @importFrom utils tail
#' @import dplyr
#'
#' @examples
#' \dontrun{
#' user_burns_v3(user_address = "0x431B5A84aCC1297Eda88259f300262F1bc3A74f3")
#' }
user_burns_v3 <- function(user_address = "0x431B5A84aCC1297Eda88259f300262F1bc3A74f3")
{
    user_address <- tolower(user_address)
    qcon <- initialize_queries_v3()
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


