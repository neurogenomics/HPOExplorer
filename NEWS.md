# HPOExplorer 0.99.6

## New features

* New function for creating gene x phenotype matrix
  - `hpo_to_matrix`

# HPOExplorer 0.99.5

## New features

* New functions:
  - `make_igraph_network`
  - `network_3d`
  - `kde_surface`
* `make_network_object`: Now takes additional arguments 
  to control the network layout.


# HPOExplorer 0.99.4

## New features

* `example_phenos`: 
  - Simplified and fast
  - Used in all applicable examples.
* Create new `hpo` object:
  - This updates the HPO from 2016 (distributed by `ontologyIndex`) with an updated 
    one from 2023.
  - Updated all *data* objects in `HPOExplorer` that may
    have relied on `hpo` to be generated.
*  `fix_hpo_ids`
  - New function for fixing issues with missing HPO IDs.

## Bug fixes

* `hpo_tiers`:
  - Found lots of typos, outdated phenotype names, and mismatched HPO IDs.
    We through and manually re-curated all of these and checked that they match up with the 
    `harmonise_phenotypes` output.
  - Add original `hpo_tiers` csv to *inst/extdata*.
* Delete `get_hpo_id` function in favor of `get_hpo_id_direct` 
  which is more reliable and comprehensive.

# HPOExplorer 0.99.3

## Bug fixes

* `get_ont_lvls`: 
  - Worked w Bobby to clarify the role of each ontology level function.
  - Added new internal function to get the max ontology level: `get_max_ont_lvl`
  - Rewrote function description to make the differences between 
    absolute/relative level more clear.
* `make_network_object`:
  - Use `list_columns` so that `ontLvl_relative` gets added to network obj.
*  `list_columns`
  - Add new arg `extra_cols`

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
* `adjacency_matrix`:
  - Simply turn into a shallow wrapper for nearly identical function: 
    `ontologyIndex::get_term_descendancy_matrix`
* `load_phenotype_to_genes`:
  - Can now downlaod either *phenotypes_to_genes* or *genes_to_phenotypes*.
* New functions supporting gene target prioritisation: 
  - `phenos_to_granges`
  - `add_onset`
  - `add_tier`
  - `harmonise_phenotypes`
  - `get_gene_lists`
  - `get_gene_lengths`
  - `list_onsets`

## Bug fixes

* Remove *globals.R*. 
* Avoid redundancy with:
  - `get_relative_ont_level` ~= `find_parent` ~= `get_ont_level` --> `get_ont_lvl`
  - `get_relative_ont_level_multiple` ~= `get_hierarchy` --> `get_ont_lvls`

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
