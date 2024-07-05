#!/bin/bash

# Set threshold for image age in days (365 days for a year)
THRESHOLD_DAYS=365

# Get all images with tags and their creation timestamps
gcloud container images list-tags --format="get(tags,creationTime)" | while IFS=':' read -r tags timestamp; do

  # Calculate image age in days
  image_age=$(($(date +%s) - $(gdate -d "$timestamp" +%s)))

  # Check if image is older than threshold
  if [[ $image_age -gt $((THRESHOLD_DAYS * 86400)) ]]; then
    # Print details of image to be deleted (modify for deletion command if needed)
    echo "Image: $tags (Age: $((image_age / 86400)) days)"
  fi
done
