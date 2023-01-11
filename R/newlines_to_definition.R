#' Add new lines to disease description
#'
#' Adds new lines to the description so that hover boxes don't get too wide.
#' @param definition A disease description string
#' @param line_length A integer representing the desired words per line.
#' @returns The disease description with newline symbols added every nth word.
#'
#' @export
#' @examples
#' description <- "A dialeptic seizure is a type of seizure characterised
#' predominantly by reduced responsiveness or awareness and with subsequent at
#' least partial amnesia of the event."
#' newlines_to_definition(description, 10)
newlines_to_definition <- function(definition,
                                   line_length = 10) {
    lapply(definition, function(d){
      d <- strsplit(d, split = " ")[[1]]
      if (length(d) > line_length) {
        remainder <- length(d) %% line_length
        n_new_lines <- floor((length(d) / line_length))
        new_line_index <- seq(line_length, (n_new_lines * line_length),
                              line_length)
        d[new_line_index] <- paste0("\n", d[new_line_index])
      }
      d <- paste(d, collapse = " ")
      return(d)
    }) |> unlist()
}

