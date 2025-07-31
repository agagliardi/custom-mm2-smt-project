# Usa l'immagine base di Red Hat AMQ Streams per Kafka 3.9.0
FROM registry.redhat.io/amq-streams/kafka-39-rhel9@sha256:818446e9a1b90acdb273f8bfcd1bc01ba9920a06bbf67b94504f4bcf8302f445

# Passa all'utente root per creare directory e impostare i permessi
USER root:root

# Crea una directory dedicata per i nostri plugin custom.
# Questo aiuta a mantenere i JAR custom organizzati e separati dai plugin di default.
RUN mkdir -p /opt/kafka/plugins/custom-smt-plugins

# Copia il file JAR compilato dal contesto di build locale nell'immagine.
# Si presume che la build di Docker venga eseguita dalla root del progetto Maven.
COPY target/custom-smt-1.0.0.jar /opt/kafka/plugins/custom-smt-plugins/

# È una buona pratica tornare all'utente non-root di default.
# Le immagini base di AMQ Streams usano l'utente 1001.
USER 1001
