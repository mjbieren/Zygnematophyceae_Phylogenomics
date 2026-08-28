# Zygnematophyceae Phylogenomics — Dataset

This repository provides an overview of the tools, scripts, and workflows used in the **Zygnematophyceae Phylogenomics Project**.

> ⚠️ **Note:** This repository does **not** contain the raw sequencing data used in the study (with minor exceptions). The associated datasets are publicly available via **Zenodo**:  
> 👉 https://doi.org/10.5281/zenodo.18392035

---

## 🧬 Workflow Overview

![Pipeline Diagram](Sources/Images/PhyloRSeqpp_Flow_1000.png?raw=true "Pipeline")

The image above illustrates the computational pipeline used for transcriptome assembly, quality control, protein prediction, decontamination, orthology inference, alignment, and phylogenomic analysis.

---

## 📘 Introduction

This repository documents the pipeline used for the **Zygnematophyceae Phylogenomics Project**, from RNA-Seq data acquisition and transcriptome assembly to orthology inference and phylogenetic reconstruction.

The dataset combines newly generated transcriptomic data with publicly available sequencing data to provide broad representation across the Zygnematophyceae.

---

# Step 0: RNA-Seq Data Acquisition

RNA-Seq data used in this project originated from two principal sources:

- **Publicly available datasets**, including sequencing data obtained from the NCBI Sequence Read Archive (SRA)
- **In-house generated RNA-Seq libraries** from selected Zygnematophyceae strains

The corresponding transcriptomic datasets and associated files are deposited on **Zenodo** under DOI **10.5281/zenodo.18392035**.

---

## 🧫 In-House Strain Cultivation

Cultures were maintained for six weeks in either **3NBBM** or **MiEB12** liquid medium, corresponding to medium 26a and medium 7, respectively, as described by Schlösser.

Cultures were maintained under standardized laboratory conditions:

- **Temperature:** 18 °C
- **Light cycle:** 14 h light / 10 h dark
- **Light intensity:** 25–35 µmol photons m<sup>−2</sup> s<sup>−1</sup>
- **Lighting:** Full-spectrum fluorescent lamps
- **Cultivation period:** 6 weeks

---

## 🔬 Light Microscopy

High-resolution light-microscopy images of the investigated strains were obtained after six weeks of cultivation.

Samples were examined using an **Olympus BX-60 microscope** (Olympus, Japan) equipped with differential interference contrast (**DIC**) optics.

Images were captured using a **ProgRes C14plus camera** and **ProgRes CapturePro Software v2.9.01** (JENOPTIK AG, Jena, Germany).

---

## 🧪 RNA Extraction

After six weeks of cultivation, RNA was extracted as follows:

1. **Harvesting**
   - 50 mL of liquid culture was centrifuged for **5 min at 20 °C and 11,000 rpm**.
   - The supernatant was removed.

2. **Cell disruption**
   - Pellets were transferred into **1.5 mL BioMasher II tubes** (Nippi, Japan).
   - Samples were frozen in **liquid nitrogen**.
   - Frozen material was disrupted using a **PowerMasher II** (Nippi, Japan).

3. **RNA extraction**
   - Total RNA was extracted using the **Spectrum™ Plant Total RNA Kit** (Sigma-Aldrich Chemie GmbH, Germany), according to the manufacturer's instructions.
   - RNA samples were treated with **DNase I** (Thermo Fisher Scientific, Waltham, MA, USA) to remove residual genomic DNA.

4. **Quality assessment**
   - RNA integrity was assessed using a **1% agarose gel stained with Midori Green**.
   - RNA concentration was determined using a **NanoDrop spectrophotometer** (Thermo Fisher Scientific).

5. **Sample shipment**
   - RNA samples were shipped on **dry ice** to **Novogene (Munich, Germany)** for library preparation and sequencing.

---

## 🧬 Library Preparation & Sequencing

At Novogene:

- RNA quality was re-evaluated using a **Bioanalyzer** (Agilent Technologies).
- mRNA libraries were prepared using **poly(A) enrichment**.
- **Strand-specific (directional)** libraries were generated.
- Sequencing was performed using the **Illumina NovaSeq 6000** platform with dual-index adapters.

### Adapter Sequences

**Read 1 Adapter**

`5’-AGATCGGAAGAGCGTCGTGTAGGGAAAGAGTGTAGATCTCGGTGGTCGCCGTATCATT-3’`

**Read 2 Adapter**

`5’-GATCGGAAGAGCACACGTCTGAACTCCAGTCACGGATGACTATCTCGTATGCCGTCTTCTGCTTG-3’`

---

# Step 1: FastQC & MultiQC

[FastQC](https://github.com/s-andrews/FastQC) was used for initial quality control of both newly generated and publicly available RNA-Seq datasets. Samples showing insufficient sequencing quality were excluded from subsequent analyses.

[MultiQC](https://multiqc.info/) was used to summarize quality-control results across the complete dataset.

For more information on the FastQC workflow used in this project, see the `01_FASTQC` directory.

---

# Step 2: Trinity *de novo* Assembly

Following quality control, RNA-Seq datasets without an existing suitable transcriptome assembly were assembled *de novo* using [Trinity](https://github.com/trinityrnaseq/trinityrnaseq).

Adapters and low-quality sequence were removed using Trimmomatic with the following parameters:

```text
ILLUMINACLIP:novogene_adapter_sequences.fa:2:30:10:2:keepBothReads LEADING:3 TRAILING:3 MINLEN:36
```

Trinity assemblies of the in-house generated strand-specific libraries were generated using:

```bash
Trinity \
  --seqType fq \
  --left [LEFT_READS] \
  --right [RIGHT_READS] \
  --output [OUTPUT_FOLDER] \
  --SS_lib_type RF \
  --CPU 48 \
  --trimmomatic \
  --full_cleanup \
  --max_memory 350G \
  --quality_trimming_params "ILLUMINACLIP:novogene_adapter_sequences.fa:2:30:10:2:keepBothReads LEADING:3 TRAILING:3 MINLEN:36"
```

For additional information on Trinity and its available parameters, see the [Trinity documentation](https://github.com/trinityrnaseq/trinityrnaseq/wiki).

Detailed scripts and commands used for this project are provided in `02_Trinity`.

---

# Subsequent Phylogenomic Workflow

Following transcriptome assembly, the Zygnematophyceae dataset was processed through the same general phylogenomic framework documented in this repository:

1. **SuperTranscript generation**
2. **BUSCO completeness assessment**
3. **Protein prediction with TransDecoder**
4. **Post-prediction BUSCO assessment**
5. **Protein-set decontamination**
6. **Post-decontamination BUSCO assessment**
7. **Orthogroup inference with OrthoFinder**
8. **Orthogroup sequence extraction**
9. **Multiple sequence alignment and gene-tree inference**
10. **Paralog identification and pruning with PhyloPyPruner**
11. **Orthogroup filtering and dataset combination**
12. **PREQUAL, MAFFT and ClipKIT alignment processing**
13. **Concatenation of single-copy ortholog alignments**
14. **Phylogenetic inference with IQ-TREE**
15. **Tree visualization and annotation with iTOL**

Project-specific parameters, taxonomic thresholds, reference datasets and filtering criteria are documented within the corresponding workflow directories and should be consulted rather than assumed to be identical to those used for other phylogenomic datasets.

---

# Data Availability

The datasets associated with the Zygnematophyceae phylogenomic analyses are available through Zenodo:

**Bierenbroodspot et al. — Zygnematophyceae dataset**  
**DOI:** 10.5281/zenodo.18392035

The repository primarily contains scripts, configuration files, workflow documentation and supporting material required to reproduce the computational analyses.

---

# Notes for Future Development

I plan to further develop this workflow into a fully integrated C++ phylogenomics pipeline.

The long-term goal is to provide RNA-Seq data, associated sample information and a guide tree as input and allow the software to handle the subsequent processing and phylogenomic workflow with minimal manual intervention.

This would make the workflow more accessible to researchers without extensive bioinformatics experience while retaining support for execution on either:

- a **High-Performance Computing (HPC) cluster**, or
- a **single high-performance workstation**.
