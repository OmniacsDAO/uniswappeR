#' Get all the swaps data for a given address or addresses
#'
#' @param address A wallet address (or vector of addresses) for the account owner's account
#'
#' @return dataframe on the swaps for the given account owner
#'
#' @export
#'
#' @importFrom jsonlite fromJSON
#' @import dplyr
#' @importFrom lubridate as_datetime
#' @importFrom tidyr unnest
#' @importFrom utils tail
#'
#' @examples
#'
#' addresses <- c("0xb1b117a45aD71d408eb55475FC3A65454edCc94A",
#' "0x41D2a18E1DdACdAbFDdADB62e9AEE67c63070b76",
#' "0x0De20c4bDBE0d0EEFFd2956Be4c148CA86C6cC45")
#'
#' swaps(addresses)
swaps <- function(address) {
    qcon <- initialize_queries()
    con <- qcon[[1]]
    qry <- qcon[[2]]

    fetch_user_swaps <- function(user_add)
    {
        c_timestamp <- as.integer(Sys.time())
        swap_data <- data.frame()
        while(TRUE)
        {
            swap_data_t <- fromJSON(con$exec(qry$queries$transactions_swaps, list(user = user_add,timestamp=c_timestamp)))$data$swaps
            if(length(swap_data_t)==0) break()
            if(is.data.frame(swap_data_t)) swap_data_t <- swap_data_t %>% mutate(Address = user_add)
            swaps0 <- swap_data_t %>% bind_rows() %>% as_tibble()
            token0 <- swaps0$pair$token0 %>% rename_with(function(.) paste0("token0_", .))
            token1 <- swaps0$pair$token1 %>% rename_with(function(.) paste0("token1_", .))
            trans <- swaps0$transaction %>% rename(transaction_id = id) %>% select(-.data$timestamp)
            swaps1 <- swaps0 %>% select(-.data$pair, -.data$transaction) %>% unnest(.data$Address)
            swaps_t <- swaps1 %>% cbind(trans) %>% cbind(token0) %>% cbind(token1) %>% as_tibble() %>%
                mutate(across(starts_with("amount"), as.numeric)) %>%
                arrange(desc(.data$timestamp))
            swap_data <- do.call(rbind,list(swap_data,swaps_t))
            message(paste0("Fetched ",nrow(swap_data)," Swap Records of address ",user_add))
            if(nrow(swaps_t)<1000) break()
            c_timestamp <- as.numeric(tail(swaps_t$timestamp,1))
        }
        if(nrow(swap_data)>0) swap_data$timestamp <- as_datetime(as.numeric(swap_data$timestamp))
        return(swap_data)
    }

    swaps <- lapply(address,fetch_user_swaps) %>% bind_rows() %>% as_tibble()
    return(swaps %>% select(.data$Address, everything()))
}

#' Get statistics on the swaps data for a given address or addresses
#'
#' @param swap_data The data on swaps as generated by the swaps() function
#' @param aggregate_addresses If TRUE, aggregate the addresses passed in
#'
#' @return dataframe of statistics on the swaps for the given account owner
#'
#' @export
#'
#' @importFrom purrr map_df
#' @import dplyr
#' @importFrom tidyr spread
#'
#' @examples
#'
#' addresses <- c("0xb1b117a45aD71d408eb55475FC3A65454edCc94A",
#' "0x41D2a18E1DdACdAbFDdADB62e9AEE67c63070b76",
#' "0x0De20c4bDBE0d0EEFFd2956Be4c148CA86C6cC45")
#'
#' swap_data <- swaps(addresses)
#' swap_statistics(swap_data)
swap_statistics <- function(swap_data, aggregate_addresses=TRUE) {
    if (aggregate_addresses) {
        swap_data$Address <- "All Addresses"
    }

    `.` <- NULL

    res <- swap_data %>%
        split(.$Address) %>%
        map_df(function(x) {
            pairs <- x %>%
                distinct(.data$token0_name, .data$token1_name)

            num_pairs <- nrow(pairs)
            unique_tokens <- unique(c(x$token0_symbol, x$token1_symbol))
            num_swaps <- nrow(x)
            total_usd <- sum(x$amountUSD)
            avg_time <- -1 * as.numeric(mean(diff(x$timestamp))) / 60 / 60 / 24

            tibble(
                Address = x$Address[1],
                Statistic = c("Number of Pairs", "Number of Unique Tokens Traded", "Number of Swaps",
                              "Total USD Volume", "Average Days between Swaps"),
                Value = c(num_pairs, length(unique_tokens), num_swaps, total_usd, avg_time)
            )
        })

    if (!aggregate_addresses || length(unique(swap_data$Address)) > 1) {
        res <- res %>% spread(key = .data$Address, value = .data$Value)
    }

    if (aggregate_addresses) {
        res <- res %>% select(-.data$Address)
    }

    return(res)
}

#' Get a visualization on the swap data
#'
#' @param swap_data The data on swaps as generated by the swaps() function
#'
#' @return ggplot2 object of visualizations on the swaps for the given account owner
#'
#' @export
#'
#' @import ggplot2
#' @import dplyr
#' @import patchwork
#' @importFrom scales pretty_breaks dollar
#'
#' @examples
#'
#' addresses <- c("0xb1b117a45aD71d408eb55475FC3A65454edCc94A",
#' "0x41D2a18E1DdACdAbFDdADB62e9AEE67c63070b76",
#' "0x0De20c4bDBE0d0EEFFd2956Be4c148CA86C6cC45")
#'
#' swap_data <- swaps(addresses)
#' swap_visualizations(swap_data)
swap_visualizations <- function(swap_data) {
    p1 <- ggplot(swap_data %>% arrange(.data$timestamp) %>% mutate(Count = 1:n()), aes(x = .data$timestamp, y = .data$Count)) +
        geom_point(colour = "purple4") +
        geom_line(colour = "purple4") +
        scale_y_continuous(breaks = scales::pretty_breaks(n = 10)) +
        scale_x_datetime(date_breaks = "1 month", date_labels = "%b-%y") +
        labs(
            title = "Cumulative Number of Swaps over Time",
            subtitle = "For Swaps on the Uniswap Platform",
            x = "Date",
            y = "Number of Swaps"
        )+
        theme(axis.text.x = element_text(size=6,angle = 90))

    p2 <- ggplot(swap_data %>% arrange(.data$timestamp) %>% mutate(Sum = cumsum(.data$amountUSD)), aes(x = .data$timestamp, y = .data$Sum)) +
        geom_point(colour = "green4") +
        geom_line(colour = "green4") +
        scale_y_continuous(breaks = scales::pretty_breaks(n = 10),
                           labels = scales::dollar) +
        scale_x_datetime(date_breaks = "1 month", date_labels = "%b-%y") +
        labs(
            title = "Cumulative Amount of USD Swapped over Time",
            subtitle = "For Swaps on the Uniswap Platform",
            x = "Date",
            y = "Cumulative Amount ($)"
        )+
        theme(axis.text.x = element_text(size=6,angle = 90))

    p3 <- ggplot(swap_data %>% mutate(Pair = paste0(.data$token0_symbol, "/", .data$token1_symbol)) %>%
                     group_by(.data$Pair) %>% summarise(Count = n()) %>%
                     arrange(desc(.data$Count)) %>% top_n(50) %>% mutate(Pair = factor(.data$Pair, levels = .data$Pair)), aes(x = .data$Pair, y = .data$Count)) +
        geom_bar(stat = "identity", fill = "goldenrod3", colour = "black") +
        labs(
            title = "Total Number of Swaps of Each Pair",
            subtitle = "For Swaps on the Uniswap Platform",
            x = "Pair",
            y = "Number of Swaps"
        ) +
        theme(axis.text.x = element_text(angle=90, hjust=1,size=6))

    unique_tokens <- tibble(
        Token = c(swap_data$token0_symbol, swap_data$token1_symbol),
        Count = 1
    ) %>%
        group_by(.data$Token) %>%
        summarise(Count = sum(.data$Count)) %>%
        arrange(desc(.data$Count)) %>%
        top_n(50) %>%
        mutate(Token = factor(.data$Token, levels = .data$Token))

    p4 <- ggplot(unique_tokens, aes(x = .data$Token, y = .data$Count)) +
        geom_bar(stat = "identity", fill = "red3", colour = "black") +
        scale_y_continuous(breaks = scales::pretty_breaks(n = 10)) +
        labs(
            title = "Total Number of Swaps of Each Token",
            subtitle = "For Swaps on the Uniswap Platform",
            x = "Token",
            y = "Number of Swaps"
        ) +
        theme(
            axis.text.x = element_text(angle=90, hjust=1,size=6)
        )

    (p1 + p2) / (p3 + p4)
}
