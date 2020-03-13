#' Fourier transform internal cos
#'
#' @param a Parameter
#' @param t Vector of times
#' @param i Level
#'
#' @return Fourier component
s_a <- function(a, t, i){
  a * cos(2 * pi * t * i)
}

#' Fourier transform internal sin
#'
#' @param b Parameter
#' @param t Vector of times
#' @param i Level
#'
#' @return Fourier component
s_b <- function(b, t, i){
  b * sin(2 * pi * t * i)
}

#' Seasonality curve
#'
#' Predicts a seasonal curve given fourier transform parameters
#'
#' @param par Parameter vector: a0, a1, b2, a2, b2, a3, b3
#' @param t Vector of times. One year runs between 0 and 1.
#'
#' @return seasonality curve
#' @export
seasonality <- function(par, t = seq(0, 1, length.out = 365)){
  stopifnot(length(par) == 7)
  par[1] +
    s_a(par[2], t, 1) +
    s_b(par[3], t, 1) +
    s_a(par[4], t, 2) +
    s_b(par[5], t, 2) +
    s_a(par[6], t, 3) +
    s_b(par[7], t, 3)
}
