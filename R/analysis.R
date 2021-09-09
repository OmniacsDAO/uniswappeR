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
#' data_to_export <- token_stats_hist_v2(token_address = "0x1f9840a85d5af5bf1d1762f925bdaddc4201f984")
#' path_to_export <- "~/Desktop/uniswappeR_export.csv"
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
    variable_labeller <- function(variable,met_val) return(variable_names[met_val])

    ggplot(plot_data_long, aes(x=Date, y=met_val)) +
        geom_line()+
        facet_wrap(~met_nam, scales="free_y", ncol=1, labeller= variable_labeller)+
        scale_x_date(date_breaks = "months" , date_labels = "%b-%y")+
        labs(x = "Date", y = "Value")+
        ggtitle("Uniswap Platform Growth")+
        theme(plot.title = element_text(hjust = 0.5))

}
