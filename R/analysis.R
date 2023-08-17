#' Forecast Price for liquidity range for a pair's tokens UniswapV3
#' @param pair_address Pair's Address
#' @param days How long in future to forecast
#' @param cap Max Percentage Increase that can occur in a day, default capped to 10\%
#' @param sims Number of simultations
#' @return Data frame representing Forecast Price for a pair's tokens UniswapV3
#'
#' @export
#'
#' @import lubridate
#' @import dplyr
#' @import tidyr
#' @importFrom rlang .data
#' @importFrom stats quantile
#'
#' @examples
#' liquidity_range_all_v3(pair_address = "0x1d42064fc4beb5f8aaf85f4617ae8b3b5b8bd801",
#'                        days = 30, cap = 10, sims = 1000)
liquidity_range_all_v3 <- function(pair_address = "0x1d42064fc4beb5f8aaf85f4617ae8b3b5b8bd801",days=30,cap=10,sims=1000)
{
    Simulation <- Variable <- Value <- `.` <- NULL

    ## Pull data
    data <- pair_stats_hist_daily_v3(pair_address)
    token0 <- unique(data$pool$token0$symbol)
    token1 <- unique(data$pool$token1$symbol)
    data <- data[-nrow(data),]
    data$Date <- as_date(as_datetime(data$date))
    data <- data[,c("Date","token0Price","token1Price")]
    data$token0Price <- as.numeric(data$token0Price)
    data$token1Price <- as.numeric(data$token1Price)

    ## New Data
    ndata <- data.frame(Date = seq(max(data$Date),max(data$Date)+days,by="days"),token0PricePred=NA,token0PriceUpper=NA,token0PriceLower=NA,token1PricePred=NA,token1PriceUpper=NA,token1PriceLower=NA)

    ## Brownian Motion Data
    btc_brownian <- data %>%
        mutate(
                Returns0 = c(1, .data$token0Price[-1] / lag(.data$token0Price, 1)[-1]),
                Returns1 = c(1, .data$token1Price[-1] / lag(.data$token1Price, 1)[-1]),
            ) %>%
        mutate(
                Returns0 = pmin(cap, pmax(1 / cap, .data$Returns0)),
                Returns1 = pmin(cap, pmax(1 / cap, .data$Returns1)),
                ScaledReturns0 = .data$Returns0 - 1,
                ScaledReturns1 = .data$Returns1 - 1
            )

    # Simulate returns according to the number of times
    simulated_returns0 <- as.data.frame(do.call(cbind, lapply(1:sims, function(i) {sample(btc_brownian$Returns0, size = nrow(ndata), replace = TRUE)})))
    simulated_returns1 <- as.data.frame(do.call(cbind, lapply(1:sims, function(i) {sample(btc_brownian$Returns1, size = nrow(ndata), replace = TRUE)})))

    # Build the predictions dataset
    btc_brownian_preds0 <- cbind(Date = ndata$Date, simulated_returns0) %>%
        gather(key = Simulation, value = Value, 2:ncol(.)) %>%
        group_by(.data$Simulation) %>%
        mutate(CumeValue = cumprod(.data$Value),
               Future = .data$CumeValue * data$token0Price[length(data$token0Price)]) %>%
        group_by(.data$Date) %>%
        summarise(Prediction = mean(.data$Future),
                  Upper = quantile(.data$Future, .975),
                  Lower = quantile(.data$Future, .025),
                  Method = "Brownian Motion")
    btc_brownian_preds1 <- cbind(Date = ndata$Date, simulated_returns1) %>%
        gather(key = Simulation, value = Value, 2:ncol(.)) %>%
        group_by(.data$Simulation) %>%
        mutate(CumeValue = cumprod(.data$Value),
               Future = .data$CumeValue * data$token1Price[length(data$token1Price)]) %>%
        group_by(.data$Date) %>%
        summarise(Prediction = mean(.data$Future),
                  Upper = quantile(.data$Future, .975),
                  Lower = quantile(.data$Future, .025),
                  Method = "Brownian Motion")
    ndata$token0PricePred <- btc_brownian_preds0$Prediction
    ndata$token1PricePred <- btc_brownian_preds1$Prediction
    ndata$token0PriceUpper <- btc_brownian_preds0$Upper
    ndata$token1PriceUpper <- btc_brownian_preds1$Upper
    ndata$token0PriceLower <- btc_brownian_preds0$Lower
    ndata$token1PriceLower <- btc_brownian_preds1$Lower
    names(ndata)[2:7] <- c(paste0(token0,c("_PricePred","_PriceUpper","_PriceLower")),paste0(token1,c("_PricePred","_PriceUpper","_PriceLower")))

    ## Return Predictions with estimates
    return(ndata)
}


#' Get a visualization liquidity range estimates
#'
#' @param pair_address The address of the pair to analyze
#' @param ... Additional arguments passed to the liquidity_range_all_v3 function
#'
#' @return Visualization on the liquidity range for the given pair
#'
#' @export
#'
#' @import ggplot2
#' @import dplyr
#' @importFrom rlang .data
#'
#' @examples
#' liquidity_range_visualization("0x1d42064fc4beb5f8aaf85f4617ae8b3b5b8bd801")
liquidity_range_visualization <- function(pair_address, ...) {
    Variable <- Value <- `.` <- NULL
    x <- liquidity_range_all_v3(pair_address = pair_address, ...)

    names(x) <- gsub("Price", "", names(x))

    y <- x %>%
        gather(key = Variable, value = Value, 2:ncol(.)) %>%
        separate(Variable, into = c("Token", "Variable"), sep = "_", extra = "merge")

    ggplot(data = y, aes(x = Date, y = Value, colour = Variable)) +
        geom_point() +
        geom_line() +
        scale_colour_brewer(palette = "Dark2") +
        facet_wrap(~Token, scales = "free_y", nrow = 2) +
        labs(
            title = "Brownian Motion based Liquidity Pool Price Forecasts",
            subtitle = paste0("For Pool: ", pair_address)
        )
}


#' Get a suggested range for liquidity
#'
#' @param pair_address The address of the pair to analyze
#' @param ... Additional arguments passed to the liquidity_range_all_v3 function
#'
#' @return Character vector representing a Suggestion for liquidity Range
#'
#' @export
#'
#' @import ggplot2
#' @import dplyr
#' @importFrom utils tail
#'
#' @examples
#' liquidity_range_v3(pair_address = "0x1d42064fc4beb5f8aaf85f4617ae8b3b5b8bd801")
liquidity_range_v3 <- function(pair_address, ...) {
    x <- liquidity_range_all_v3(pair_address = pair_address, ...)
    range_x <- as.data.frame(rbind(as.numeric(tail(x[,c(3,4)],1)),as.numeric(tail(x[,c(6,7)],1))))
    names(range_x) <- c("Upper Range","Lower Range")
    rownames(range_x) <- c(paste0(gsub("_PricePred","",names(x)[c(2,5)]),collapse="/"),paste0(gsub("_PricePred","",names(x)[c(5,2)]),collapse="/"))
    return(range_x)
}


#' Visualise various growth metrics of the UniswapV2 Platform
#' @return ggplot2 plot of growth metrics of the UniswapV2 Platform
#'
#' @export
#'
#' @import lubridate
#' @import ggplot2
#' @import tidyr
#'
#' @examples
#' \dontrun{vis_uniswap_stats_hist_v2()}
vis_uniswap_stats_hist_v2 <- function()
{
    met_val <- NULL
    plot_data <- uniswap_stats_hist_v2()
    plot_data$Date <- as_date(as_datetime(plot_data$date))

    plot_data_long <- gather(plot_data, key="met_nam", value="met_val", c( "dailyVolumeETH" , "dailyVolumeUSD" ,"totalLiquidityETH", "totalLiquidityUSD" ,"txCount"))
    plot_data_long <- plot_data_long[,c("Date","met_nam","met_val")]
    plot_data_long$met_val <- as.numeric(plot_data_long$met_val)
    variable_names <- list(
                            "dailyVolumeETH" = "Daily Volume (ETH)" ,
                            "dailyVolumeUSD" = "Daily Volume (USD)" ,
                            "totalLiquidityETH" = "Total Liquidity (ETH)",
                            "totalLiquidityUSD" = "Total Liquidity (USD)",
                            "txCount"  = "Transaction Count"
                        )
    variable_labeller <- function(variable,value) return(variable_names[value])

    plot <- ggplot(plot_data_long, aes(x=Date, y=met_val)) +
            geom_line()+
            facet_wrap(~met_nam, scales="free_y", ncol=1, labeller= variable_labeller)+
            scale_x_date(date_breaks = "months" , date_labels = "%b-%y")+
            labs(x = "Date", y = "Value")+
            ggtitle("UniswapV2 Platform Growth")+
            theme(plot.title = element_text(hjust = 0.5),axis.text.x = element_text(angle = 90))
    return(plot)
}


#' Visualise various growth metrics of the UniswapV3 Platform
#' @return ggplot plot of growth metrics of the UniswapV3 Platform
#'
#' @export
#'
#' @import lubridate
#' @import ggplot2
#' @import tidyr
#'
#' @examples
#' \dontrun{vis_uniswap_stats_hist_v3()}
vis_uniswap_stats_hist_v3 <- function()
{
    met_val <- NULL
    plot_data <- uniswap_stats_hist_v3()
    plot_data$Date <- as_date(as_datetime(plot_data$date))

    plot_data_long <- gather(plot_data, key="met_nam", value="met_val", c( "volumeETH" , "volumeUSD" ,"tvlUSD", "feesUSD" ,"txCount"))
    plot_data_long <- plot_data_long[,c("Date","met_nam","met_val")]
    plot_data_long$met_val <- as.numeric(plot_data_long$met_val)
    variable_names <- list(
                            "volumeETH" = "Daily Volume (ETH)" ,
                            "volumeUSD" = "Daily Volume (USD)" ,
                            "tvlUSD" = "Daily Volume Locked (USD)",
                            "feesUSD" = "Daily Fee Collected (USD)",
                            "txCount"  = "Transaction Count"
                        )
    variable_labeller <- function(variable,value) return(variable_names[value])

    plot <- ggplot(plot_data_long, aes(x=Date, y=met_val)) +
            geom_line()+
            facet_wrap(~met_nam, scales="free_y", ncol=1, labeller= variable_labeller)+
            scale_x_date(date_breaks = "months" , date_labels = "%b-%y")+
            labs(x = "Date", y = "Value")+
            ggtitle("UniswapV3 Platform Growth")+
            theme(plot.title = element_text(hjust = 0.5),axis.text.x = element_text(angle = 90))
    return(plot)
}


#' Visualise various growth metrics of a given token in UniswapV2
#' @param token_address Token's Address
#' @return ggplot2 Plot of growth metrics of a given token
#'
#' @export
#'
#' @import lubridate
#' @import ggplot2
#' @import tidyr
#'
#' @examples
#' vis_token_stats_hist_v2(token_address = "0x1f9840a85d5af5bf1d1762f925bdaddc4201f984")
vis_token_stats_hist_v2 <- function(token_address = "0x1f9840a85d5af5bf1d1762f925bdaddc4201f984")
{
    met_val <- NULL
    plot_data <- token_stats_hist_v2(token_address)
    plot_data$Date <- as_date(as_datetime(plot_data$date))

    plot_data_long <- gather(plot_data, key="met_nam", value="met_val", c( "dailyVolumeETH" , "dailyVolumeUSD" ,"totalLiquidityETH", "totalLiquidityUSD" ,"dailyTxns","priceUSD"))
    plot_data_long <- plot_data_long[,c("Date","met_nam","met_val")]
    plot_data_long$met_val <- as.numeric(plot_data_long$met_val)
    variable_names <- list(
                            "dailyVolumeETH" = "Daily Volume (ETH)" ,
                            "dailyVolumeUSD" = "Daily Volume (USD)" ,
                            "totalLiquidityETH" = "Token Liquidity (ETH)",
                            "totalLiquidityUSD" = "Token Liquidity (USD)",
                            "dailyTxns"  = "Daily Transaction Count",
                            "priceUSD" = "Price of Token (USD)"
                        )
    variable_labeller <- function(variable,value) return(variable_names[value])

    plot <- ggplot(plot_data_long, aes(x=Date, y=met_val)) +
            geom_line()+
            facet_wrap(~met_nam, scales="free_y", ncol=1, labeller= variable_labeller)+
            scale_x_date(date_breaks = "months" , date_labels = "%b-%y")+
            labs(x = "Date", y = "Value")+
            ggtitle(paste0("Token Growth V2 (", token_address, ")"))+
            theme(plot.title = element_text(hjust = 0.5),axis.text.x = element_text(angle = 90))
    return(plot)
}


#' Visualise various growth metrics of a given token in UniswapV3
#' @param token_address Token's Address
#' @return ggplot2 Plot of growth metrics of a given token
#'
#' @export
#'
#' @import lubridate
#' @import ggplot2
#' @import tidyr
#'
#' @examples
#' vis_token_stats_hist_v3(token_address = "0x1f9840a85d5af5bf1d1762f925bdaddc4201f984")
vis_token_stats_hist_v3 <- function(token_address = "0x1f9840a85d5af5bf1d1762f925bdaddc4201f984")
{
    met_val <- NULL
    plot_data <- token_stats_hist_v3(token_address)
    plot_data$Date <- as_date(as_datetime(plot_data$date))

    plot_data_long <- gather(plot_data, key="met_nam", value="met_val", c( "volume" , "volumeUSD" ,"totalValueLocked", "totalValueLockedUSD" ,"feesUSD","priceUSD"))
    plot_data_long <- plot_data_long[,c("Date","met_nam","met_val")]
    plot_data_long$met_val <- as.numeric(plot_data_long$met_val)
    variable_names <- list(
                            "volume" = "Daily Volume (Tokens)" ,
                            "volumeUSD" = "Daily Volume (USD)" ,
                            "totalValueLocked" = "Token Value Locked (Tokens)",
                            "totalValueLockedUSD" = "Token Value Locked (USD)",
                            "feesUSD"  = "Daily Fee Collected (USD)",
                            "priceUSD" = "Price of Token (USD)"
                        )
    variable_labeller <- function(variable,value) return(variable_names[value])

    plot <- ggplot(plot_data_long, aes(x=Date, y=met_val)) +
            geom_line()+
            facet_wrap(~met_nam, scales="free_y", ncol=1, labeller= variable_labeller)+
            scale_x_date(date_breaks = "months" , date_labels = "%b-%y")+
            labs(x = "Date", y = "Value")+
            ggtitle(paste0("Token Growth V3 (", token_address, ")"))+
            theme(plot.title = element_text(hjust = 0.5),axis.text.x = element_text(angle = 90))
    return(plot)
}


#' Visualise Number of pairs the token is present UniswapV2
#' @param token_address Token's Address
#' @return ggplot2 Plot of Number of pairs the token is present
#'
#' @export
#'
#' @import lubridate
#' @import ggplot2
#' @import tidyr
#'
#' @examples
#' \dontrun{vis_token_pair_map_v2(token_address = "0x1f9840a85d5af5bf1d1762f925bdaddc4201f984")}
vis_token_pair_map_v2 <- function(token_address = "0x1f9840a85d5af5bf1d1762f925bdaddc4201f984")
{
    met_val <- NULL
    plot_data <- token_pair_map_v2(token_address)
    plot_data$Date <- as_date(as_datetime(as.numeric(plot_data$createdAtTimestamp)))
    plot_data$If_Token0 <- plot_data$token0$id==token_address
    plot_data$If_Token1 <- plot_data$token1$id==token_address
    plot_data <- plot_data[order(plot_data$Date),]
    plot_data$token0_cumsum <- cumsum(plot_data$If_Token0)
    plot_data$token1_cumsum <- cumsum(plot_data$If_Token1)

    plot_data_long <- gather(plot_data, key="met_nam", value="met_val", c( "token0_cumsum" , "token1_cumsum"))
    plot_data_long <- plot_data_long[,c("Date","met_nam","met_val")]
    plot_data_long$met_val <- as.numeric(plot_data_long$met_val)
    variable_names <- list(
                            "token0_cumsum" = "Number of Pairs with token as Token0" ,
                            "token1_cumsum" = "Number of Pairs with token as Token1"
                        )
    variable_labeller <- function(variable,value) return(variable_names[value])

    plot <- ggplot(plot_data_long, aes(x=Date, y=met_val)) +
            geom_line()+
            facet_wrap(~met_nam, scales="free_y", ncol=1, labeller= variable_labeller)+
            scale_x_date(date_breaks = "months" , date_labels = "%b-%y")+
            labs(x = "Date", y = "Number of Pairs")+
            ggtitle("Token Number of Pairs Growth")+
            theme(plot.title = element_text(hjust = 0.5),axis.text.x = element_text(angle = 90))
    return(plot)

}


#' Visualise Number of pairs the token is present UniswapV3
#' @param token_address Token's Address
#' @return ggplot2 Plot of Number of pairs the token is present
#'
#' @export
#'
#' @import lubridate
#' @import ggplot2
#' @import tidyr
#'
#' @examples
#' vis_token_pair_map_v3(token_address = "0x1f9840a85d5af5bf1d1762f925bdaddc4201f984")
vis_token_pair_map_v3 <- function(token_address = "0x1f9840a85d5af5bf1d1762f925bdaddc4201f984")
{
    met_val <- NULL
    plot_data <- token_pair_map_v3(token_address)
    plot_data$Date <- as_date(as_datetime(as.numeric(plot_data$createdAtTimestamp)))
    plot_data$If_Token0 <- plot_data$token0$id==token_address
    plot_data$If_Token1 <- plot_data$token1$id==token_address
    plot_data <- plot_data[order(plot_data$Date),]
    plot_data$token0_cumsum <- cumsum(plot_data$If_Token0)
    plot_data$token1_cumsum <- cumsum(plot_data$If_Token1)

    plot_data_long <- gather(plot_data, key="met_nam", value="met_val", c( "token0_cumsum" , "token1_cumsum"))
    plot_data_long <- plot_data_long[,c("Date","met_nam","met_val")]
    plot_data_long$met_val <- as.numeric(plot_data_long$met_val)
    variable_names <- list(
                            "token0_cumsum" = "Number of Pairs with token as Token0" ,
                            "token1_cumsum" = "Number of Pairs with token as Token1"
                        )
    variable_labeller <- function(variable,value) return(variable_names[value])

    plot <- ggplot(plot_data_long, aes(x=Date, y=met_val)) +
            geom_line()+
            facet_wrap(~met_nam, scales="free_y", ncol=1, labeller= variable_labeller)+
            scale_x_date(date_breaks = "months" , date_labels = "%b-%y")+
            labs(x = "Date", y = "Number of Pairs")+
            ggtitle("Token Number of Pairs Growth")+
            theme(plot.title = element_text(hjust = 0.5),axis.text.x = element_text(angle = 90))
    return(plot)

}


#' Visualise various growth metrics of a given pair UniswapV2
#' @param pair_address Pair's Address
#' @return ggplot2 Plot of growth metrics of a given pair
#'
#' @export
#'
#' @import lubridate
#' @import ggplot2
#' @import tidyr
#'
#' @examples
#' vis_pair_stats_hist_daily_v2(pair_address = "0xf00e80f0de9aea0b33aa229a4014572777e422ee")
vis_pair_stats_hist_daily_v2 <- function(pair_address = "0xf00e80f0de9aea0b33aa229a4014572777e422ee")
{
    met_val <- NULL
    plot_data <- pair_stats_hist_daily_v2(pair_address)
    plot_data$Date <- as_date(as_datetime(as.numeric(plot_data$date)))
    Token0_Sym <- unique(plot_data$token0$symbol)
    Token1_Sym <- unique(plot_data$token1$symbol)

    plot_data_long <- gather(plot_data, key="met_nam", value="met_val", c( "dailyTxns" , "dailyVolumeToken0","dailyVolumeToken1","dailyVolumeUSD","reserve0","reserve1"))
    plot_data_long <- plot_data_long[,c("Date","met_nam","met_val")]
    plot_data_long$met_val <- as.numeric(plot_data_long$met_val)
    variable_names <- list(
                            "dailyTxns" = "Number of Daily Transactions" ,
                            "dailyVolumeToken0" = paste0(Token0_Sym,"\'s Daily Volume"),
                            "dailyVolumeToken1" = paste0(Token1_Sym,"\'s Daily Volume"),
                            "dailyVolumeUSD" = "Daily Volume (USD)",
                            "reserve0" = paste0(Token0_Sym,"\'s Liquidity"),
                            "reserve1" = paste0(Token1_Sym,"\'s Liquidity")
                        )
    variable_labeller <- function(variable,value) return(variable_names[value])

    plot <- ggplot(plot_data_long, aes(x=Date, y=met_val)) +
            geom_line()+
            facet_wrap(~met_nam, scales="free_y", ncol=1, labeller= variable_labeller)+
            scale_x_date(date_breaks = "months" , date_labels = "%b-%y")+
            labs(x = "Date", y = "Value")+
            ggtitle(paste0("Pair Growth V2 (", pair_address, ")"))+
            theme(plot.title = element_text(hjust = 0.5),axis.text.x = element_text(angle = 90))
    return(plot)

}


#' Visualise various growth metrics of a given pair UniswapV3
#' @param pair_address Pair's Address
#' @return ggplot2 Plot of growth metrics of a given pair
#'
#' @export
#'
#' @import lubridate
#' @import ggplot2
#' @import tidyr
#'
#' @examples
#' vis_pair_stats_hist_daily_v3(pair_address = "0x1d42064fc4beb5f8aaf85f4617ae8b3b5b8bd801")
vis_pair_stats_hist_daily_v3 <- function(pair_address = "0x1d42064fc4beb5f8aaf85f4617ae8b3b5b8bd801")
{
    met_val <- NULL
    plot_data <- pair_stats_hist_daily_v3(pair_address)
    plot_data$Date <- as_date(as_datetime(as.numeric(plot_data$date)))
    Token0_Sym <- unique(plot_data$pool$token0$symbol)
    Token1_Sym <- unique(plot_data$pool$token1$symbol)

    plot_data_long <- gather(plot_data, key="met_nam", value="met_val", c( "txCount" , "volumeToken0","volumeToken1","volumeUSD","token0Price","token1Price"))
    plot_data_long <- plot_data_long[,c("Date","met_nam","met_val")]
    plot_data_long$met_val <- as.numeric(plot_data_long$met_val)
    variable_names <- list(
                            "txCount" = "Number of Daily Transactions" ,
                            "volumeToken0" = paste0(Token0_Sym,"\'s Daily Volume"),
                            "volumeToken1" = paste0(Token1_Sym,"\'s Daily Volume"),
                            "volumeUSD" = "Daily Volume (USD)",
                            "token0Price" = paste0(Token0_Sym,"\'s Price in ",Token1_Sym),
                            "token1Price" = paste0(Token1_Sym,"\'s Price in ",Token0_Sym)
                        )
    variable_labeller <- function(variable,value) return(variable_names[value])

    plot <- ggplot(plot_data_long, aes(x=Date, y=met_val)) +
            geom_line()+
            facet_wrap(~met_nam, scales="free_y", ncol=1, labeller= variable_labeller)+
            scale_x_date(date_breaks = "months" , date_labels = "%b-%y")+
            labs(x = "Date", y = "Value")+
            ggtitle(paste0("Pair Growth V3 (", pair_address, ")"))+
            theme(plot.title = element_text(hjust = 0.5),axis.text.x = element_text(angle = 90))
    return(plot)

}


#' Visualise Liquidity Positions spread in a given pair
#' @param pair_address Pair's Address
#' @return ggplot2 Plot of Liquidity Positions spread in a given pair
#'
#' @export
#'
#' @import lubridate
#' @import ggplot2
#' @import tidyr
#'
#' @examples
#' vis_pair_liq_positions_v2(pair_address = "0xf00e80f0de9aea0b33aa229a4014572777e422ee")
vis_pair_liq_positions_v2 <- function(pair_address = "0xf00e80f0de9aea0b33aa229a4014572777e422ee")
{
    liquidityTokenBalance <- NULL
    plot_data <- pair_liq_positions_v2(pair_address)
    plot_data$liquidityTokenBalance <- as.numeric(plot_data$liquidityTokenBalance)
    plot_data <- plot_data[plot_data$liquidityTokenBalance>0,]

    plot <- ggplot(plot_data, aes(x=liquidityTokenBalance)) +
            geom_histogram()+
            scale_x_continuous(breaks = pretty(plot_data$liquidityTokenBalance, n = 20))+
            labs(x = "Liquidity Token Balance", y = "Number of Holders")+
            ggtitle(paste0("Liquidity Token Distribution V2 (", pair_address, ")"))+
            theme(plot.title = element_text(hjust = 0.5))
    return(plot)

}



#' Visualise Liquidity Positions spread in a given pair
#' @param pair_address Pair's Address
#' @return ggplot2 Plot of Liquidity Positions spread in a given pair
#'
#' @export
#'
#' @import lubridate
#' @import ggplot2
#' @import tidyr
#'
#' @examples
#' \dontrun{
#' vis_pair_liq_positions_v3(pair_address = "0x1d42064fc4beb5f8aaf85f4617ae8b3b5b8bd801")
#' }
vis_pair_liq_positions_v3 <- function(pair_address = "0x1d42064fc4beb5f8aaf85f4617ae8b3b5b8bd801")
{
    liquidity <- NULL
    plot_data <- pair_liq_positions_v3(pair_address)
    plot_data$liquidity <- as.numeric(plot_data$liquidity)
    plot_data <- plot_data[plot_data$liquidity>0,]

    plot <- ggplot(plot_data, aes(x=liquidity)) +
            geom_histogram()+
            scale_x_continuous(breaks = pretty(plot_data$liquidity, n = 20))+
            labs(x = "Liquidity Token Balance", y = "Number of Holders")+
            ggtitle(paste0("Liquidity Token Distribution V3 (", pair_address, ")"))+
            theme(plot.title = element_text(hjust = 0.5))
    return(plot)

}


#' Write out the analysis plots
#' @param plot_to_export Object containing plot we want to export
#' @param path_to_export Path of the .png file, we want to export to
#' @param width Width of plot in inches
#' @param height Height of plot in inches
#' @return Character vector of the status of the write
#'
#' @export
#' @importFrom ggplot2 ggsave
#'
#' @examples
#' \dontrun{
#' plot_to_export <- vis_uniswap_stats_hist_v2()
#' path_to_export <- "~/Desktop/uniswappeR_plot_export.png"
#' export_plot(plot_to_export,path_to_export)
#' }
export_plot <- function(plot_to_export,path_to_export,width=7,height=7)
{
    ggsave(path_to_export,plot_to_export,width=width,height=height)
    return("Plot Export Complete")
}
