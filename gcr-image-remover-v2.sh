#!/bin/bash

# Prompt user for repository name
read -p "Enter the GCR repository name: " REPOSITORY_NAME

# Prompt user for age threshold in months
read -p "Enter the age threshold for images in months (e.g., 12 for 1 year): " AGE_THRESHOLD_MONTHS

# Calculate the date threshold
THRESHOLD_DATE=$(date -v-${AGE_THRESHOLD_MONTHS}m +%Y-%m-%d)

# Set project ID (modify if needed)
PROJECT_ID="development-236307"  # You can prompt for this too if necessary

# List images older than the threshold date
IMAGES=$(gcloud container images list-tags gcr.io/$PROJECT_ID/$REPOSITORY_NAME --format='get(digest,timestamp.datetime)' --filter="timestamp.datetime < '$THRESHOLD_DATE'")

# Loop through each image and delete it
while read -r IMAGE; do
    DIGEST=$(echo $IMAGE | awk '{print $1}')
    echo "Deleting image with digest $DIGEST"
    gcloud container images delete gcr.io/$PROJECT_ID/$REPOSITORY_NAME@$DIGEST --force-delete-tags --quiet
done <<< "$IMAGES"

