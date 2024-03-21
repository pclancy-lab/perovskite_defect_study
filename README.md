# perovskite_defect_study

This project involves the computational investigation of the CsPbBr3 crystal, focusing on the relaxation of the bulk crystal, the introduction and relaxation of Br interstitials, the introduction of vacancies, and the calculation of activation energy using the Nudged Elastic Band (NEB) method.

## Pipeline (Standard Operating Procedure)

### 1. Relaxation of Bulk Crystal (CsPbBr3)

#### a. Preparation

Set up the initial structure of CsPbBr3 in the Quantum ESPRESSO input format.
1. The smaller supercell (2*1*1) is used for the early stage testing, and also for the following NEB calculation (, which is proved to be with almost the same accuracy as the larger supercell).
2. The larger supercell is created to further aviod the defect-defect interaction between the unit cells.

#### b. Calculation
Perform a relaxation calculation (`vc-relax`) to find the optimized lattice parameters and atomic positions.

#### c. Output & Verification

Check the convergence and stability of the relaxed structure. Save the optimized coordinates and cell parameters for the next step.

### 2. Introduction of Br Interstitial

#### a. Preparation

Based on the relaxed structure from step 1, introduce a Br interstitial near the center of the unit cell, sharing a site with a Pb atom.
1. The unit cell 
2. Use `pw.x` to relax the structure with the Br interstitial which is similar to the relaxation of the bulk, but using the "`relax`" calculation mode instead of "`vc-relax`", fixing the cell parameters that calculated in the 
3. We also perform the "`vc-relax`" of the interstitial to test the sensitivity of the results in terms of cell parameters.

#### b. Output & Analysis
Calculate the defect formation energy (DFE) based on the total energies of the relaxed structures. 
The equation for DFE calculation is as follows.[^1].

$$
E^f(D^q) = E(D^q) - E_{\text{bulk}} - \sum_i \Delta n_i \mu_i + q(E_V + E_F) + E_{\text{corr}}
$$

where $E^f(D^q)$ is the total energy of the supercell containing the defect $D$ in the charge state $q$, and $E_{\text{bulk}}$ is the total energy of the pristine bulk supercell. $\Delta n_i$ is the number of atoms of species $i$ added to ($\Delta n_i > 0$) or removed from ($\Delta n_i < 0$) the supercell as a result of forming the defect, and $\mu_i = \mu_i^{\text{bulk}} + \Delta \mu_i$ is the chemical potential of element species $i$. For charged defects, the formation energy also contains a contribution from the chemical potential of the electrons, also known as the Fermi level, $E_F$. The Fermi level of a semiconductor is treated as an independent variable that can assume any value within the bandgap, and it is referenced to $E_V$, the valence band maximum (VBM) of the bulk material. The correction term, $E_{\text{corr}}$, takes into account the errors introduced by finite size effects and the periodic boundary conditions, such as spurious overlaps of neighboring defect wave functions and, in the case of charged defects, Coulomb interactions between image charges.

We can further simplify the general equation to fit into the specific systems:
1. For the Pb-Br neutral interstitial system, $\Delta n_i = 1$, and the equation is simplified to:

$$
E^f(D^q) = E(D^q) - E_{\text{bulk}} - \sum_i \Delta n_i \mu_i + E_{\text{corr}}
$$

2. For the Br interstitial-vacancy recombination system, the net change of the Br atom is 0, which further simplifies the equation to:

$$
E^f(D^q) = E(D^q) - E_{\text{bulk}} + E_{\text{corr}},
$$


### 3. Introduction of Vacancy

#### a. Preparation
Introduce a vacancy in the unit cell generated in step 3.

#### b. Setup
Create a new input file for the structure with the vacancy.

### 5. NEB Pathway Design and Calculation

#### a. Pathway Design
Design the initial and final states for the NEB calculation, ensuring a reasonable pathway for the migration of the defect.

#### b. NEB Calculation
Run `neb.x` to calculate the activation energy along the designed pathway.

#### c. Output & Analysis
Analyze the NEB results to determine the activation energy and the transition state geometry.

## Folder Structure

The project is organized into the following directories:

- `1_Bulk_Relaxation/`: Contains input and output files for the relaxation of bulk CsPbBr3.
- `2_Br_Interstitial/`: Contains input and output files for the introduction of Br interstitial.
- `3_Interstitial_Relaxation/`: Contains input and output files for the relaxation of the interstitial structure.
- `4_Vacancy_Introduction/`: Contains input and output files for the introduction of vacancy.
- `5_NEB_Pathway/`: Contains input and output files for the NEB pathway design and calculation.

Each directory contains a `README.md` file describing the specifics of the calculations performed, including the purpose, the main parameters, and any special considerations or observations.

## Usage

Please refer to the README files in each directory for instructions on how to run the calculations and analyze the results.


## Contact

- Kumar Purshottam Miskin kmiskin1@jhu.edu
- Yi Cao @alinacao2000 ycao73@jh.edu

## References
[^1]: Jingyang Wang, Binit Lukose, Michael O. Thompson, Paulette Clancy; Ab initio modeling of vacancies, antisites, and Si dopants in ordered InGaAs. J. Appl. Phys. 28 January 2017; 121 (4): 045106. https://doi.org/10.1063/1.4974949
