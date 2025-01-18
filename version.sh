#!/bin/bash

# Path to the version.txt file
VERSION_FILE="version.txt"

# Read the current version from the version.txt file (assuming it's in "MAJOR.MINOR" format)
if [[ -f "$VERSION_FILE" ]]; then
    VERSION=$(<"$VERSION_FILE")
else
    VERSION="0.9"  # Default if version.txt is empty or missing
fi

# Split the version into MAJOR and MINOR parts
MAJOR=$(echo "$VERSION" | cut -d '.' -f 1)
MINOR=$(echo "$VERSION" | cut -d '.' -f 2)

# Increment version
if [[ "$MINOR" -ge 9 ]]; then
    MAJOR=$((MAJOR + 1))
    MINOR=0
else
    MINOR=$((MINOR + 1))
fi

NEW_VERSION="$MAJOR.$MINOR"

# Update the version.txt file
echo "$NEW_VERSION" > "$VERSION_FILE"

# Stage and commit any existing changes to avoid conflicts
git add .
git commit -m "WIP: Commit changes before switching branches" || true

# Ensure Git is in sync with the remote repository
git fetch origin
git checkout main
git pull origin main

# Stage, commit, and push the new version
git add "$VERSION_FILE"
git commit -m "Update version to $NEW_VERSION"
git push origin main

# Output the new version for Jenkins
echo "$NEW_VERSION"
