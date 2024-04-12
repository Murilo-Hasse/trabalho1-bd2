CREATE OR REPLACE FUNCTION tempoMedioConsulta()
RETURNS NUMERIC AS $$
DECLARE
    start_time TIMESTAMP;
    end_time TIMESTAMP;
    query_time_ms INTEGER;

    tempo_medio NUMERIC;

    sla NUMERIC;
BEGIN
    CREATE TEMPORARY TABLE IF NOT EXISTS tempo_consulta(
        id SERIAL PRIMARY KEY,
        tempo_consulta_ms INTEGER
    );

    FOR i IN 1..100
    LOOP
    start_time := clock_timestamp();
    SELECT INTO sla * FROM bar;
    end_time := clock_timestamp();

    query_time_ms := EXTRACT(MILLISECONDS FROM (end_time - start_time));

    INSERT INTO tempo_consulta(tempo_consulta_ms) VALUES (query_time_ms);
    END LOOP;

    SELECT AVG(tempo_consulta_ms) INTO tempo_medio FROM tempo_consulta;

    RETURN tempo_medio;

    DROP TABLE IF EXISTS tempo_consulta;
END;
$$ LANGUAGE plpgsql;


SELECT tempoMedioConsulta();
