#' Function to plot STRUCTURE data.
#'
#' Function that reorders STRUCTURE data and produces ggplot of the reordered
#' data. The function uses \code{\link{struc_reorder}} to reorder the data
#' before plotting.
#'
#' @inheritParams struc_reorder
#' @param pop_labels TRUE/FALSE, should the values of Individual be plotted.
#' Defaults to FALSE.
#' @param fill_pal Character vector corresponding to palette to be used. Can be
#' one of \emph{discrete} (the default), \emph{brewer}, \emph{viridis} and
#' \emph{custom}. These correspond to the respective \code{scale_fill_*}
#' functions from \code{ggplot2}. If the \emph{custom} is chosen, values must
#' given as additional arguments.
#' @param ... Additional arguments passed to \code{scale_fill_*}.
#'
#' @return A ggplot2 object.
#'
#' @examples
#' struc_plot(create_struc_data())
#' struc_plot(create_struc_data(), fill_pal = "viridis")
#' struc_plot(create_struc_data(num_clusters = 2), fill_pal = "brewer")
#' struc_plot(create_struc_data(num_clusters = 2),
#'            fill_pal = "custom", values = c("red", "blue"))
#'
#' @importFrom rlang .data
#'
#' @export
struc_plot = function(struc_data, pop_labels = FALSE,
                      fill_pal = "discrete", ...) {
  # check arguments
  if (!(fill_pal %in% c("discrete", "brewer", "viridis", "custom"))) {
    warning("fill_pal must be one of discrete, brewer, viridis or custom.
            Returning structure plot with palette discrete.")
  }

  if (fill_pal == "custom" && missing(...)) {
    warning("If using a custom fill you must at least supply values. Returning
            a structure plot with discrete fill.")
    fill_pal <- "discrete"
  }

  # reorder data
  reordered_data <- struc_reorder(struc_data)

  # initial plot
  struc_p <- ggplot2::ggplot(reordered_data,
                             ggplot2::aes(x = forcats::as_factor(.data$Individual),
                       y = q,
                       fill = as.factor(.data$Cluster))) +
    ggplot2::geom_bar(stat = "identity", width = 1) +
    ggplot2::scale_x_discrete(label = NULL) +
    ggplot2::xlab("Individual")

  # customise plot based on additional arguments
  if (!pop_labels) {
    struc_p <- struc_p +
      ggplot2::theme(axis.text.x = ggplot2::element_blank(),
                     axis.ticks.x = ggplot2::element_blank())
  }

  if (fill_pal == "brewer") {
    struc_p <- struc_p + ggplot2::scale_fill_brewer(name = "Cluster", ...)
  } else if (fill_pal == "viridis") {
    struc_p <- struc_p + ggplot2::scale_fill_viridis_d(name = "Cluster", ...)
  } else if (fill_pal == "custom") {
    struc_p <- struc_p + ggplot2::scale_fill_manual(name = "Cluster", ...)
  } else {
    struc_p <- struc_p + ggplot2::scale_fill_hue(name = "Cluster", ...)
  }

  # return plot
  return(struc_p)
}
