% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/analysis.R
\name{liquidity_range_all_v3}
\alias{liquidity_range_all_v3}
\title{Forecast Price for liquidity range for a pair's tokens UniswapV3}
\usage{
liquidity_range_all_v3(
  pair_address = "0x1d42064fc4beb5f8aaf85f4617ae8b3b5b8bd801",
  days = 30,
  cap = 10,
  sims = 1000
)
}
\arguments{
\item{pair_address}{Pair's Address}

\item{days}{How long in future to forecast}

\item{cap}{Max Percentage Increase that can occur in a day, default capped to 10\%}

\item{sims}{Number of simultations}
}
\value{
Data frame representing Forecast Price for a pair's tokens UniswapV3
}
\description{
Forecast Price for liquidity range for a pair's tokens UniswapV3
}
\examples{
liquidity_range_all_v3(pair_address = "0x1d42064fc4beb5f8aaf85f4617ae8b3b5b8bd801",
                       days = 30, cap = 10, sims = 1000)
}
