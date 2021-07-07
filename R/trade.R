#' Gets the Infura Node
#'
#' @return Your Infura Node, if set
#' @export
#' @examples
#' \dontrun{
#' get_infura_node()
#' }
get_infura_node <- function() {
  env <- Sys.getenv("INFURA_NODE")
  if (!identical(env, "")) return(env)

  if (!interactive()) {
    stop("Please set the environment variable INFURA_NODE to your Infura Node", call. = FALSE)
  }

  message("Please enter your INFURA NODE and press enter:")

  infura_node <- readline(": ")

  if (identical(infura_node, "")) {
    stop("Invalid INFURA NODE", call. = FALSE)
  }

  message("Updating INFURA_NODE environment variable.")
  Sys.setenv(INFURA_NODE = infura_node)

  return(infura_node)
}

#' Sets the Infura Node
#'
#' @name set_infura_node
#' @param infura_node The Infura Node
#' @return A boolean TRUE if the INFURA NODE was successfully set
#' @export
#' @examples
#' \dontrun{
#' set_infura_node("https://mainnet.infura.io/v3/XXXXXXXXXXXXXXXXXXX")
#' }
set_infura_node <- function(infura_node) {
  if (identical(infura_node, "")) {
    stop("Invalid Password", call. = FALSE)
  }

  Sys.setenv(INFURA_NODE = infura_node)

  return(TRUE)
}

#################################################################
## Helper Functions
#################################################################
#' Python builtin functions
#' @import reticulate
#' @export
py_int <- function() return(import_builtins(convert = FALSE)$int)

#' python object to R
#' @param val Numeric converter to export
#' @export
r_num <- function(val) as.numeric(as.character(val))


#' Start the python session
#'
#' @param node The Infura Node
#' @param user_add User Address
#' @param pvt_key Private Key of the user Address
#'
#' @return The python session uniswap endpoint
#'
#' @export
#'
#' @import reticulate
#' @import jsonlite
uniswap_session <- function(node = get_infura_node(),user_add=NULL,pvt_key=NULL){
    ## Select which python to use
    # use_python("/usr/bin/python3")

    ## Set infura Node as 
    py_run_string(paste0('import os;os.environ["PROVIDER"] = "',node,'"'))

    ## Initialise uniswap endpooint
    uniswap <- import("uniswap",convert=FALSE)
    uniswap$Uniswap(user_add,pvt_key, version=2)
}

#################################################################
## Helper Functions
#################################################################
#' Get your ETH Balance
#' @export
#' @param u_w Uniswap Session
#' @return Return User ETH Balance
check_eth_balance <- function(u_w) r_num(u_w$get_eth_balance())/(10**18)

#' Check any Token Balance
#' @export
#' @param u_w Uniswap Session
#' @param t_a Token Address
#' @param t_d Token Decimals
#' @return Return User Token Balance
check_tok_balance <- function(t_a,t_d,u_w) r_num(u_w$get_token_balance(t_a))/(10**t_d)

#' Swap ETH for a Token, Given ETH Qty check how much token you would get
#' @export
#' @param u_w Uniswap Session
#' @param t_a Token Address
#' @param t_d Token Decimals
#' @param e_q Ethereum Qty.
#' @return Token Amount one will get
check_eth.to.tok_eth.fix <- function(t_a,t_d,e_q,u_w) r_num(u_w$get_eth_token_input_price(t_a,py_int(e_q*10**18)))/(10**t_d)

#' Swap ETH for a Token, Given Token Qty check how much ETH you need
#' @export
check_eth.to.tok_tok.fix <- function(t_a,t_d,t_q,u_w) r_num(u_w$get_eth_token_output_price(t_a,py_int(t_q*10**t_d)))/(10**18)

#' Swap Token for ETH, Given Token Qty check how much ETH you would get
#' @export
check_tok.to.eth_tok.fix <- function(t_a,t_d,t_q,u_w) r_num(u_w$get_token_eth_input_price(t_a,py_int(t_q*10**t_d)))/(10**18)

#' Swap Token for ETH, Given ETH Qty check how much Token you need
#' @export
check_tok.to.eth_eth.fix <- function(t_a,t_d,e_q,u_w) r_num(u_w$get_token_eth_output_price(t_a,py_int(e_q*10**18)))/(10**t_d)

#' Swap Token1 for Token2, Given Token1 Qty check how much Token2 you would get (Use Token1 -> ETH -> Token2 Route)
#' @export
check_tok1.to.tok2_tok1.fix <- function(t1_a,t1_d,t2_a,t2_d,t1_q,u_w) r_num(u_w$get_token_token_input_price(t1_a,t2_a,py_int(t1_q*10**t1_d)))/(10**t2_d)

#' Swap Token1 for Token2, Given Token2 Qty check how much Token1 you would need (Use Token1 -> ETH -> Token2 Route)
#' @export
check_tok1.to.tok2_tok2.fix <- function(t1_a,t1_d,t2_a,t2_d,t2_q,u_w) r_num(u_w$get_token_token_output_price(t1_a,t2_a,py_int(t2_q*10**t2_d)))/(10**t1_d)
#################################################################
#################################################################

#################################################################
## Trade Functions
#################################################################
#' Swap ETH for a Token, Receive Tokens for specified ETH amount
#' @export
trade_eth.to.tok_eth.fix <- function(t_a,t_d,e_q,u_w) as.character(u_w$'_eth_to_token_swap_input'(t_a,py_int(e_q*10**18),recipient=NULL)$hex())

#' Swap ETH for a Token, Buy specified fixed Token Amount
#' @export
trade_eth.to.tok_tok.fix <- function(t_a,t_d,t_q,u_w) as.character(u_w$'_eth_to_token_swap_output'(t_a,py_int(t_q*10**t_d),recipient=NULL)$hex())

#' Swap Token for ETH, Receive ETH after swapping specified token amount
#' @export
trade_tok.to.eth_tok.fix <- function(t_a,t_d,t_q,u_w) as.character(u_w$'_token_to_eth_swap_input'(t_a,py_int(t_q*10**t_d),recipient=NULL)$hex())

#' Swap Token for ETH, Swap tokens to receive specified ETH amount
#' @export
trade_tok.to.eth_eth.fix <- function(t_a,t_d,e_q,u_w) as.character(u_w$'_token_to_eth_swap_output'(t_a,py_int(e_q*10**18),recipient=NULL)$hex())

#' Swap Token1 for Token2, Receive Token2 for specified Token1 Amount
#' @export
trade_tok1.to.tok2_tok1.fix <- function(t1_a,t1_d,t2_a,t2_d,t1_q,u_w) as.character(u_w$'_token_to_token_swap_input'(t1_a,py_int(t1_q*10**t1_d),t2_a,recipient=NULL)$hex())

#' Swap Token1 for Token2, Receive Token2 for specified Token1 Amount
#' @export
trade_tok1.to.tok2_tok2.fix <- function(t1_a,t1_d,t2_a,t2_d,t2_q,u_w) as.character(u_w$'_token_to_token_swap_output'(t1_a,py_int(t2_q*10**t2_d),t2_a,recipient=NULL)$hex())
#################################################################
#################################################################