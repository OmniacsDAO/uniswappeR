#' @import ghql
initialize_queries <- function()
{
    ## Initialize Client Connection
    con <- GraphqlClient$new("https://api.thegraph.com/subgraphs/name/ianlapham/uniswap-v2-dev")

    ## Prepare New Query
    qry <- Query$new()

    ##################################################################
    ## Stats of Uniswap Factory
    ##################################################################
    qry$query(
        'factory_stats',
        'query factory_stats
        {
            uniswapFactories
            {
                id
                pairCount
                totalVolumeUSD
                totalVolumeETH
                totalLiquidityUSD
                totalLiquidityETH
                txCount
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
                dailyVolumeETH
                dailyVolumeUSD
                dailyVolumeUntracked
                totalVolumeETH
                totalLiquidityETH
                totalVolumeUSD
                totalLiquidityUSD
                txCount
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
                tradeVolume
                tradeVolumeUSD
                untrackedVolumeUSD
                txCount
                totalLiquidity
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
                    dailyVolumeToken
                    dailyVolumeETH
                    dailyVolumeUSD
                    dailyTxns
                    totalLiquidityToken
                    totalLiquidityETH
                    totalLiquidityUSD
                    priceUSD
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
            tokens(where: {id: $tokenAdd})
            {
                pairBase(orderBy: createdAtTimestamp, orderDirection: desc, first: 1000, where:{createdAtTimestamp_lt:$timestamp })
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
                    reserve0
                    reserve1
                    totalSupply
                    reserveUSD
                    reserveETH
                    trackedReserveETH
                    token0Price
                    token1Price
                    volumeToken0
                    volumeToken1
                    volumeUSD
                    untrackedVolumeUSD
                    txCount
                    createdAtTimestamp
                    createdAtBlockNumber
                    liquidityProviderCount
                }

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
            tokens(where: {id: $tokenAdd})
            {
                pairQuote(orderBy: createdAtTimestamp, orderDirection: desc, first: 1000, where:{createdAtTimestamp_lt:$timestamp })
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
                    reserve0
                    reserve1
                    totalSupply
                    reserveUSD
                    reserveETH
                    trackedReserveETH
                    token0Price
                    token1Price
                    volumeToken0
                    volumeToken1
                    volumeUSD
                    untrackedVolumeUSD
                    txCount
                    createdAtTimestamp
                    createdAtBlockNumber
                    liquidityProviderCount
                }

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
            pairs(orderBy: createdAtTimestamp, orderDirection: desc, first: 1000, where:{createdAtTimestamp_lt:$timestamp })
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
                reserve0
                reserve1
                totalSupply
                reserveUSD
                reserveETH
                trackedReserveETH
                token0Price
                token1Price
                volumeToken0
                volumeToken1
                volumeUSD
                untrackedVolumeUSD
                txCount
                createdAtTimestamp
                createdAtBlockNumber
                liquidityProviderCount
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
            pairs(where: {id: $pairAdd})
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
                reserve0
                reserve1
                totalSupply
                reserveUSD
                reserveETH
                trackedReserveETH
                token0Price
                token1Price
                volumeToken0
                volumeToken1
                volumeUSD
                untrackedVolumeUSD
                txCount
                createdAtTimestamp
                createdAtBlockNumber
                liquidityProviderCount
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
            pairs(where: {id: $pairAdd})
            {
                pairHourData(orderBy: hourStartUnix, orderDirection: desc,first:1000,where:{hourStartUnix_lt:$timestamp })
                {
                    hourStartUnix
                    reserve0
                    reserve1
                    reserveUSD
                    hourlyVolumeToken0
                    hourlyVolumeToken1
                    hourlyVolumeUSD
                    hourlyTxns
                    pair
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
            pairDayDatas(orderBy: date, orderDirection: desc,first:1000,where:{date_lt:$timestamp, pairAddress:$pairAdd})
            {
                date
                pairAddress
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
                reserve0
                reserve1
                totalSupply
                reserveUSD
                dailyVolumeToken0
                dailyVolumeToken1
                dailyVolumeUSD
                dailyTxns
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
            pairs(where:{id:$pairAdd})
            {
                liquidityPositions(orderBy: id, orderDirection: asc,first:1000,where:{id_gt:$idlast})
                {
                    id
                    user
                    {
                        id
                    }
                    pair
                    {
                        id
                    }
                    liquidityTokenBalance
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
            pairs(where:{id:$pairAdd})
            {
                liquidityPositionSnapshots(orderBy: id, orderDirection: asc,first:1000,where:{id_gt:$idlast})
                {
                    id
                    timestamp
                    block
                    user
                    {
                        id
                    }
                    pair
                    {
                        id
                    }
                    token0PriceUSD
                    token1PriceUSD
                    reserve0
                    reserve1
                    reserveUSD
                    liquidityTokenTotalSupply
                    liquidityTokenBalance
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
            pairs(where:{id:$pairAdd})
            {
                mints(orderBy: timestamp, orderDirection: desc,first:1000,where:{timestamp_lt:$timestamp})
                {
                    id
                    timestamp
                    to
                    liquidity
                    sender
                    amount0
                    amount1
                    logIndex
                    amountUSD
                    feeTo
                    feeLiquidity
                    transaction
                    {
                        id
                    }
                    pair
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
            pairs(where:{id:$pairAdd})
            {
                burns(orderBy: timestamp, orderDirection: desc,first:1000,where:{timestamp_lt:$timestamp})
                {
                    id
                    timestamp
                    liquidity
                    sender
                    amount0
                    amount1
                    to
                    logIndex
                    amountUSD
                    needsComplete
                    feeTo
                    feeLiquidity
                    transaction
                    {
                        id
                    }
                    pair
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
            pairs(where:{id:$pairAdd})
            {
                swaps(orderBy: timestamp, orderDirection: desc,first:1000,where:{timestamp_lt:$timestamp})
                {
                    id
                    timestamp
                    sender
                    from
                    amount0In
                    amount0Out
                    amount1In
                    amount1Out
                    to
                    logIndex
                    amountUSD
                    transaction
                    {
                        id
                    }
                    pair
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
            liquidityPositions(orderBy: id, orderDirection: asc,first:1000,where:{id_gt:$idlast,user:$userAdd})
            {
                id
                user
                liquidityTokenBalance
                pair
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
    ## User Liquidity Positions Historical
    ##################################################################
    qry$query(
        'lps_hist_user',
        'query lps_hist_user($userAdd: String!,$idlast: String!)
        {
            liquidityPositionSnapshots(orderBy: id, orderDirection: asc,first:1000,where:{id_gt:$idlast,user:$userAdd})
            {
                id
                timestamp
                block
                user
                token0PriceUSD
                token1PriceUSD
                reserve0
                reserve1
                reserveUSD
                liquidityTokenTotalSupply
                liquidityTokenBalance
                pair
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
    ## User Swap Transactions
    ##################################################################
    qry$query(
        'swap_user',
        'query swap_user($userAdd: String!,$idlast: String!)
        {
            swaps(orderBy: id, orderDirection: asc,first:1000,where:{id_gt:$idlast,to:$userAdd})
            {
                id
                timestamp
                transaction
                {
                    id
                    timestamp
                }
                pair
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
                sender
                from
                to
                amount0In
                amount0Out
                amount1In
                amount1Out
                amountUSD
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
            mints(orderBy: id, orderDirection: asc,first:1000,where:{id_gt:$idlast,to:$userAdd})
            {
                id
                timestamp
                transaction
                {
                    id
                    timestamp
                }
                pair
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
                sender
                to
                liquidity
                amount0
                amount1
                amountUSD
                feeTo
                feeLiquidity
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
            burns(orderBy: id, orderDirection: asc,first:1000,where:{id_gt:$idlast,sender:$userAdd})
            {
                id
                timestamp
                transaction
                {
                    id
                    timestamp
                }
                pair
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
                sender
                to
                liquidity
                amount0
                amount1
                amountUSD
                feeTo
                feeLiquidity
            }
        }'
    )
    ##################################################################
    ##################################################################









































    ## Add Position data query
    qry$query('position_data',
              'query position_data($user: String!, $pair: String!)
	{
		mints(where: {to: $user, pair: $pair})
		{
			amountUSD
			amount0
			amount1
			timestamp
  			pair
  			{
  				id
  				token0
  				{
  					symbol
  					name
  					decimals
  				}
  				token1
  				{
  					symbol
  					name
  					decimals
  				}
  			}
		}
		burns(where: {sender: $user, pair: $pair})
		{
			amountUSD
			amount0
			amount1
			timestamp
  			pair
  			{
  				id
  				token0
  				{
  					symbol
  					name
  					decimals
  				}
  				token1
  				{
  					symbol
  					name
  					decimals
  				}
  			}
		}
	}'
    )

    ## Add Position query
    qry$query('liquidity_positions',
              'query liquidity_positions($user: String!)
	{
		liquidityPositions(where:{ user:$user })
			{
  				id
  				user
  				pair
  				{
  					id
  					reserve0
  					reserve1
  					reserveUSD
  					totalSupply
  					token0
  					{
  						symbol
  						name
  						decimals
  						derivedETH
  					}
  					token1
  					{
  						symbol
  						name
  						decimals
  						derivedETH
  					}
  				}
  				liquidityTokenBalance
			}
	}'
    )

    ## Add Liquidity Position Snapshot query
    qry$query('liquidity_position_snapshots',
              'query liquidity_position_snapshots($user: String!)
	{
		liquidityPositionSnapshots(where:{ user:$user })
			{
  				id
  				timestamp
  				block
  				user
  				pair
  				{
  					id
  					reserve0
  					reserve1
  					reserveUSD
  					token0
  					{
  						symbol
  						name
  						decimals
  					}
  					token1
  					{
  						symbol
  						name
  						decimals
  					}
  				}
  				token0PriceUSD
  				token1PriceUSD
  				reserve0
  				reserve1
  				reserveUSD
  				liquidityTokenTotalSupply
  				liquidityTokenBalance
			}
	}'
    )

    ## Add Transactions Query
    qry$query('transactions_swaps',
              'query transactions($user: String!,$timestamp: Int!)
    {
        swaps(orderBy: timestamp, orderDirection: desc,first:1000, where:{ to:$user,timestamp_lt:$timestamp })
        {
            id
            timestamp
            transaction
            {
                id
                timestamp
            }
            pair
            {
                id
                token0
                {
                    symbol
                    name
                    decimals
                }
                token1
                {
                    symbol
                    name
                    decimals
                }
            }
            sender
            to
            amount0In
            amount0Out
            amount1In
            amount1Out
            amountUSD
        }

    }'
    )
    qry$query('transactions_mints',
              'query transactions($user: String!,$timestamp: Int!)
    {
        mints(orderBy: timestamp, orderDirection: desc,first:1000, where:{ to:$user,timestamp_lt:$timestamp })
        {
            id
            timestamp
            transaction
            {
                id
                timestamp
            }
            pair
            {
                id
                token0
                {
                    symbol
                    name
                    decimals
                }
                token1
                {
                    symbol
                    name
                    decimals
                }
            }
            sender
            to
            liquidity
            amount0
            amount1
            amountUSD
        }

    }'
    )
    qry$query('transactions_burns',
              'query transactions($user: String!,$timestamp: Int!)
    {
        burns(orderBy: timestamp, orderDirection: desc,first:1000, where:{ sender:$user,timestamp_lt:$timestamp})
        {
            id
            timestamp
            transaction
            {
                id
                timestamp
            }
            pair
            {
                id
                token0
                {
                    symbol
                    name
                    decimals
                }
                token1
                {
                    symbol
                    name
                    decimals
                }
            }
            sender
            to
            liquidity
            amount0
            amount1
            amountUSD
        }

    }'
    )

    ## Add Liquidity historical plot data
    qry$query('liquidity_historical',
              'query liquidity_historical($pair: String!, $date: Int!)
	{
		pairDayDatas(first: 1000, orderBy: date, orderDirection: asc, where: {pairAddress: $pair , date_gt: $date})
		{
  			id
    		pairAddress
    		date
    		dailyVolumeToken0
    		dailyVolumeToken1
    		dailyVolumeUSD
    		totalSupply
    		reserveUSD
    		token0
  			{
  				symbol
  				name
  				decimals
  			}
  			token1
  			{
  				symbol
  				name
  				decimals
  			}
    	}
    }'
    )

    return(list(con, qry))
}
