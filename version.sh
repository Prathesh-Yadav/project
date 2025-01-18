#!/bin/bash

# Set the path for version.txt
VERSION_FILE="version.txt"

# Read the current version or set default
if [[ -f "$VERSION_FILE" ]]; then
    VERSION=$(<"$VERSION_FILE")
else
    VERSION="0.9"
fi

# Increment the version
MAJOR=$(echo "$VERSION" | cut -d '.' -f 1)
MINOR=$(echo "$VERSION" | cut -d '.' -f 2)
if [[ "$MINOR" -ge 9 ]]; then
    MAJOR=$((MAJOR + 1))
    MINOR=0
else
    MINOR=$((MINOR + 1))
fi
NEW_VERSION="$MAJOR.$MINOR"

# Update the version file
echo "$NEW_VERSION" > "$VERSION_FILE"

# Configure Git credentials
git config user.name "$GIT_USERNAME"
git config user.password "$GIT_PASSWORD"

# Ensure changes are committed before switching branches
git add .
git commit -m "WIP: Commit changes before switching branches" || true

# Fetch and update the branch
git fetch origin
git checkout main
git pull origin main

# Commit and push the version update
git add "$VERSION_FILE"
git commit -m "Update version to $NEW_VERSION" || true
git push https://"$GIT_USERNAME":"$GIT_PASSWORD"@github.com/Prathesh-Yadav/project.git main

# Output the new version
echo "$NEW_VERSION"
