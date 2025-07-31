# Custom SMT Project for Kafka MirrorMaker 2

This project contains everything needed to build and deploy a custom Single Message Transform (SMT) for Strimzi MirrorMaker 2 on OpenShift, by running the build process directly inside the cluster.

## Project Structure

* `src/main/java/com/example/smt/LoggingSmT.java`: The source code for our SMT.
* `pom.xml`: The Maven configuration file to compile the project.
* `Dockerfile`: The instructions to build the custom MM2 container image.
* `buildconfig.yaml`: The configuration to tell OpenShift how to build the image using local files.
* `mm2-custom-resource.yaml`: The `KafkaMirrorMaker2` Custom Resource (CR) for deploying on OpenShift.

## How to Use

The process is based on a **binary build**, which sends files from your local machine directly to OpenShift to create the image.

### 1. Compile the JAR locally

Make sure you have Maven and JDK 11 (or higher) installed. From the project's root folder, run:

```sh
mvn clean package
```

This command will create the `target/custom-smt-1.0.0.jar` file, which will be included in the build.

### 2. Create the ImageStream and BuildConfig on OpenShift

Before starting the build, we need to ensure OpenShift knows where to save the image. We will explicitly create an `ImageStream` and then the `BuildConfig`. This only needs to be done once.

```sh
# 1. Create the ImageStream (the destination for our image)
oc create imagestream custom-mirrormaker2

# 2. Create the BuildConfig
oc apply -f buildconfig.yaml
```

### 3. Start the Binary Build

This command takes all files in the current directory (including the `Dockerfile` and the `target` folder), sends them to OpenShift, and starts the image build process.

Run the command from your project's root directory:

```sh
oc start-build custom-mirrormaker2-build --from-dir=. --follow
```

The `--follow` flag allows you to see the build logs in real-time.

### 4. Deploy MirrorMaker 2

Once the build has completed successfully, the image will be available in OpenShift's internal `ImageStream`. You can now deploy `KafkaMirrorMaker2`.

```sh
oc apply -f kafka-cluster-a.yaml
oc apply -f kafka-cluster-b.yaml
oc apply -f kafkamirrormaker2-my-mm2-cluster.yaml
```

### 5. Verify

Check the logs of the MM2 pod to see the confirmation message that your SMT was loaded.

```sh

# Check the logs
oc logs my-mm2-cluster-mirrormaker2-0 | grep "Custom Logging SMT"
```
