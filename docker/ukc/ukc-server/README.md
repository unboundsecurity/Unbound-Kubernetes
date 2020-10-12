# Build the UKC Server Docker Image

The *ukc-server* directory contains all files required to build Docker image, except for the UKC binary.

 1. Copy your UKC Server binary to the *data* sub-directory.

     **Note:** The UKC RPM for RHEL/Centos 8 is required, with file name in the format *ekm-<VERSION>.el8.x86_64.rpm*.

 2. Build the Docker image.
    `docker build -t <your-image-tag> .`

    **Note:** The image tag should match the "image" tag in the Kubernetes files.
