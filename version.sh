#!/bin/bash

# File to store the current version
VERSION_FILE="version.txt"

# Default version if the file doesn't exist
DEFAULT_VERSION="1.0"

# Fetch the latest tag from git (if exists)
LATEST_TAG=$(git describe --tags --abbrev=0 2>/dev/null)

# If no tag is found, assign the default version
if [ -z "$LATEST_TAG" ]; then
  newtag="$DEFAULT_VERSION"
else
  # Extract the major and minor parts of the version
  CURRENT_VERSION="$LATEST_TAG"
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
  newtag="$MAJOR.$MINOR"
fi

# Update the version file with the new tag
echo "$newtag" > "$VERSION_FILE"

# Display the new tag
echo "New tag: $newtag"
