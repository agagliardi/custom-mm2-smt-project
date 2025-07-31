# Use a Strimzi Kafka image that matches your Strimzi Cluster Operator version.
# Check the Strimzi documentation for the correct base image for your version.
ARG STRIMZI_VERSION="0.41.0"
ARG KAFKA_VERSION="3.7.0"
FROM quay.io/strimzi/kafka:${STRIMZI_VERSION}-kafka-${KAFKA_VERSION}

# Switch to the root user to create directories and set permissions
USER root:root

# Create a dedicated directory for our custom plugins.
# This helps keep custom JARs organized and separate from default plugins.
RUN mkdir -p /opt/kafka/plugins/custom-smt-plugins

# Copy the compiled JAR file from your local build context into the image.
# Assumes the Docker build is run from the root of your Maven project.
COPY target/custom-smt-1.0.0.jar /opt/kafka/plugins/custom-smt-plugins/

# It's a good practice to revert to the default non-root user.
# The Strimzi base images use user 1001.
USER 1001
