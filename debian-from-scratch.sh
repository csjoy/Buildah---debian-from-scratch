#!/bin/bash

# Defining default image name
IMAGE_NAME="${1:-bookworm}"

echo "### Checking for prerequisite"

# Check if the user has privileged access
if [ $UID -ne 0 ]; then
  echo "Run buildscript as root user"
  exit 1
fi

# Check if buildah is present in host os
if [ -z "$(command -v buildah)" ]; then
  echo "buildah is not installed"
  exit 1
fi

# Check if debootstrap is present in host os
if [ -z "$(command -v debootstrap)" ]; then
  echo "debootstrap is not installed"
  exit 1
fi

echo "### Testing container creation"
buildah from scratch
if [ $? -ne 0 ]; then
  echo "Error initializing working container"
  exit 1
fi

echo "### Mounting working container"
scratchmount=$(buildah mount working-container)
if [ $? -ne 0 ]; then
  echo "Error mounting working container"
  exit 1
fi

echo "### Bootstraping debian base image"
debootstrap --variant=minbase bookworm $scratchmount
if [ $? -ne 0 ]; then
  echo "Error creating minbase image"
  exit 1
fi

echo "### Commiting final image"
buildah commit working-container $IMAGE_NAME
if [ $? -ne 0 ]; then
  echo "Error commiting image"
  exit 1
fi


echo "### Removing working container"
buildah rm working-container
if [ $? -ne 0 ]; then
  echo "Error removing working container"
  exit 1
fi

echo "### Build debian from scratch completed successfully!"
exit 0