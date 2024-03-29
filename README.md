
<!-- README.md is generated from README.Rmd. Please edit that file -->

# umbrella <img src="man/figures/umbrella_hex.png" align="right" width=30% height=30% />

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

## Installation

Please install from [GitHub](https://github.com/) with:

``` r
# install.packages("devtools")
devtools::install_github("mrc-ide/umbrella")
```

We estimate the fourier series representing general seasonal profiles
given rainfall in a setting using the following equation

<img src="man/figures/eq.png" />

where `g0`, `g1`, `g2`, `g3`, `h1`, `h2`, `h3` are fitted parameters.
This equation can be fitted as a linear model using Rs `lm` function.

However, we impose an additional constraint when fitting: the rainfall
floor. This sets a minimum lower bound on the value of rainfall. With
this constraint we fit the resulting model with the `optim()` function.
