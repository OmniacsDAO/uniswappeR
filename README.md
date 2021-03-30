# uniswappeR

R Package for Exploration of Uniswap Positions and Trades

<img src="man/figures/example_plot.png" width="600px" align="center"/>

## Description

Our `uniswappeR` R package abstracts away the GraphQL layer of querying for uniswap data into a user-friendly R package. This package includes a number of high level functions for interacting with this data:

- swaps: Returns the swap data for a given set of addresses
- swap_statistics: High level statistics on swaps
- swap_visualizations: A series of ggplot2 visualizations about swap performance
- swap_performance: A ggplot2 visualization for assessing the performance of your swaps

Install the R package with:

`devtools::install_github("Omni-Analytics-Group/uniswappeR")`

## Walkthrough

### 1. Load the package.

- `library(uniswappeR)`

### 2. Define an address or vector of addresses of interest

- `addresses <- c("0x2e3381202988d535e8185e7089f633f7c9998e83", "0x4041E9d98f794EE7d952d266C1A10707A0Af5332", "0x4d9c274ADF71e4201B4aB1f28BF05D44eE4bA261")`

### 3. Get the swap data for those addresses

- `swap_data <- swaps(addresses)`

### 4. Produce visualizations of the swap data

- `swap_visualizations(swap_data)`

### 5. Produce a visualization of the performance of the swaps

- `swap_performance(swap_data)`

## About Us

[Omni Analytics Group](https://omnianalytics.io) is an incorporated group of passionate technologists who help others use data science to change the world. Our  practice of data science leads us into many exciting areas where we enthusiastically apply our machine learning, artificial intelligence and analysis skills. Our flavor for this month, the blockchain!  To learn more about what we do or just to have fun, join us over on [Twitter](https://twitter.com/OmniAnalytics).
