#!/bin/bash

# File to store the current version
VERSION_FILE="version.txt"

# Check if the version file exists
if [ ! -f "$VERSION_FILE" ]; then
  # If not, create it with the default version (1.0)
  echo "1.0" > "$VERSION_FILE"
fi

# Read the current version from the file
CURRENT_VERSION=$(cat "$VERSION_FILE")

# Extract the major and minor parts of the version
MAJOR=${CURRENT_VERSION%.*}
MINOR=${CURRENT_VERSION#*.}

# Increment the minor version
((MINOR++))

# If the minor version reaches 10, reset it and increment the major version
if [ "$MINOR" -ge 10 ]; then
  MINOR=0
  ((MAJOR++))
fi

# Create the new version
NEW_VERSION="$MAJOR.$MINOR"

# Update the version file
echo "$NEW_VERSION" > "$VERSION_FILE"

# Display the new version
echo "$NEW_VERSION"
