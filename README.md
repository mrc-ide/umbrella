
<!-- README.md is generated from README.Rmd. Please edit that file -->

# umbrella <img src="inst/figures/hex.png" align="right" width="120" />

<!-- badges: start -->

[![R build
status](https://github.com/mrc-ide/umbrella/workflows/R-CMD-check/badge.svg)](https://github.com/mrc-ide/umbrella/actions)
[![codecov](https://codecov.io/gh/mrc-ide/umbrella/branch/master/graph/badge.svg)](https://codecov.io/gh/mrc-ide/umbrella)
[![Project Status: WIP – Initial development is in progress, but there
has not yet been a stable, usable release suitable for the
public.](https://www.repostatus.org/badges/latest/wip.svg)](https://www.repostatus.org/#wip)
<!-- badges: end -->

Umbrella facilitates access and extraction of CHIRPS rainfall data and
fitting of seasonal profiles.

The package leans heavily on data and functionality from:

CHIRPS: Please see the [CHIRPS
website](https://www.chc.ucsb.edu/data/chirps) for more information,
usage rights and [citation
infromation](http://legacy.chg.ucsb.edu/data/chirps/#_Citations).

Google Earth Engine: Please see (and sign up for) [Google Earth
Engine](https://earthengine.google.com/)

rgee: A superb R package for acessing and processing data from Google
Earth Engine. Please see [rgee](https://r-spatial.github.io/rgee/) for
more info.

## Installation

Please install from [GitHub](https://github.com/) with:

``` r
# install.packages("devtools")
devtools::install_github("mrc-ide/umbrella")
```

You will also need to sign up to [Google Earth
Engine](https://earthengine.google.com/) and follow the [set up
instructions for rgee](https://r-spatial.github.io/rgee/#installation)
before using `umbrella`.

We estimate the fourier series representing general seasonal profiles
given rainfall in a setting using the following equation

<img src="man/figures/eq.png" />

where
*g*<sub>0</sub>, *g*<sub>1</sub>, *g*<sub>2</sub>, *g*<sub>3</sub>, *h*<sub>1</sub>, *h*<sub>2</sub>, *h*<sub>3</sub>
are fitted parameters. This equation can be fitted as a linear model
using Rs `lm` function.

However, we impose an additional constrain when fitting: the rainfall
floor. This sets a minimum lower bound on the value of rainfall. With
this constraint we fit the resuling model with the `nlm()` function.
