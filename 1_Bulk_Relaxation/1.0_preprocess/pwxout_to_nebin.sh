#!/bin/bash

# Multiple

# This script extracts the atomic positions from the pw.x output files
# and inserts them into the neb input files
# The original neb input file is needed, which is copied to a series of new files
# output file name: neb_${base_name}_i_16.in, where base_name is the name of the pw.x output file
# Note: this only change the first image, and last image is fixed to the bulk structure

# Directory where your output files are located
dir_path="./"
txt_dir="txt"
neb_dir="nebin"
mkdir -p "$txt_dir"

# Loop through all files in the directory that match the pattern
for file in ${dir_path}pw_Br_i16__without_Br_*.out; do
    if [[ -f "$file" ]]; then
        # Extract filename without extension
        base_name=$(basename "$file" .out)
        # Use sed to extract the content after the line contains "End of BFGS Geometry Optimization"
        content=$(sed -n '/End of BFGS Geometry Optimization/,$p' "$file")
        # Use sed to extract the content after "ATOMIC_POSITIONS (crystal)" until the first blank line
        atom_positions=$(echo "$content" | sed -n '/ATOMIC_POSITIONS (crystal)/,/^$/p')
        
        #if the txt file already exists, delete it
        if [[ -f "${txt_dir}/${base_name}_pos.txt" ]]; then
            rm "${txt_dir}/${base_name}_pos.txt"
        fi
        # Save the atom positions to a file
        echo "$atom_positions" > "${txt_dir}/${base_name}_pos.txt"

        # copy the original neb file to a new file
        cp "${neb_dir}/neb_Br_i_16.in" "${neb_dir}/neb_${base_name}_i_16.in"

        # Delete old atomic positions of first image
        sed -i "/FIRST_IMAGE/,/LAST_IMAGE/{//!d}" "${neb_dir}/neb_${base_name}_i_16.in"

        # Insert new atomic positions after FIRST_IMAGE form the new_neb_dir directory
        sed -i "/FIRST_IMAGE/r ${txt_dir}/${base_name}_pos.txt" "${neb_dir}/neb_${base_name}_i_16.in"
    fi
done

echo "Extraction complete."
