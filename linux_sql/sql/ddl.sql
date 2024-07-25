-- Connect to host_agent
\c host_agent
-- Create host_info table if it does not exist
CREATE TABLE IF NOT EXISTS host_info (
                                         id SERIAL PRIMARY KEY,
                                         hostname VARCHAR NOT NULL UNIQUE,
                                         cpu_number SMALLINT NOT NULL,
                                         cpu_architecture VARCHAR NOT NULL,
                                         cpu_model VARCHAR NOT NULL,
                                         cpu_mhz FLOAT8 NOT NULL,
                                         l2_cache INTEGER NOT NULL,
                                         "timestamp" TIMESTAMP NOT NULL,
                                         total_mem INTEGER NOT NULL
);

-- Create host_usage table if it does not exist
CREATE TABLE IF NOT EXISTS host_usage (
                                          id SERIAL PRIMARY KEY,
                                          hostname VARCHAR NOT NULL,
                                          memory_usage INTEGER NOT NULL,
                                          cpu_usage FLOAT8 NOT NULL,
                                          disk_io FLOAT8 NOT NULL,
                                          network_io FLOAT8 NOT NULL,
                                          "timestamp" TIMESTAMP NOT NULL,
                                          FOREIGN KEY (hostname) REFERENCES host_info (hostname)
    );