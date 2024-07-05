# GCR-cleaner
A project to cleanup the images from Google Cloud Repository

# Problem Statement: 
- In enterprises, we may face a lot of issues while dealing with tonnes of docker images of numerous microservices and their constant version iterations.
- While versioning and iterating over a microservice multiple times in local environment is a good practive to improve the productivy of the applications or the desired service, it creates a mess with a lot of unused docker images.
- Most of the time it is stored in Google Cloud Repository (or other such repos or container spaces). These low memory consuming images may not seem very expensive but storing them for a long time can end up costing a lot.
- An enterprise at the end of the day wants to save money
- Thus, cleaning up useless images can help us free up a lot of memory space in the cloud ad help us save money.
