#' Estimate the fourier coefficients
#'
#' @param rainfall Vector of rainfall
#' @param t Vector of times. Must be between 0 and 1.
#'
#' @return Coefficient estimates
#' @export
fourier_model <- function(rainfall, t){
  if(any(t > 1) | any (t < 0)){
    stop("t must be between 0 and 1")
  }
  if(length(rainfall) != length(t)){
    stop("rainfall and t must be of equal length")
  }

  model_data <- data.frame(
    rainfall = rainfall,
    g1 = basecos(level = 1, t = t),
    g2 = basecos(level = 2, t = t),
    g3 = basecos(level = 3, t = t),
    h1 = basesin(level = 1, t = t),
    h2 = basesin(level = 2, t = t),
    h3 = basesin(level = 3, t = t))

  model <- stats::lm(rainfall ~ g1 + g2 + g3 + h1 + h2 + h3, data = model_data)

  return(model)
}

fourier_ceofficient <- function(model){
  coef <- stats::summary.lm(model)$coef[,1]
  names(coef)[1] <- "g0"
  coef <- data.frame(t(coef))
  return(coef)
}

fourier_predict <- function(model, t){
  new_data <- data.frame(
    g1 = basecos(level = 1, t = t),
    g2 = basecos(level = 2, t = t),
    g3 = basecos(level = 3, t = t),
    h1 = basesin(level = 1, t = t),
    h2 = basesin(level = 2, t = t),
    h3 = basesin(level = 3, t = t))

  prediction <- stats::predict(model, newdata = new_data)
  profile <- data.frame(t = t, y = prediction)

  return(profile)
}

basecos <- function(level, t = 1:365 / 365){
  cos(2 * pi * t * level)
}

basesin <- function(level, t = 1:365 / 365){
  sin(2 * pi * t * level)
}
