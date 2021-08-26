#' @import ghql
initialize_queries <- function() {
    ## Initialize Client Connection
    con <- GraphqlClient$new("https://api.thegraph.com/subgraphs/name/uniswap/uniswap-v2")

    ## Prepare New Query
    qry <- Query$new()

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