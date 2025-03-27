#' Find Maximum Seasonal Block
#'
#' This function calculates the contiguous block of days (with wrapping at the end of the year)
#' that contributes the highest percentage of the total annual value (e.g., rainfall).
#' For each possible starting day, the function computes the sum of the next `block_length` days,
#' converts that sum into a percentage of the total, and returns the block with the highest percentage.
#'
#' @param profile A numeric vector representing daily values (e.g., rainfall) for a year.
#' @param block_length An integer specifying the number of consecutive days in the block.
#' @return A list with the following components:
#'   \describe{
#'     \item{max_percentage}{The maximum percentage of the total annual value contained in any block.}
#'     \item{season_start}{The starting day (index) of the block with the maximum percentage.}
#'     \item{season_end}{The ending day (index) of the block with the maximum percentage.}
#'   }
#' @details The function iterates over each possible starting day and calculates the sum of the values
#' over the next `block_length` days. If the block extends beyond the end of the vector, the counting wraps
#' around to the beginning of the year.
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
#' abline(v = c(identify_season$season_start, identify_season$season_end))
seasonal_block <- function(profile, block_length) {
  total <- sum(profile)
  N <- length(profile)

  if(block_length > N){
    stop("block_length cannot be greater than the length of the profile vector")
  }

  max_percentage <- -Inf
  max_start <- NA
  max_end <- NA

  # Loop through each possible starting day
  for(i in 1:N) {
    # Get the indices for the n-day block, wrapping around the year
    indices <- ((i - 1 + 0:(block_length - 1)) %% N) + 1
    block_sum <- sum(profile[indices])
    block_percentage <- (block_sum / total) * 100

    # Check if this block has the highest percentage
    if(block_percentage > max_percentage) {
      max_percentage <- block_percentage
      max_start <- i
      max_end <- indices[block_length]  # last day in the block
    }
  }

  return(
    list(
      max_percentage = max_percentage,
      season_start = max_start,
      season_end = max_end
    )
  )
}
