#!/bin/bash

# Check if an argument was provided
if [ $# -eq 0 ]; then
    echo "Usage: $0 <directory>"
    exit 1
fi

# Directory containing the FLAC files
DIR=$1

# Loop through all FLAC files in the directory
for flac in "$DIR"/*.flac; do
    # Skip if directory is empty
    [ -e "$flac" ] || continue

    # Construct WAV filename by replacing FLAC extension with WAV. This ensures the output WAV is saved in DIR.
    wav="${flac%.flac}.wav"

    # Convert FLAC to WAV using ffmpeg
    ffmpeg -i "$flac" -acodec pcm_s16le -ar 44100 "$wav"

    echo "Converted $flac to $wav"
done

echo "All FLAC files have been converted to WAV."
