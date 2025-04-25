FROM rocker/r-base:4.0.4

ADD /src /src
WORKDIR /src
RUN Rscript libs.R
