% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/structure_plots.R
\name{struc_plot}
\alias{struc_plot}
\title{Function to plot STRUCTURE data.}
\usage{
struc_plot(struc_data, pop_labels = FALSE, fill_pal = "discrete", ...)
}
\arguments{
\item{struc_data}{The data frame or tibble to reorder. The function expects
that the column names of the data will be Individual, Cluster and q. The
Individual column will automatically coerced to character.}

\item{pop_labels}{TRUE/FALSE, should the values of Individual be plotted.
Defaults to FALSE.}

\item{fill_pal}{Character vector corresponding to palette to be used. Can be
one of \emph{discrete} (the default), \emph{brewer}, \emph{viridis} and
\emph{custom}. These correspond to the respective \code{scale_fill_*}
functions from \code{ggplot2}. If the \emph{custom} is chosen, values must
given as additional arguments.}

\item{...}{Additional arguments passed to \code{scale_fill_*}.}
}
\value{
A ggplot2 object.
}
\description{
Function that reorders STRUCTURE data and produces ggplot of the reordered
data. The function uses \code{\link{struc_reorder}} to reorder the data
before plotting.
}
\examples{
struc_plot(create_struc_data())
struc_plot(create_struc_data(), fill_pal = "viridis")
struc_plot(create_struc_data(num_clusters = 2), fill_pal = "brewer")
struc_plot(create_struc_data(num_clusters = 2),
           fill_pal = "custom", values = c("red", "blue"))

}
