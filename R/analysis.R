#' Visualise various growth metrics of the Uniswap Platform
#' @return Plot of growth metrics of the Uniswap Platform
#'
#' @export
#'
#' @import lubridate
#' @import ggplot2
#' @import tidyr
#'
#' @examples
#' vis_uniswap_stats_hist_v2()
vis_uniswap_stats_hist_v2 <- function() 
{
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

    ggplot(plot_data_long, aes(x=Date, y=met_val)) +
        geom_line()+
        facet_wrap(~met_nam, scales="free_y", ncol=1, labeller= variable_labeller)+
        scale_x_date(date_breaks = "months" , date_labels = "%b-%y")+
        labs(x = "Date", y = "Value")+
        ggtitle("Uniswap Platform Growth")+
        theme(plot.title = element_text(hjust = 0.5))

}


#' Visualise various growth metrics of a given token
#' @param token_address Token's Address
#' @return Plot of growth metrics of a given token
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

    ggplot(plot_data_long, aes(x=Date, y=met_val)) +
        geom_line()+
        facet_wrap(~met_nam, scales="free_y", ncol=1, labeller= variable_labeller)+
        scale_x_date(date_breaks = "months" , date_labels = "%b-%y")+
        labs(x = "Date", y = "Value")+
        ggtitle("Token Growth")+
        theme(plot.title = element_text(hjust = 0.5))

}


#' Visualise Number of pairs the token is present
#' @param token_address Token's Address
#' @return Plot of Number of pairs the token is present
#'
#' @export
#'
#' @import lubridate
#' @import ggplot2
#' @import tidyr
#'
#' @examples
#' vis_token_pair_map_v2(token_address = "0x1f9840a85d5af5bf1d1762f925bdaddc4201f984")
vis_token_pair_map_v2 <- function(token_address = "0x1f9840a85d5af5bf1d1762f925bdaddc4201f984") 
{
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

    ggplot(plot_data_long, aes(x=Date, y=met_val)) +
        geom_line()+
        facet_wrap(~met_nam, scales="free_y", ncol=1, labeller= variable_labeller)+
        scale_x_date(date_breaks = "months" , date_labels = "%b-%y")+
        labs(x = "Date", y = "Number of Pairs")+
        ggtitle("Token Number of Pairs Growth")+
        theme(plot.title = element_text(hjust = 0.5))

}


#' Visualise various growth metrics of a given pair
#' @param pair_address Pair's Address
#' @return Plot of growth metrics of a given pair
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

    ggplot(plot_data_long, aes(x=Date, y=met_val)) +
        geom_line()+
        facet_wrap(~met_nam, scales="free_y", ncol=1, labeller= variable_labeller)+
        scale_x_date(date_breaks = "months" , date_labels = "%b-%y")+
        labs(x = "Date", y = "Value")+
        ggtitle("Pair Growth")+
        theme(plot.title = element_text(hjust = 0.5))

}


#' Visualise Liquidity Positions spread in a given pair
#' @param pair_address Pair's Address
#' @return Plot of Liquidity Positions spread in a given pair
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
    plot_data <- pair_liq_positions_v2(pair_address)
    plot_data$liquidityTokenBalance <- as.numeric(plot_data$liquidityTokenBalance)
    plot_data <- plot_data[plot_data$liquidityTokenBalance>0,]

    ggplot(plot_data, aes(x=liquidityTokenBalance)) +
        geom_histogram()+
        scale_x_continuous(breaks = pretty(plot_data$liquidityTokenBalance, n = 20))+
        labs(x = "Liquidity Token Balance", y = "Number of Holders")+
        ggtitle("Liquidity Token Distribution")+
        theme(plot.title = element_text(hjust = 0.5))

}


#' Write out the analysis plots 
#' @param plot_to_export Object containing plot we want to export
#' @param path_to_export Path of the .png file, we want to export to
#' @return Status of the write
#'
#' @export
#' @importFrom ggplot2 ggsave
#'
#' @examples
#' plot_to_export <- vis_uniswap_stats_hist_v2()
#' path_to_export <- "~/Desktop/uniswappeR_plot_export.png"
#' export_plot(plot_to_export,path_to_export)
export_plot <- function(plot_to_export,path_to_export,width=7,height=7) 
{
    ggsave(path_to_export,plot_to_export,width=width,height=height,device = "png")
    return("Plot Export Complete")
}
