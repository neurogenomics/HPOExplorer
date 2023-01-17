# HPOExplorer 0.99.2

## New features

* Automatically load hpo with new func: `get_hpo()`
* Remove `wesanderson` from deps.
* Add remaining functions from [*rare_disease_celltyping_apps*](https://github.com/neurogenomics/rare_disease_celltyping_apps). 
* Remove unused functions:
  - `make_hoverbox`
  - `get_disease_description_dataframe`
* Add `hpo_tiers` data from Momoko's thesis.
* Make `make_phenos_dataframe` far more efficient.

## Bug fixes

* Remove *globals.R*. 

# HPOExplorer 0.99.2

## New features

* Added a `NEWS.md` file to track changes to the package.
* Implemented `rworkflows`
* `ggnetwork_plot`: make interactive with `plotly`
* Add simplifying wrapper functions:
  - `make_hoverboxes`
  - `make_phenos_dataframe`
* Add `verbose` arg throughout.
* Cache file from `load_phenotype_to_genes`
* Add *hpo_meta* data to speed everything up.
  - Add helper func to preprocess data: `as_ascii`

## Bug fixes

* Make examples runnable.
* Fix Imports
* Update and streamline Get started vignette.
* Remove unused functions:
  - `download_phenotype_to_genes`
  - `hpo_term_definition_list`
