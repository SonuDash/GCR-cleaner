# Final variation of image-counter.sh

#!/bin/bash

# Prompt user for repository name
read -p "Enter the GCR repository name: " REPOSITORY_NAME

# Prompt user for age threshold in months (informational only)
read -p "Enter the age threshold for images in months: " AGE_THRESHOLD_MONTHS

# Calculate the date threshold (informational only)
THRESHOLD_DATE=$(date -v-${AGE_THRESHOLD_MONTHS}m +%Y-%m-%d)

# Set project ID (modify if needed)
PROJECT_ID="development-236307"  # You can prompt for this too if necessary

# Count images older than the threshold date (or all images)
IMAGE_COUNT=$(gcloud container images list-tags gcr.io/$PROJECT_ID/$REPOSITORY_NAME --format="table(digest,tags)" --filter="TIMESTAMP.datetime < '$THRESHOLD_DATE'" | wc -l)

# Display the image count
echo "The number of images in gcr.io/$PROJECT_ID/$REPOSITORY_NAME is: $IMAGE_COUNT"
