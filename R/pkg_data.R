pkg_data <- function(name,
                     package = "HPOExplorer"){
  utils::data(list=name, package = package)
  get(eval(name))
}
