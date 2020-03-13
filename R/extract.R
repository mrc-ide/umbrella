#' Extract rainfall from rasters
#'
#' @param raster_list list of raster files
#' @param shape Spatial polygon (tested with sf)
#' @param ... Further arguments to  \link[raster]{extract}
#'
#' @return Extracted rainfall in format specified by arguments to \link[raster]{extract}
#' @export
extract_rain <- function(raster_list, shape, ...){
  stopifnot(all(file.exists(raster_list)))
  raster_stack <- raster::stack(raster_list)
  cropped_stack <- raster::crop(raster_stack, shape)
  extract <- raster::extract(cropped_stack, raster_stack, ...)
}
