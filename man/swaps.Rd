% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/positions.R
\name{swaps}
\alias{swaps}
\title{Get all the swaps data for a given address or addresses}
\usage{
swaps(address)
}
\arguments{
\item{address}{A wallet address (or vector of addresses) for the account owner's account}
}
\value{
dataframe on the swaps for the given account owner
}
\description{
Get all the swaps data for a given address or addresses
}
\examples{

addresses <- c("0xb1b117a45aD71d408eb55475FC3A65454edCc94A",
"0x41D2a18E1DdACdAbFDdADB62e9AEE67c63070b76",
"0x0De20c4bDBE0d0EEFFd2956Be4c148CA86C6cC45")

swaps(addresses)
}
