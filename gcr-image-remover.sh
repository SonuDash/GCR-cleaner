!/bin/bash

# Set the project ID and repository name
PROJECT_ID="development-236307"
REPOSITORY_NAME="accounts"

# Set the age threshold in months
AGE_THRESHOLD_MONTHS=36

# Calculate the date threshold
THRESHOLD_DATE=$(date -v-${AGE_THRESHOLD_MONTHS}m +%Y-%m-%d)

# List images older than the threshold date
IMAGES=$(gcloud container images list-tags gcr.io/$PROJECT_ID/$REPOSITORY_NAME --format='get(digest,timestamp.datetime)' --filter="timestamp.datetime < '$THRESHOLD_DATE'")

# Loop through each image and delete it
while read -r IMAGE; do
    DIGEST=$(echo $IMAGE | awk '{print $1}')
    echo "Deleting image with digest $DIGEST"
    gcloud container images delete gcr.io/$PROJECT_ID/$REPOSITORY_NAME@$DIGEST --force-delete-tags --quiet
done <<< "$IMAGES"