#' Find Maximum Seasonal Block
#'
#' This function identifies the contiguous block of time steps (with wrapping at the end of the profile)
#' that contributes the highest percentage of the total value over the full cycle (e.g., a year).
#' For each possible starting point, the function computes the sum over the next `block_length` time steps,
#' converts that sum into a percentage of the total, and returns the block with the highest percentage.
#'
#' @param profile A numeric vector representing non-negative values across a regular time cycle (e.g., daily rainfall over a year).
#' @param block_length An integer specifying the number of consecutive time steps in the block.
#' @return A list with the following components:
#'   \describe{
#'     \item{max_percentage}{The maximum percentage of the total value contained in any block.}
#'     \item{peak_season_start}{The starting index of the block with the maximum percentage.}
#'     \item{peak_season_end}{The ending index of the block with the maximum percentage.}
#'   }
#' @details The function iterates over each possible starting index and calculates the sum of the values
#' over the next `block_length` time steps. If the block extends beyond the end of the vector, the counting wraps
#' around to the beginning.
#' @export
#' @examples
#' # Generate a seasonal pattern using a Fourier-based prediction
#' seasonal_pattern <- fourier_predict(
#'   coef = c(0.3, -0.3, 0.3, 0, -0.3, 0.3, 0),
#'   t = 1:365,
#'   floor = 0
#' )
#'
#' # Plot the seasonal pattern
#' plot(seasonal_pattern, t = "l")
#'
#' # Identify the seasonal block with maximum contribution over a 90-day period
#' identify_season <- seasonal_block(
#'   profile = seasonal_pattern$profile,
#'   block_length = 30 * 3
#' )
#' print(identify_season$max_percentage)
#' abline(v = c(identify_season$peak_season_start, identify_season$peak_season_end))
seasonal_block <- function(profile, block_length) {
  total <- sum(profile)
  N <- length(profile)

  if(any(profile < 0)) {
    stop("all profiles values must be >= 0")
  }

  if(block_length%%1 != 0) {
    stop("block_length must be an integer")
  }

  if(block_length > N){
    stop("block_length cannot be greater than the length of the profile vector")
  }

  max_percentage <- -Inf
  max_start <- NA
  max_end <- NA

  # Loop through each possible starting time
  for(i in 1:N) {
    # Get the indices for the n-time block, with wrapping
    indices <- ((i - 1 + 0:(block_length - 1)) %% N) + 1
    block_sum <- sum(profile[indices])
    block_percentage <- (block_sum / total) * 100

    # Check if this block has the highest percentage
    if(block_percentage > max_percentage) {
      max_percentage <- block_percentage
      max_start <- i
      max_end <- indices[block_length]  # last time in the block
    }
  }

  return(
    list(
      max_percentage = max_percentage,
      peak_season_start = max_start,
      peak_season_end = max_end
    )
  )
}
