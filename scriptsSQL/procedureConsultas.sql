CREATE TABLE IF NOT EXISTS log_sequencial(
  id SERIAL PRIMARY KEY,
  quantidade_executada NUMERIC,
  tempo_total_medio NUMERIC,
  tempo_plan_medio NUMERIC,
  tempo_exec_medio NUMERIC,
  filtro VARCHAR(200),
  linhas_removidas NUMERIC
);

CREATE TABLE IF NOT EXISTS log_Consultas(
  id SERIAL PRIMARY KEY,
  tipo_consulta VARCHAR(20) NOT NULL,
  quantidade_executada NUMERIC,
  tempo_total_medio NUMERIC,
  tempo_plan_medio NUMERIC,
  tempo_exec_medio NUMERIC,
  filtro VARCHAR(200),
  linhas_removidas NUMERIC,
  ref_serial INT,
  FOREIGN KEY (ref_serial) REFERENCES log_sequencial(id)
);

CREATE OR REPLACE PROCEDURE calculate_total_time(query text, num_executions integer) AS $$
DECLARE
  i integer;
  tipo VARCHAR(20);
  tipo2 VARCHAR(20);
  total_planning_time NUMERIC := 0;
  total_execution_time NUMERIC := 0;
  current_planning_time numeric;
  current_execution_time numeric;
  filt VARCHAR(200);
  filt2 VARCHAR(200);
  linhas NUMERIC;
  explain_result json;
BEGIN
  SET enable_seqscan = OFF;
  EXECUTE 'EXPLAIN (ANALYZE, FORMAT JSON) ' || query INTO explain_result;
  IF (explain_result->0->'Plan'->>'Node Type')::VARCHAR(20) = 'Seq Scan' THEN
    RAISE NOTICE 'Index não criado ou utilizado.';
    SET enable_seqscan = ON;
    RETURN;
  END IF;

  IF EXISTS (
    SELECT 1
    FROM log_Consultas
    WHERE tipo_consulta = (explain_result->0->'Plan'->>'Index Name')::VARCHAR(20) AND
          filtro = (explain_result->0->'Plan'->>'Filter')::VARCHAR(200) AND
          quantidade_executada = num_executions
  ) THEN
    RAISE NOTICE 'Consulta idêntica já lançada';  
    SET enable_seqscan = ON;
    RETURN;
  END IF;

  FOR i IN 1..num_executions LOOP
    EXECUTE 'EXPLAIN (ANALYZE, FORMAT JSON) ' || query INTO explain_result;
    current_planning_time := (explain_result->0->>'Planning Time')::numeric;
    current_execution_time := (explain_result->0->>'Execution Time')::numeric;
    total_planning_time := total_planning_time + current_planning_time;
    total_execution_time := total_execution_time + current_execution_time;
    EXECUTE 'DISCARD PLANS';
  END LOOP;
  tipo := (explain_result->0->'Plan'->>'Index Name')::VARCHAR(20);
  tipo2 := (explain_result->0->'Plan'->>'Index Name')::VARCHAR(20);
  filt2 := (explain_result->0->'Plan'->>'Filter')::VARCHAR(200);
  filt := (explain_result->0->'Plan'->>'Filter')::VARCHAR(200);
  linhas := (explain_result->0->'Plan'->>'Rows Removed by Filter')::NUMERIC;
  INSERT INTO log_Consultas
  (tipo_consulta, quantidade_executada, tempo_total_medio, tempo_plan_medio, tempo_exec_medio, filtro, linhas_removidas) VALUES
  (tipo, num_executions, ((total_execution_time + total_planning_time) / num_executions), total_planning_time / num_executions, total_execution_time / num_executions, filt, linhas);
  SET enable_seqscan = ON;
  RAISE NOTICE 'JSON: %', explain_result;
--Criar outra funcao
  IF EXISTS (
    SELECT 1
    FROM log_sequencial
    WHERE filtro = (explain_result->0->'Plan'->>'Filter')::VARCHAR(200) AND
          quantidade_executada = num_executions
  ) THEN
    UPDATE log_Consultas 
    SET ref_serial = (
      SELECT id
      FROM log_sequencial
      WHERE filtro = (explain_result->0->'Plan'->>'Filter')::VARCHAR(200) AND
            quantidade_executada = num_executions
      LIMIT 1
    ) 
    WHERE tipo_consulta = (explain_result->0->'Plan'->>'Index Name')::VARCHAR(20) AND
          filtro = (explain_result->0->'Plan'->>'Filter')::VARCHAR(200) AND
          quantidade_executada = num_executions;

    RAISE NOTICE 'Consulta sequencial já lançada';
    RETURN;
  ELSE
    total_execution_time := 0;
    total_planning_time := 0;
    FOR i IN 1..num_executions LOOP
      EXECUTE 'EXPLAIN (ANALYZE, FORMAT JSON) ' || query INTO explain_result;
      current_planning_time := (explain_result->0->>'Planning Time')::numeric;
      current_execution_time := (explain_result->0->>'Execution Time')::numeric;
      total_planning_time := total_planning_time + current_planning_time;
      total_execution_time := total_execution_time + current_execution_time;
      EXECUTE 'DISCARD PLANS';
    END LOOP;
    INSERT INTO log_sequencial(quantidade_executada, tempo_total_medio, tempo_plan_medio, tempo_exec_medio, filtro, linhas_removidas)
    VALUES(num_executions, ((total_execution_time + total_planning_time) / num_executions), total_planning_time / num_executions, total_execution_time / num_executions, filt, linhas);
    UPDATE log_Consultas 
    SET ref_serial = (
      SELECT id
      FROM log_sequencial
      WHERE filtro = (explain_result->0->'Plan'->>'Filter')::VARCHAR(200) AND
            quantidade_executada = num_executions
      LIMIT 1
    ) 
    WHERE tipo_consulta = tipo2 AND
          filtro = filt2 AND
          quantidade_executada = num_executions;
  END IF;
  
  
  RAISE NOTICE 'SEQ JSON: %', explain_result;
END;
$$ LANGUAGE plpgsql;
SELECT * FROM log_Consultas;
SELECT * FROM log_sequencial;

DELETE FROM log_Consultas;
DELETE FROM log_sequencial;

CALL calculate_total_time('select placa from (select * from corrida where (CliId::numeric < 1700::numeric))', 100);
CALL calculate_total_time('SELECT placa FROM (SELECT * FROM corrida INDEX (idx_btree) WHERE (CliId < 1700)) AS subquery', 100);

select * from corrida where (CliId::numeric > 1700::numeric);

CREATE INDEX idx_btree ON corrida USING btree (cliid, placa, datapedido);
CREATE INDEX idx_brin_composto ON corrida USING BRIN (CliId, Placa);
