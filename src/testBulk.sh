#!/bin/bash

# Check if directory is provided
if [ -z "$1" ]; then
    echo "Usage: $0 directory_path"
    exit 1
fi

# Output file for saving results
output_file="output_table.txt"
echo "song | our bpm | bpm-tool's bpm" > "$output_file"

# Check if the output file exists, if not, create it with headers
if [ ! -f "$output_file" ]; then
    echo "song | bpm |" > "$output_file"
fi

# Iterate through each file in the directory
for file in "$1"/*; do
    if [ -f "$file" ]; then
        echo "Processing file: $file"
        
        # Execute the Octave script with the file as an argument
        octave_output=$(octave main.m "$(realpath "$file")")
        
        # Extract the song name from the file path
        song=$(basename "$file")
        
        # Extract the bpm from the Octave output
        our_bpm=$(echo "$octave_output" | awk '/BPM:/ {print $3}')
        
        # Extract the real bpm from the file
        tool_bpm=$(sox $(realpath "$file") -t raw -r 44100 -e float -c 1 - | bpm)

        # Append the result to the output file
        echo "$song | $our_bpm | $tool_bpm" >> "$output_file"
        
        echo "Processed file: $song | Our BPM: $our_bpm | bpm-tool's BPM: $tool_bpm"
        echo "----------------------------------"
    else
        echo "Not a file: $file"
    fi
done

# Calculate and print averages, medians, and percent differences
awk -F ' | ' '
    NR>1 {
        our_sum+=$3; 
        tool_sum+=$5; 
        our_array[NR-2]=$3; 
        tool_array[NR-2]=$5; 
        diff_percent[NR-2]=($3-$5)/$5*100;
    } 
    END {
        asort(our_array); 
        asort(tool_array); 
        asort(diff_percent);
        N=NR-1;
        print "Average Our BPM: " (our_sum/N);
        print "Average Tool BPM: " (tool_sum/N);
        if (N % 2 == 1) { 
            median_our=our_array[(N+1)/2]; 
            median_tool=tool_array[(N+1)/2]; 
            median_diff=diff_percent[(N+1)/2];
        } else { 
            median_our=(our_array[(N/2)]+our_array[(N/2)+1])/2; 
            median_tool=(tool_array[(N/2)]+tool_array[(N/2)+1])/2;
            median_diff=(diff_percent[(N/2)]+diff_percent[(N/2)+1])/2;
        }
        print "Median Our BPM: " median_our;
        print "Median Tool BPM: " median_tool;
        print "Median Percent Difference: " median_diff "%";
    }' "$output_file"
