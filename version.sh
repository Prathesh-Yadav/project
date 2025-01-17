#!/bin/bash

# Path to the version.txt file
VERSION_FILE="version.txt"

# Read the current version from the version.txt file (assuming it's in "MAJOR.MINOR" format)
if [[ -f "$VERSION_FILE" ]]; then
    VERSION=$(cat "$VERSION_FILE")
else
    VERSION="0.9"  # Default if version.txt is empty or missing
fi

# Split the version into MAJOR and MINOR parts
MAJOR=$(echo "$VERSION" | cut -d '.' -f 1)
MINOR=$(echo "$VERSION" | cut -d '.' -f 2)

# Check if MINOR is 9, then increment MAJOR and reset MINOR to 0
if [ "$MINOR" -ge 9 ]; then
    MAJOR=$((MAJOR + 1))  # Increment MAJOR
    MINOR=0               # Reset MINOR to 0
else
    MINOR=$((MINOR + 1))  # Otherwise, just increment MINOR
fi

# Create the new version (MAJOR.MINOR)
NEW_VERSION="$MAJOR.$MINOR"

# Update the version.txt file with the new version
echo "$NEW_VERSION" > "$VERSION_FILE"

# Check if the file was updated successfully
cat "$VERSION_FILE"

# Return only the version for Jenkins pipeline usage
echo "$NEW_VERSION"
