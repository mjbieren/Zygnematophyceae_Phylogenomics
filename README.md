# A deep genetic structure phylogenomically frames the closest algal relatives of land plants — reproducibility repository

This repository contains scripts, workflow notes, and taxon bookkeeping for the **Zygnematophyceae phylogenomics project**.

The manuscript reports **43 newly generated transcriptome datasets**, a phylogenomic sampling of **104 Zygnematophyceae**, and a final phylogenomic matrix of **2,243 loci**. The broader tree additionally includes other streptophyte algae, land plants, and chlorophyte outgroups.

> **Data location:** analytical outputs are associated with Zenodo DOI `10.5281/zenodo.18392035` in the manuscript. Raw sequence data are not duplicated in this GitHub repository.
>
> **Important manuscript note:** the supplied manuscript is a tracked/working version and still contains a few legacy Coleochaetophyceae phrases and conflicting version/count edits in the Methods. This repository therefore keeps uncertain settings as explicit placeholders instead of silently inventing a value.

## Workflow

The repository follows the same numbered organization as the companion Coleochaetophyceae repository:

| Step | Analysis | Main tool(s) |
|---|---|---|
| 01 | Read quality control | FastQC / MultiQC |
| 02 | de novo transcriptome assembly | Trinity + Trimmomatic |
| 03 | SuperTranscript construction | Trinity gene splice modeler |
| 04 | BUSCO I | BUSCO (transcriptome mode) |
| 05 | Protein prediction | TransDecoder |
| 06 | BUSCO II | BUSCO (protein mode) |
| 07 | Decontamination | MMseqs2 + GPDS |
| 08 | BUSCO III | BUSCO (post-decontamination proteins) |
| 09 | Orthogroup inference | OrthoFinder |
| 10 | Orthogroup selection | OSG |
| 11 | Alignment / gene-tree workflow | MIAF |
| 12 | PhyloPyPruner formatting | ApplyPPPFormat |
| 13 | Paralog pruning | PhyloPyPruner |
| 14 | Filter pruned orthologs | FilterPPPResult |
| 15 | COGS | COGS |
| 16–18 | Re-pruning / filtering / PREQUAL | PhyloPyPruner, PREQUAL, ClipKIT |
| 19 | Concatenation | phyx (`pxcat`) |
| 20 | Final phylogeny | IQ-TREE / ModelFinder / PMSF |
| 21 | Tree visualization | iTOL |
| 22 | Molecular clock | PAML / MCMCTree |
| 23 | Topology tests | IQ-TREE AU tests |
| 24 | Ancestral character analyses | R / ape / phytools (project-specific inputs required) |
| 25 | Optional expression / gene-family utilities | Trinity / project utilities |

## Key manuscript-level settings

### Assembly and protein prediction

Transcriptomes were assembled de novo with Trinity after Trimmomatic adapter/quality trimming. Splicing isoforms were collapsed into SuperTranscripts. Protein-coding sequences were predicted with **TransDecoder v5.5.0** using `--single_best_only`.

### BUSCO

For exact paper reproduction, the working manuscript describes **BUSCO v5.4.3 with `eukaryota_odb10`**. The scripts in `04_BUSCO_I`, `06_BUSCO_II`, and `08_BUSCO_III` therefore default to that lineage. If BUSCO is being rerun for a new quality assessment rather than exact reproduction, a newer lineage such as `viridiplantae_odb12` may be selected explicitly.

### Decontamination

The workflow uses MMseqs2 followed by GPDS. The manuscript gives the MMseqs2 search settings:

```text
--start-sens 1 --sens-steps 3 -s 7 --alignment-mode 3 --max-seqs 10
```

The supplied manuscript still contains a legacy Coleochaetophyceae positive-reference description in this paragraph. Consequently, the Zygnematophyceae decontamination script uses a configurable database/header path rather than hard-coding an unsupported positive reference.

### OrthoFinder and orthogroup selection

The workflow uses the root **Phylogenetic Hierarchical Orthogroups (`N0.tsv`)** from OrthoFinder with OSG. The exact guide tree used in the analysis is not reconstructable from the manuscript text alone; a placeholder note is provided under `Scripts/09_OrthoFinder/` rather than an invented tree.

### Alignment, paralog pruning, and final phylogeny

The manuscript describes MAFFT/IQ-TREE gene-tree construction, PhyloPyPruner paralog removal, a streamlined COGS workflow, PREQUAL-based filtering, concatenation, and a final site-heterogeneous IQ-TREE analysis. The final manuscript tree contains **2,243 loci** and uses an **LG+C60** guide analysis followed by **PMSF (`LG+C60+F+G-PMSF`)**.

## Taxon bookkeeping

`Sources/Taxa/REFERENCE_TAXA_126.txt` contains the 126 input labels from the working analysis list supplied for this repository. The manuscript describes 104 Zygnematophyceae plus 21 non-Zygnematophyceae taxa (=125 biological taxa); the working OrthoFinder file set contains 126 input files because *Spirogloea muscicola* CCAC0214 occurs as two source-specific protein datasets (`oneKP` and `Cheng`). See `Sources/Taxa/README.md`.

## Repository scope

This repository is intended as a **methodological/code overview**, not as an archive of large sequencing or intermediate-result files. Paths in shell scripts are deliberately exposed as variables and must be adapted to the local HPC/workstation environment.

## Citation

Please cite the associated Zygnematophyceae manuscript and the individual software packages used in each step. A final publication citation can be inserted here once available.

## Contact

Maaike J. Bierenbroodspot
