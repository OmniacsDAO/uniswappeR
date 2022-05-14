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
        'token_pairBase_map',
        'query token_pairBase_map($tokenAdd: String!,$timestamp: Int!)
        {
            pools(orderBy: createdAtTimestamp, orderDirection: desc, first: 1000, where:{createdAtTimestamp_lt:$timestamp,token0:$tokenAdd})
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
    ## Check pair associated with a token as a Quote
    ##################################################################
    qry$query(
        'token_pairQuote_map',
        'query token_pairQuote_map($tokenAdd: String!,$timestamp: Int!)
        {
            pools(orderBy: createdAtTimestamp, orderDirection: desc, first: 1000, where:{createdAtTimestamp_lt:$timestamp,token1:$tokenAdd})
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
    ## Get all pairs
    ##################################################################
    qry$query(
        'all_pairs',
        'query all_pairs($timestamp: Int!)
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
            positions(orderBy: id, orderDirection: asc,first:1000,where:{id_gt:$idlast,pool:$pairAdd})
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
                withdrawnToken1
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


    ##################################################################
    ## Historical Liquidity Positions in a pair
    ##################################################################
    qry$query(
        'liq_positions_hist',
        'query liq_positions_hist($pairAdd: String!,$idlast: String!)
        {
            positionSnapshots(orderBy: id, orderDirection: asc,first:1000,where:{id_gt:$idlast,pool:$pairAdd})
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
                blockNumber
                timestamp
                liquidity
                depositedToken0
                depositedToken1
                withdrawnToken0
                withdrawnToken1
                collectedFeesToken0
                collectedFeesToken1
                position
                {
                    id
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
            }
        }'
    )    
    ##################################################################
    ##################################################################


    ##################################################################
    ## Mint Transactions in a pair
    ##################################################################
    qry$query(
        'mints_pair',
        'query mints_pair($pairAdd: String!,$timestamp: Int!)
        {
            pools(where:{id:$pairAdd})
            {
                mints(orderBy: timestamp, orderDirection: desc,first:1000,where:{timestamp_lt:$timestamp})
                {
                    id
                    timestamp
                    owner
                    sender
                    origin
                    amount
                    amount0
                    amount1
                    amountUSD
                    logIndex
                    tickLower
                    tickUpper
                    transaction
                    {
                        id
                    }
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
    ## Burn Transactions in a pair
    ##################################################################
    qry$query(
        'burns_pair',
        'query burns_pair($pairAdd: String!,$timestamp: Int!)
        {
            pools(where:{id:$pairAdd})
            {
                burns(orderBy: timestamp, orderDirection: desc,first:1000,where:{timestamp_lt:$timestamp})
                {
                    id
                    timestamp
                    owner
                    origin
                    amount
                    amount0
                    amount1
                    amountUSD
                    logIndex
                    tickLower
                    tickUpper
                    transaction
                    {
                        id
                    }
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
    ## Swap Transactions in a pair
    ##################################################################
    qry$query(
        'swaps_pair',
        'query swaps_pair($pairAdd: String!,$timestamp: Int!)
        {
            pools(where:{id:$pairAdd})
            {
                swaps(orderBy: timestamp, orderDirection: desc,first:1000,where:{timestamp_lt:$timestamp})
                {
                    id
                    timestamp
                    sender
                    recipient
                    origin
                    amount0
                    amount1
                    amountUSD
                    logIndex
                    sqrtPriceX96
                    tick
                    transaction
                    {
                        id
                    }
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
    ## User Liquidity Positions Current
    ##################################################################
    qry$query(
        'lps_user',
        'query lps_user($userAdd: String!,$idlast: String!)
        {
            positions(orderBy: id, orderDirection: asc,first:1000,where:{id_gt:$idlast,owner:$userAdd})
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
                withdrawnToken1
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


    ##################################################################
    ## User Liquidity Positions Historical
    ##################################################################
    qry$query(
        'lps_hist_user',
        'query lps_hist_user($userAdd: String!,$idlast: String!)
        {
            positionSnapshots(orderBy: id, orderDirection: asc,first:1000,where:{id_gt:$idlast,owner:$userAdd})
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
                blockNumber
                timestamp
                liquidity
                depositedToken0
                depositedToken1
                withdrawnToken0
                withdrawnToken1
                collectedFeesToken0
                collectedFeesToken1
                position
                {
                    id
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
            }     
        }'
    )    
    ##################################################################
    ##################################################################


    ##################################################################
    ## User Swap Transactions
    ##################################################################
    qry$query(
        'swap_user',
        'query swap_user($userAdd: String!,$idlast: String!)
        {
            swaps(orderBy: id, orderDirection: asc,first:1000,where:{id_gt:$idlast,origin:$userAdd})
            {
                    id
                    timestamp
                    sender
                    recipient
                    origin
                    amount0
                    amount1
                    amountUSD
                    logIndex
                    sqrtPriceX96
                    tick
                    transaction
                    {
                        id
                    }
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
        }'
    )    
    ##################################################################
    ##################################################################


    ##################################################################
    ## User Mint Transactions
    ##################################################################
    qry$query(
        'mint_user',
        'query mint_user($userAdd: String!,$idlast: String!)
        {
            mints(orderBy: id, orderDirection: asc,first:1000,where:{id_gt:$idlast,origin:$userAdd})
            {
                    id
                    timestamp
                    owner
                    sender
                    origin
                    amount
                    amount0
                    amount1
                    amountUSD
                    logIndex
                    tickLower
                    tickUpper
                    transaction
                    {
                        id
                    }
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
        }'
    )    
    ##################################################################
    ##################################################################


    ##################################################################
    ## User Burn Transactions
    ##################################################################
    qry$query(
        'burn_user',
        'query burn_user($userAdd: String!,$idlast: String!)
        {
            burns(orderBy: id, orderDirection: asc,first:1000,where:{id_gt:$idlast,origin:$userAdd})
            {
                    id
                    timestamp
                    owner
                    origin
                    amount
                    amount0
                    amount1
                    amountUSD
                    logIndex
                    tickLower
                    tickUpper
                    transaction
                    {
                        id
                    }
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
        }'
    )    
    ##################################################################
    ##################################################################

    return(list(con, qry))
}