package com.example.smt;

import org.apache.kafka.common.config.ConfigDef;
import org.apache.kafka.connect.connector.ConnectRecord;
import org.apache.kafka.connect.transforms.Transformation;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.util.Map;

/**
 * A simple SMT that logs a message upon initialization.
 * This transform does not modify the record; it's for demonstration purposes.
 */
public class LoggingSmT<R extends ConnectRecord<R>> implements Transformation<R> {

    private static final Logger log = LoggerFactory.getLogger(LoggingSmT.class);
    public static final String SMT_LOADED_MESSAGE = "Custom Logging SMT has been successfully loaded and configured.";
    public static final String SMT_CP_MESSAGE = "Custom Logging SMT has been successfully loaded from the classpath";

    static{
        log.info("*************************************************");
        log.info(SMT_LOADED_MESSAGE);
        log.info("CL:"+LoggingSmT.class.getClassLoader());
        log.info("*************************************************");
    }

    /**
     * This method is called once when the SMT is initialized.
     * We'll add our log message here.
     * @param configs The configuration settings for the SMT.
     */
    @Override
    public void configure(Map<String, ?> configs) {
        log.info("*************************************************");
        log.info(SMT_LOADED_MESSAGE);
        log.info("*************************************************");
    }

    /**
     * This method is called for each record. We will not modify it.
     * @param record The record to be transformed.
     * @return The original, unmodified record.
     */
    @Override
    public R apply(R record) {
        return record;
    }

    /**
     * Defines the configuration options for this SMT.
     * @return A new ConfigDef object.
     */
    @Override
    public ConfigDef config() {
        return new ConfigDef();
    }

    /**
     * This method is called when the SMT is shut down.
     */
    @Override
    public void close() {
        // No resources to release.
    }
}
