#!/bin/bash

# Prompt user for repository name
read -p "Enter the GCR repository name: " REPOSITORY_NAME
read -p "Enter the GCR sub-repository name: " SUBREPOSITORY_NAME

# Prompt user for age threshold in months
read -p "Enter the age threshold for images in months (e.g., 12 for 1 year): " AGE_THRESHOLD_MONTHS

# Calculate the date threshold
THRESHOLD_DATE=$(date -v-${AGE_THRESHOLD_MONTHS}m +%Y-%m-%d)

# Set project ID (modify if needed)
PROJECT_ID="development-236307"  # You can prompt for this too if necessary
# Print the images older than the threshold date
echo "Images older than $AGE_THRESHOLD_MONTHS months in gcr.io/$PROJECT_ID/$REPOSITORY_NAME/$SUBREPOSITORY_NAME:"
gcloud container images list-tags gcr.io/$PROJECT_ID/$REPOSITORY_NAME/$SUBREPOSITORY_NAME --format="table(digest,tags,timestamp)" --filter="TIMESTAMP.datetime < '$THRESHOLD_DATE'"

# Count images older than the threshold date
IMAGE_COUNT=$(gcloud container images list-tags gcr.io/$PROJECT_ID/$REPOSITORY_NAME/$SUBREPOSITORY_NAME --format="table(digest,tags)" --filter="TIMESTAMP.datetime < '$THRESHOLD_DATE'" | wc -l)

# Display the image count
echo "The number of images older than $AGE_THRESHOLD_MONTHS months in gcr.io/$PROJECT_ID/$REPOSITORY_NAME/$SUBREPOSITORY_NAME is: $IMAGE_COUNT"

# Ask for user confirmation before deletion
read -p "Do you want to proceed with deleting these images (y/N)? " -n 1 -r
REPLY=${REPLY:-N}  # Set default answer to 'N' if no input

IMAGES=$(gcloud container images list-tags gcr.io/$PROJECT_ID/$REPOSITORY_NAME/$SUBREPOSITORY_NAME --format='get(digest,timestamp.datetime)' --filter="timestamp.datetime < '$THRESHOLD_DATE'")
if [[ $REPLY =~ ^[Yy]$ ]]; then
  # Loop through each image and delete it
  while read -r IMAGE; do
      DIGEST=$(echo $IMAGE | awk '{print $1}')
      echo "Deleting image with digest $DIGEST"
      gcloud container images delete gcr.io/$PROJECT_ID/$REPOSITORY_NAME/$SUBREPOSITORY_NAME@$DIGEST --force-delete-tags --quiet
  done <<< "$IMAGES"
  echo "Deletion complete!"
else
  echo "Operation cancelled."
fi