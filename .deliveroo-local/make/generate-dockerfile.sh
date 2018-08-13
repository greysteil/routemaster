#!/bin/bash
# This script generates a Dockerfile adds deliveroo-local-certs to the base
# Dockerfile.

dir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
app="$( cd "${dir}/../../" && pwd )"

# Include the certs image.
cat << "EOF" > Dockerfile
  FROM deliveroo/deliveroo-local-certs:latest as dev-certs
EOF

# List images.
echo "$(head -n2 ${app}/Dockerfile)" >> Dockerfile

# Add certs.
cat << "EOF" >> Dockerfile

# Add sudo.
RUN apt-get update && apt-get install -y sudo && rm -rf /var/lib/apt/lists/*

# Copy the certs from the deliveroo-local-ca image.
COPY --from=dev-certs \
     /usr/share/ca-certificates/deliveroo-local-ca.crt \
     /usr/share/ca-certificates/deliveroo-local-ca.crt

# Add the ca-cert to the store.
RUN sudo update-ca-certificates

EOF
echo "$(tail -n +2 ${app}/Dockerfile)" >> Dockerfile
