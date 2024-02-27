#!/bin/bash

# Check if an argument was provided
if [ $# -eq 0 ]; then
    echo "Usage: $0 <directory>"
    exit 1
fi

# Directory containing the WAV files
DIR=$1

# Loop through all WAV files in the directory
for wav in "$DIR"/*.wav; do
    # Skip if directory is empty
    [ -e "$wav" ] || continue

    # Extract filename and extension
    filename=$(basename -- "$wav")
    extension="${filename##*.}"
    filename="${filename%.*}"

    # Run ffmpeg command to cut the first 30 seconds
    ffmpeg -i "$wav" -ss 00:00:00 -t 00:00:30 -acodec pcm_s16le -ar 44100 -ac 2 "${DIR}/${filename}_cut.wav"

    echo "Cut $wav successfully."
done

echo "All WAV files have been cut."
