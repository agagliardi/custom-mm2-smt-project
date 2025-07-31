# Progetto SMT Custom per Kafka MirrorMaker 2

Questo progetto contiene tutto il necessario per costruire e deployare un Single Message Transform (SMT) custom per Strimzi MirrorMaker 2 su OpenShift, eseguendo la build direttamente all'interno del cluster.

## Struttura del Progetto

* `src/main/java/com/example/smt/LoggingSmT.java`: Il codice sorgente del nostro SMT.
* `pom.xml`: Il file di configurazione di Maven per compilare il progetto.
* `Dockerfile`: Le istruzioni per costruire l'immagine container custom di MM2.
* `buildconfig.yaml`: La configurazione per dire a OpenShift come costruire l'immagine usando i file locali.
* `mm2-custom-resource.yaml`: La Custom Resource (CR) di `KafkaMirrorMaker2` per il deploy su OpenShift.

## Come Usare

Il processo si basa su una **build binaria**, che invia i file dal tuo computer locale direttamente a OpenShift per la creazione dell'immagine.

### 1. Compilare il JAR localmente

Assicurati di avere Maven e JDK 11 (o superiore) installati. Dalla cartella principale del progetto, esegui:

```sh
mvn clean package
```

Questo comando creerà il file `target/custom-smt-1.0.0.jar`, che verrà incluso nella build.

### 2. Creare la `BuildConfig` su OpenShift

Applica il file `buildconfig.yaml` al tuo progetto OpenShift. Questo va fatto solo una volta.

```sh
oc apply -f buildconfig.yaml
```

### 3. Avviare la Build Binaria

Questo comando prende tutti i file nella directory corrente (inclusi il `Dockerfile` e la cartella `target`), li invia a OpenShift e avvia il processo di build dell'immagine.

Esegui il comando dalla root del tuo progetto:

```sh
oc start-build custom-mirrormaker2-build --from-dir=. --follow
```

Il flag `--follow` ti permette di seguire i log della build in tempo reale.

### 4. Deployare MirrorMaker 2

Una volta che la build è completata con successo, l'immagine sarà disponibile nell'`ImageStream` interno di OpenShift. Ora puoi deployare `KafkaMirrorMaker2`.

```sh
oc apply -f mm2-custom-resource.yaml
```

### 5. Verificare

Controlla i log del pod di MM2 per vedere il messaggio di conferma del caricamento del tuo SMT.

```sh
# Trova il nome del pod di MM2
MM2_POD=$(oc get pods -l strimzi.io/cluster=my-custom-mm2 -o jsonpath='{.items[0].metadata.name}')

# Controlla i log
oc logs $MM2_POD | grep "Custom Logging SMT has been successfully loaded"
