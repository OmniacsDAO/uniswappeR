#' @import ghql
initialize_queries_v3 <- function() 
{
    ## Initialize Client Connection
    con <- GraphqlClient$new("https://api.thegraph.com/subgraphs/name/uniswap/uniswap-v3")

    ## Prepare New Query
    qry <- Query$new()
    
    ##################################################################
    ## Stats of Uniswap Factory
    ##################################################################
    qry$query(
        'factory_stats',
        'query factory_stats
        {
            factories
            {
                id
                poolCount
                txCount
                totalVolumeUSD
                totalVolumeETH
                totalFeesUSD
                totalFeesETH
                totalValueLockedUSD
                totalValueLockedETH                                
                untrackedVolumeUSD              
            }
        }'
    )
    ##################################################################
    ##################################################################


    ##################################################################
    ## Historical Stats of Uniswap Platform
    ##################################################################
    qry$query(
        'uni_stats_hist',
        'query uni_stats_hist($timestamp: Int!)
        {
            uniswapDayDatas(orderBy: date, orderDirection: desc,first:1000,where:{date_lt:$timestamp})
            {
                date
                volumeETH
                volumeUSD
                feesUSD
                txCount
                tvlUSD
            }
        }'
    )
    ##################################################################
    ##################################################################


    ##################################################################
    ## Stats of a particular token
    ##################################################################
    qry$query(
        'token_stats',
        'query token_stats($tokenAdd: String!)
        {
            tokens(where: {id: $tokenAdd})
            {
                id
                symbol
                name
                decimals
                totalSupply
                volume
                volumeUSD
                untrackedVolumeUSD
                feesUSD
                txCount
                poolCount
                totalValueLocked
                totalValueLockedUSD
                derivedETH
            }
        }'
    )    
    ##################################################################
    ##################################################################


    ##################################################################
    ## Historical Stats of a particular token
    ##################################################################
    qry$query(
        'token_stats_hist',
        'query token_stats_hist($tokenAdd: String!,$timestamp: Int!)
        {
            tokens(where: {id: $tokenAdd})
            {
                tokenDayData(orderBy: date, orderDirection: desc,first:1000,where:{date_lt:$timestamp})
                {
                    date
                    volume
                    volumeUSD
                    totalValueLocked
                    totalValueLockedUSD
                    priceUSD
                    feesUSD
                    open
                    high
                    low
                    close
                }

            }
        }'
    )    
    ##################################################################
    ##################################################################

    return(list(con, qry))
}