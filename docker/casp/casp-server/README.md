
#  Build the CASP Server Docker Image

This directory contains all files required to build the Docker image, except for the CASP binary.


1. Copy your CASP Server binary to the *data* sub-directory.

    **Note:** The CASP RPM for RHEL is required, with a file name in the format `casp*-RHES.x86_64.rpm`.

2. Build the Docker image.

    `docker build -t <your-image-tag> .`

    **Note:** The image tag should match the "image" tag in the Kubernetes files.
