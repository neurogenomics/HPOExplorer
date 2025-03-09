# HPOExplorer 1.0.5

## New features

* Store HPO ontology in default `KGExplorer` cache dir to reduce disk storage.

# HPOExplorer 1.0.4

## Bug fixes

* Fix tests expecting fixed number of phenotypes.
* Vignette
  - `HPOExplorer`: Fix rendering of final plot.

# HPOExplorer 1.0.3

## New features

* Upgrade `add_disease` to use cached definitions.

## Bug fixes

* Fix tests for `make_phenos_dataframe`.
* Deprecate `hpo_api` as the HPO API was deprecated in the 2.0.0 Release (https://hpo.jax.org/data/api).

# HPOExplorer 1.0.1

## New features

- Add Issues templates

## Bug fixes

* Fix tests: 
  - `gpt_annot_check` 
  - `add_hpo_id`
* Fix functions: `gpt_annot_plot`

# HPOExplorer 1.0.0

## New features

* *MAJOR CHANGES*: Switched from `ontologyIndex` to `simona`, 
  which seems to be better written and has extensive analysis functions.
* *MAJOR CHANGES*: Moved most non-HPO data annotation to [`KnowledgeNets`](https://github.com/neurogenomics/KnowledgeNets)
  - Functions to assess disease or phenotype prevalence (https://github.com/neurogenomics/RareDiseasePrioritisation/issues/34)
    - `get_prevalence_orphanet`
    - `get_prevalence_oard` 
  - Functions to assess the existence of models for phenotypes or diseases (https://github.com/neurogenomics/RareDiseasePrioritisation/issues/33)  
    - `map_upheno`
    - `map_upheno_data`
    - `map_upheno_plots`
    - `map_upheno_heatmap`
    - `map_upheno_rainplot`
    - `map_upheno_scatterplot`
    - `get_monarch`
    - `get_monarch_models` 
  
* New exported functions:
  - Helper functions: 
    - `convert_hpo`
  - Functions to map IDs across ontologies:
    - `add_medgen`
    - `add_omop` 
    - `add_prevalence`
    - `add_prevalence_report`
* New internal functions:
  - `dt_to_matrix`

## Bug fixes

* `add_mondo`
  - Drastically improved cross-ontology mappings to MONDO (https://github.com/monarch-initiative/mondo/issues/6873)
    - Add subfunction `map_mondo`
   
# HPOExplorer 0.99.12

## New features

* `get_hpo`
  - Updated to latest release: 2023-08-01
* `gpt_annot_*`
  - Ensure consistent use of updated column names.
* Add version attribute data within HPO objects
  - `get_hpo`: already built in to `ontologyIndex` objects.
  - `load_phenotypes_to_genes`: new attribute.
  - New exported helper function: `get_version`
  - New exported helper function: `clear_cache`
* Add `make_ontology` internal function.
* Ensure consistent function naming:
  - `create_node_data` --> `make_node_data` 
* `get_gencc`
  - Export
  - Add version info
* Increase code coverage throughout


# HPOExplorer 0.99.11

## New features

* New GPT annotation functions
  - `gpt_annot_read`
  - `gpt_annot_check`
  - `gpt_annot_codify`
  - `gpt_annot_plot`
* `get_hpo`
  - Get OBO directly from  "https://github.com/obophenotype/human-phenotype-ontology/releases" 
    rather than Bioportal.
  - Used "hp-base.obo" as this seemed to match the file size of the OBO on Bioportal.
  - Also tried importing "hp-full.obo" but this caused an error with `ontologyIndex::get_OBO`.
  
## Bug fixes

* `load_phenotype_to_genes`:
  - Revamp to use releases from
  "https://github.com/obophenotype/human-phenotype-ontology/releases",
  which HPO now redirects to.
  - Use piggyback to download files.
* `test-get_ont_lvls`
  - New HPO has extra "GO:" terms. Omit them in tests.
* `example_phenos`
  - New HPO has extra "GO:" terms. Omit.

# HPOExplorer 0.99.10

## New features

* `load_phenotype_to_genes`
  - Update to use new annotation files.
* Switch terms:
  - "HPO_ID" --> "hpo_id"
  - "Phenotype" --> "hpo_name"
  - "FREQUENCY" --> "gene_freq"
  - "Onset" --> "onset"
  - "Modifier" --> "modifier"
  - "Aspect" --> "aspect"
  - "Gene" --> "gene_symbol"
  - "LinkID" --> "disease_id"
* Update all "data" objects.
* Update `hpo` object to "2023-06-17" release.

## Bug fixes

* `allow.cartesion` --> `allow.cartesian`
* Document all args.
* `add_onset`
  - Circumvent `Inf` warnings. 

# HPOExplorer 0.99.9

## New features

* `load_phenotype_to_genes`
  - Temporary fix while the HPO annotations are being fixed
    (they accidentally uploaded a version without the LinkIDs): 
      use old files which I've uploaded copies of to GitHub Releases.
* `get_gene_lengths`
  - Turn off seqnames filter when `keep_seqnames=NULL`.
* New function: `add_genes`
  - Extracted from `phenos_to_granges` code.
  
## Bug fixes

* `phenos_to_granges`
  - Make sure `phenotype_to_genes` is unique before.
  - Make sure there is only one gene length per gene symbol.
* `add_disease`
  - Make sure `annot <- load_phenotype_to_genes(3)` only has one 
    entry per hpo_id/disease_id combination.

# HPOExplorer 0.99.8

## New features

* HPO data
  - Update from Bioportal: 2023-04-05
  - Recreate HPO with `extract_tags = "everything"`. 
  - Now includes useful tags like `xref` to get HPO ID mappings 
    with other databases (MESH, SNOMED, UMLS). 
  - store in Releases via `piggyback` to reduce package size.
  
* MONDO data
  - Create updated ontology_index obj and store in Releases.
  - New func: `get_mondo`
  - Now includes useful tags like `xref` to get HPO ID mappings 
    with other databases (DOID, MESH, ICD9, GARD, EFO, SCTID, NCIT UMLS, Orphanet). 
* `get_data`
  - New internal support func to get `piggyback` data.
* `hpo_meta`
  - Remove as this information is now stored within new `hpo` tags:
    `hpo$def`, `hpo$xref`, etc.

## Bug fixes

* Update/simplify `HPOExplorer` vignette.

# HPOExplorer 0.99.7

## New features

* `prioritise_targets`
  - Move filtering steps and arg docs inside respective `HPOExplorer::add_*` functions.
* New funcs:
  - `add_ndisease`
  - `add_disease_definition`
  
## Bug fixes

* De-aggregate `add_*` functions so that everything occurs at the level 
  of "disease_id" + "hpo_id".
* Remove Roxygen links to `MultiEWCE`

# HPOExplorer 0.99.6

## New features

* New function for creating gene x phenotype matrix
  - `hpo_to_matrix`

## Bug fixes

* Add `R.utils` as Suggest.

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
    `map_phenotypes` output.
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
  - `map_phenotypes`
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
* `make_network_plot`: make interactive with `plotly`
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
