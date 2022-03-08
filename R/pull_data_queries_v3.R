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

    return(list(con, qry))
}