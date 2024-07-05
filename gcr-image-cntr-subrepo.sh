#!/bin/bash

# Prompt user for repository name
read -p "Enter the GCR repository name: " REPOSITORY_NAME

# Prompt user for age threshold in months (informational only)
read -p "Enter the age threshold for images in months: " AGE_THRESHOLD_MONTHS

# Calculate the date threshold (informational only)
THRESHOLD_DATE=$(date -v-${AGE_THRESHOLD_MONTHS}m +%Y-%m-%d)

# Set project ID (modify if needed)
PROJECT_ID="development-236307"  # You can prompt for this too if necessary

# Function to count images recursively in a repository and its sub-repositories
count_images_recursively () {
  local REPOSITORY="$1"
  local THRESHOLD_DATE="$2"

  # Count images in the current repository
  local IMAGE_COUNT=$(gcloud container images list-tags gcr.io/$PROJECT_ID/$REPOSITORY --format="table(digest,tags)" --filter="TIMESTAMP.datetime < '$THRESHOLD_DATE'" | wc -l)

  # Capture list of tags in a variable (avoiding pipes)
  local TAGS=$(gcloud container images list-tags gcr.io/$PROJECT_ID/$REPOSITORY --format="value(tags)")

  # Extract sub-repositories using grep (within the function)
  local SUB_REPOS=($(echo "$TAGS" | grep -v "latest" | grep -E "^v[0-9]+\.[0-9]+$"))

  # Recursively count images in sub-repositories
  for SUB_REPO in "${SUB_REPOS[@]}"; do
    count_images_recursively "$REPOSITORY/$SUB_REPO" "$THRESHOLD_DATE"
  done

  # Print the count for the current repository
  echo "The number of images in gcr.io/$PROJECT_ID/$REPOSITORY older than $AGE_THRESHOLD_MONTHS months is: $IMAGE_COUNT"
}

# Call the recursive function to count images
count_images_recursively "$REPOSITORY_NAME" "$THRESHOLD_DATE"