#' Clear cache
#'
#' Remove all data cached by \pkg{HPOExplorer}.
#' @param save_dir Path to cache directory.
#' @param verbose Print messages.
#' @inheritParams base::unlink
#' @inheritDotParams base::unlink
#' @returns Null.
#'
#' @export
#' @importFrom tools R_user_dir
#' @examples
#' \dontrun{
#' clear_cache()
#' }
clear_cache <- function(save_dir=tools::R_user_dir(package = "HPOExplorer",
                                                   which = "cache"),
                        recursive=TRUE,
                        verbose=TRUE,
                        ...
                        ){

  f <- list.files(save_dir,recursive = recursive)
  messager("Clearing",length(f),"cached files from:",save_dir,v=verbose)
  unlink(x = save_dir,recursive = recursive,...)
}
