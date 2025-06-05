FROM rocker/r-ver:4.3.2

# Install system libraries needed for devtools and common dependencies
RUN apt-get update && apt-get install -y --no-install-recommends \
    libcurl4-openssl-dev \
    libssl-dev \
    libxml2-dev \
    libgit2-dev \
    libharfbuzz-dev \
    libfribidi-dev \
    libfreetype6-dev \
    libpng-dev \
    libtiff5-dev \
    libjpeg-dev \
    zlib1g-dev \
    make \
    g++ \
    libglpk-dev \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Pre-install helpful R packages (edit as needed)
RUN Rscript -e 'install.packages(c("devtools", "roxygen2", "testthat", "usethis"), repos = "https://cloud.r-project.org")'
