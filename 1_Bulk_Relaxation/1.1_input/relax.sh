#!/bin/bash -l
#SBATCH --job-name=bulk
#SBATCH --time=24:0:0
#SBATCH --nodes=3
# number of tasks (processes) per node
#SBATCH --ntasks-per-node=48
#SBATCH --mail-type=end
#SBATCH --mail-user=userid@jhu.edu 
ml intel intel-mpi intel-mkl

ml qe/7.2
files=(ls pwrelax_addBr_0.10*.in)

files="pwrelax_addBr_Pb2_0.54*.in"
dir_path='./'

today=$(date +%m%d)

# Loop over files matching the pattern
for file in .in; do
    # if the output file already exists, skip this file

    if [[ -f "$file" ]]; then
        filename=$(basename "${file}" .in)
        if [[ -f "${dir_path}${filename}_${today}.out" ]]; then
            continue
        fi  

        mpirun pw.x < "$file" > "${filename}_${today}.out"
    fi
done