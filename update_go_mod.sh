#!/bin/bash

# Description:
# This script searches for "github.com/dell/dell-csi-extensions/common v1.7.0"
# in all go.mod files within the repository, replaces it with "github.com/dell/dell-csi-extensions/common v1.6.0",
# and then runs 'go mod tidy' for all the directories where changes were made.

# Search for directories containing 'go.mod' files with the specific dependency
directories=$(grep -rl "github.com/dell/dell-csi-extensions/common v1.7.0" --include="go.mod" .)

# Check and inform if no matching files are found
if [ -z "$directories" ]; then
  echo "No 'go.mod' files found with 'github.com/dell/dell-csi-extensions/common v1.7.0'."
  exit 0
fi

# Loop through each directory and make the necessary changes
while IFS= read -r go_mod_file; do
  dir=$(dirname "$go_mod_file")
  echo "Processing directory: $dir"

  # Replace the dependency version
  sed -i.bak 's|github.com/dell/dell-csi-extensions/common v1.7.0|github.com/dell/dell-csi-extensions/common v1.6.0|g' "$go_mod_file"
  
  # Run 'go mod tidy' in the modified directory
  (cd "$dir" && go mod tidy)
  
  # Remove the backup file created by sed
  rm "$go_mod_file.bak"
done <<< "$directories"

echo "Update completed successfully."