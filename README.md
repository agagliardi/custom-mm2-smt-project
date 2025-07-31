# Progetto SMT Custom per Kafka MirrorMaker 2

Questo progetto contiene tutto il necessario per costruire e deployare un Single Message Transform (SMT) custom per Strimzi MirrorMaker 2 su OpenShift.

## Struttura del Progetto

- `src/main/java/com/example/smt/LoggingSmT.java`: Il codice sorgente del nostro SMT.
- `pom.xml`: Il file di configurazione di Maven per compilare il progetto.
- `Dockerfile`: Le istruzioni per costruire l'immagine container custom di MM2.
- `mm2-custom-resource.yaml`: La Custom Resource (CR) di `KafkaMirrorMaker2` per il deploy su OpenShift.
- `.gitignore`: File standard per ignorare file non necessari in Git.

## Come Usare

### 1. Compilare il JAR
Assicurati di avere Maven e JDK 11 (o superiore) installati.

```sh
mvn clean package
```
Questo comando creerà il file `target/custom-smt-1.0.0.jar`.

### 2. Costruire e Pushare l'Immagine Docker
Assicurati di essere loggato al registro interno di OpenShift.

```sh
# Esegui il login al registro di OpenShift
docker login -u $(oc whoami) -p $(oc whoami -t) $(oc registry info)

# Definisci le variabili (modifica 'your-project-name' con il tuo progetto OpenShift)
REGISTRY_URL=$(oc registry info)
PROJECT_NAME="your-project-name"
IMAGE_NAME="custom-mirrormaker2"
IMAGE_TAG="latest"
FULL_IMAGE_URL="${REGISTRY_URL}/${PROJECT_NAME}/${IMAGE_NAME}:${IMAGE_TAG}"

# Costruisci, tagga e pusha l'immagine
docker build -t $FULL_IMAGE_URL .
docker push $FULL_IMAGE_URL
```

### 3. Deployare MirrorMaker 2
Prima di applicare il file, modifica `mm2-custom-resource.yaml` e sostituisci `image-registry.openshift-image-registry.svc:5000/your-project-name/custom-mirrormaker2:latest` con il valore di `$FULL_IMAGE_URL`.

```sh
oc apply -f mm2-custom-resource.yaml
```

### 4. Verificare
Controlla i log del pod di MM2 per vedere il messaggio del tuo SMT.

```sh
MM2_POD=$(oc get pods -l strimzi.io/cluster=my-custom-mm2 -o jsonpath='{.items[0].metadata.name}')
oc logs $MM2_POD | grep "Custom Logging SMT has been successfully loaded"
```
