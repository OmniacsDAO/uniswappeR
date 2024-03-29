% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/analysis.R
\name{liquidity_range_visualization}
\alias{liquidity_range_visualization}
\title{Get a visualization liquidity range estimates}
\usage{
liquidity_range_visualization(pair_address, ...)
}
\arguments{
\item{pair_address}{The address of the pair to analyze}

\item{...}{Additional arguments passed to the liquidity_range_all_v3 function}
}
\value{
Visualization on the liquidity range for the given pair
}
\description{
Get a visualization liquidity range estimates
}
\examples{
liquidity_range_visualization("0x1d42064fc4beb5f8aaf85f4617ae8b3b5b8bd801")
}
