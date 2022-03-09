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


    ##################################################################
    ## Check pair associated with a token as a base
    ##################################################################
    qry$query(
        'token_pair_map',
        'query token_pair_map($timestamp: Int!)
        {
            pools(orderBy: createdAtTimestamp, orderDirection: desc, first: 1000, where:{createdAtTimestamp_lt:$timestamp })
            {
                id
                token0
                {
                    id
                    symbol
                    name
                    decimals
                }
                token1
                {
                    id
                    symbol
                    name
                    decimals
                }
                feeTier
                liquidity
                token0Price
                token1Price
                volumeToken0
                volumeToken1
                volumeUSD
                untrackedVolumeUSD
                feesUSD
                txCount
                collectedFeesToken0
                collectedFeesToken1
                collectedFeesUSD
                totalValueLockedToken0
                totalValueLockedToken1
                totalValueLockedETH
                totalValueLockedUSD
                liquidityProviderCount
                totalValueLockedUSDUntracked
                createdAtTimestamp
                createdAtBlockNumber
            }

        }'
    )    
    ##################################################################
    ##################################################################


    ##################################################################
    ## Stats of a particular pair
    ##################################################################
    qry$query(
        'pair_stats',
        'query pair_stats($pairAdd: String!)
        {
            pools(where: {id: $pairAdd})
            {
                id
                token0
                {
                    id
                    symbol
                    name
                    decimals
                }
                token1
                {
                    id
                    symbol
                    name
                    decimals
                }
                feeTier
                liquidity
                token0Price
                token1Price
                volumeToken0
                volumeToken1
                volumeUSD
                untrackedVolumeUSD
                feesUSD
                txCount
                collectedFeesToken0
                collectedFeesToken1
                collectedFeesUSD
                totalValueLockedToken0
                totalValueLockedToken1
                totalValueLockedETH
                totalValueLockedUSD
                liquidityProviderCount
                totalValueLockedUSDUntracked
                createdAtTimestamp
                createdAtBlockNumber
            }
        }'
    )    
    ##################################################################
    ##################################################################


    ##################################################################
    ## Historical Stats Hourly of a particular pair
    ##################################################################
    qry$query(
        'pair_stats_hist_hourly',
        'query pair_stats_hist_hourly($pairAdd: String!,$timestamp: Int!)
        {
            pools(where: {id: $pairAdd})
            {
                poolHourData(orderBy: periodStartUnix, orderDirection: desc,first:1000,where:{periodStartUnix_lt:$timestamp })
                {
                    periodStartUnix
                    liquidity
                    sqrtPrice
                    token0Price
                    token1Price
                    tvlUSD
                    volumeToken0
                    volumeToken1
                    volumeUSD
                    feesUSD
                    txCount
                    open
                    high
                    low
                    close
                    pool
                    {
                        id
                        token0
                        {
                            id
                            symbol
                            name
                            decimals
                        }
                        token1
                        {
                            id
                            symbol
                            name
                            decimals
                        }
                    }
                }
            }
        }'
    )    
    ##################################################################
    ##################################################################


    ##################################################################
    ## Historical Stats Daily of a particular pair
    ##################################################################
    qry$query(
        'pair_stats_hist_daily',
        'query pair_stats_hist_daily($pairAdd: String!,$timestamp: Int!)
        {
            pools(where: {id: $pairAdd})
            {
                poolDayData(orderBy: date, orderDirection: desc,first:1000,where:{date_lt:$timestamp })
                {
                    date
                    liquidity
                    sqrtPrice
                    token0Price
                    token1Price
                    tvlUSD
                    volumeToken0
                    volumeToken1
                    volumeUSD
                    feesUSD
                    txCount
                    open
                    high
                    low
                    close
                    pool
                    {
                        id
                        token0
                        {
                            id
                            symbol
                            name
                            decimals
                        }
                        token1
                        {
                            id
                            symbol
                            name
                            decimals
                        }
                    }
                }
            }
        }'
    )    
    ##################################################################
    ##################################################################


    ##################################################################
    ## Liquidity Positions in a pair
    ##################################################################
    qry$query(
        'liq_positions',
        'query liq_positions($pairAdd: String!,$idlast: String!)
        {
            positions(orderBy: id, orderDirection: asc,first:1000,where:{id_gt:$idlast})
            {
                id
                owner
                pool
                {
                    id
                    token0
                    {
                        id
                        symbol
                        name
                        decimals
                    }
                    token1
                    {
                        id
                        symbol
                        name
                        decimals
                    }
                }
                liquidity
                depositedToken0
                depositedToken1
                withdrawnToken0
                withdrawnToken0
                collectedFeesToken0
                collectedFeesToken1
                tickLower
                {
                    id
                    price0
                    price1
                }
                tickUpper
                {
                    id
                    price0
                    price1
                }
            }
        }'
    )    
    ##################################################################
    ##################################################################

    return(list(con, qry))
}