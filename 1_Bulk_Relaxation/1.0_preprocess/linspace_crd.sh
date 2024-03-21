#!/bin/bash

# Define the input file name and the pattern to search
input_file="pwrelax_322_addBr_Pb5.in"
upwards_pattern="! Moved Pb 13% upwards along the z-axis"
downwards_pattern="! New Br 13% downwards from the original Pb position"

# Define the range or array of new z-coordinate values
# Example: for a range from 0.5 to 0.6 in steps of 0.01
z_values=$(seq 0.530 0.001 0.550)
# strip the filename
filename=$(basename "$input_file" .in)

# Loop over the new z-coordinate values
for z in $z_values; do
    # z2 is 1-z
    new_z=$(echo "1 - $z" | bc)
    # z should have 15 decimal places
    z=$(printf "%.15f" $z)
    new_z=$(printf "%.15f" $new_z)
    # ratio is (z-0.5)/0.25, 4 decimal places
    ratio=$(printf "%.4f" "$(echo "($z - 0.5)*4" | bc)")
    # print z and new_z
    echo "z = $z"
    echo "ratio = $ratio"
    # if the file already exists, delete it
    if [[ -f "${filename}_${ratio}.in" ]]; then
        rm "${filename}_${ratio}.in"
    fi
    # Read the input file line by line and make the replacements
    while IFS= read -r line; do
        if [[ "$line" == *"$upwards_pattern"* ]]; then
            # Extract the first two coordinates (assuming they are separated by spaces)
            coords=($line)
            # Replace the third coordinate
            new_line="${coords[0]}   ${coords[1]}   ${coords[2]}   $z   ${coords[4]}"
            echo "$new_line" >> "${filename}_${ratio}.in"
        elif [[ "$line" == *"$downwards_pattern"* ]]; then
            coords=($line)
            # Replace the third coordinate
            new_line="${coords[0]}   ${coords[1]}   ${coords[2]}   $new_z   ${coords[4]}"
            echo "$new_line" >> "${filename}_${ratio}.in"
        else
            # Just write the line as is to the new file
            echo "$line" >> "${filename}_${ratio}.in"
        fi
    done < "$input_file"
    echo "Input file for z = $z created."
done

echo "Modified input files created."
