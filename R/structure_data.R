#' Creates random STRUCTURE data of the format required for plotting
#'
#' The function creates a tibble with three columns: Individual, Cluster, q.
#' Users can control the number of individuals and clusters created and then
#' test using the plotting functions.
#'
#' @param num_indiv The number of individuals to produce, defaults to 500.
#' @param num_clusters The number of clusters to produce, defaults to 10.
#'
#' @return A tibble with three columns: Individual (character),
#' Cluster (integer) and q (double).
#'
#' @examples
#' create_struc_data()
#' struc_plot(create_struc_data())
#'
#' @importFrom stats rnorm
#'
#' @export
create_struc_data <- function(num_indiv = 500, num_clusters = 10) {
  # create text for individuals
  Individuals = paste0("Ex", c(101:(100 + num_indiv)))
  # create blank tibble
  structure_data = tibble::tibble(Individual = character(length = 0),
                                  Cluster = integer(length = 0),
                                  q = double(length = 0))
  # create initial value and other values to choose from
  start_vals = round(1 - abs(rnorm(1000, 0, 0.2)), 4)
  poss_vals = seq(0, 1, by = 0.001)
  # for each individual, create vector of q values
  for(ind in c(1:length(Individuals))) {
    q <- sample(start_vals[start_vals < 1], 1)

    for (i in c(2:num_clusters)) {
      if (sum(q) == 1) {
        q[i:num_clusters] <- 0
        break()
      } else if (i == num_clusters) {
        q[i] = 1 - sum(q)
      } else {
        q[i] = sample(poss_vals[poss_vals < (1 - sum(q))], 1)
      }
    }
    # add to tibble, randomly reordering q values amongst clusters
    structure_data = dplyr::bind_rows(structure_data,
                                      tibble::tibble(Individual = Individuals[ind],
                                                     Cluster = c(1:num_clusters),
                                                     q = sample(q, num_clusters)))
  }

  # return tibble
  return(structure_data)
}


#' Reorder structure data before plotting
#'
#' The function takes in a data frame or tibble and returns it reordered by the
#' clusters per individual with descending values of q.
#'
#' @param struc_data The data frame or tibble to reorder. The function expects
#' that the column names of the data will be Individual, Cluster and q. The
#' Individual column will automatically coerced to character.
#'
#' @return The data frame or tibble reordered.
#'
#' @example struc_reorder(create_struc_data())
#'
#' @importFrom rlang .data
#' @export
struc_reorder <- function(struc_data) {
  if (ncol(struc_data) != 3) {
    stop("Inputted data has too many columns. Three columns are expected:
         Individual, Cluster and q.")
  } else if (!("Individual" %in% colnames(struc_data))) {
    stop("No column named Individual found. Three columns are expected:
         Individual, Cluster and q.")
  } else if (!("Cluster" %in% colnames(struc_data))) {
    stop("No column named Cluster found. Three columns are expected:
         Individual, Cluster and q.")
  } else if (!("q" %in% colnames(struc_data))) {
    stop("No column named q found. Three columns are expected:
         Individual, Cluster and q.")
  }

  # number of clusters
  num_clusters <- length(unique(struc_data$Cluster))
  # ensure Individual is character so sorted alphabetically
  # group results by individual
  struc_data <- dplyr::mutate(struc_data,
                              Individual = as.character(.data$Individual))
  grp_struc <- dplyr::group_by(struc_data, .data$Individual)

  # simple sort if just two clusters
  if (num_clusters <= 2) {
    reorder_struc <-  dplyr::arrange(grp_struc, .data$Cluster, dplyr::desc(q))
    # otherwise use largest cluster
  } else {
    grp_struc <-  dplyr::mutate(grp_struc,
                                main_cluster = .data$Cluster[q == max(q)][1])
    reorder_struc <- dplyr::arrange(grp_struc, .data$main_cluster, dplyr::desc(q))
  }
  # return ungrouped data
  return(dplyr::ungroup(reorder_struc))
}

