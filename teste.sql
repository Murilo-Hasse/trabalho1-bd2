CREATE INDEX IF NOT EXISTS zonaindex ON zona USING HASH(zona);
CREATE INDEX IF NOT EXISTS filaindex ON fila USING HASH(cnh);
CREATE INDEX IF NOT EXISTS filaindex1 ON fila USING HASH(zona);
CREATE INDEX IF NOT EXISTS corridaindex ON corrida USING HASH(placa);
CREATE INDEX IF NOT EXISTS corridaindex1 ON corrida USING HASH(datapedido);
CREATE INDEX IF NOT EXISTS motoristaindex ON motorista USING HASH(cnh);
CREATE INDEX IF NOT EXISTS motoristaindex1 ON motorista USING HASH(placa);

SELECT index_size(zonaindex) + index_size(filaindex) + index_size(filaindex1) + index_size(corridaindex) + index_size(corridaindex1) + indexsize(motoristaindex) + indexsize(motoristaindex1);

DROP INDEX IF EXISTS zonaindex;
DROP INDEX IF EXISTS filaindex;
DROP INDEX IF EXISTS filaindex1;
DROP INDEX IF EXISTS corridaindex;
DROP INDEX IF EXISTS corridaindex1;
DROP INDEX IF EXISTS motoristaindex;
DROP INDEX IF EXISTS motoristaindex1;


CREATE INDEX IF NOT EXISTS zonaindex ON zona USING BTREE(zona);
CREATE INDEX IF NOT EXISTS filaindex ON fila USING BTREE(cnh);
CREATE INDEX IF NOT EXISTS filaindex1 ON fila USING BTREE(zona);
CREATE INDEX IF NOT EXISTS corridaindex ON corrida USING BTREE(placa);
CREATE INDEX IF NOT EXISTS corridaindex1 ON corrida USING BTREE(datapedido);
CREATE INDEX IF NOT EXISTS motoristaindex ON motorista USING BTREE(cnh);
CREATE INDEX IF NOT EXISTS motoristaindex1 ON motorista USING BTREE(placa);

SELECT index_size(zonaindex) + index_size(filaindex) + index_size(filaindex1) + index_size(corridaindex) + index_size(corridaindex1) + indexsize(motoristaindex) + indexsize(motoristaindex1);

DROP INDEX IF EXISTS zonaindex;
DROP INDEX IF EXISTS filaindex;
DROP INDEX IF EXISTS filaindex1;
DROP INDEX IF EXISTS corridaindex;
DROP INDEX IF EXISTS corridaindex1;
DROP INDEX IF EXISTS motoristaindex;
DROP INDEX IF EXISTS motoristaindex1;


CREATE INDEX IF NOT EXISTS zonaindex ON zona USING BRIN(zona);
CREATE INDEX IF NOT EXISTS filaindex ON fila USING BRIN(cnh);
CREATE INDEX IF NOT EXISTS filaindex1 ON fila USING BRIN(zona);
CREATE INDEX IF NOT EXISTS corridaindex ON corrida USING BRIN(placa);
CREATE INDEX IF NOT EXISTS corridaindex1 ON corrida USING BRIN(datapedido);
CREATE INDEX IF NOT EXISTS motoristaindex ON motorista USING BRIN(cnh);
CREATE INDEX IF NOT EXISTS motoristaindex1 ON motorista USING BRIN(placa);

SELECT index_size(zonaindex) + index_size(filaindex) + index_size(filaindex1) + index_size(corridaindex) + index_size(corridaindex1) + indexsize(motoristaindex) + indexsize(motoristaindex1);

DROP INDEX IF EXISTS zonaindex;
DROP INDEX IF EXISTS filaindex;
DROP INDEX IF EXISTS filaindex1;
DROP INDEX IF EXISTS corridaindex;
DROP INDEX IF EXISTS corridaindex1;
DROP INDEX IF EXISTS motoristaindex;
DROP INDEX IF EXISTS motoristaindex1;



CREATE INDEX IF NOT EXISTS zonaindex ON zona USING GIST(zona, gist_trgm_ops);
CREATE INDEX IF NOT EXISTS corridaindex ON corrida USING GIST(placa, gist_trgm_ops);
CREATE INDEX IF NOT EXISTS motoristaindex ON motorista USING GIST(cnh, gist_trgm_ops);
CREATE INDEX IF NOT EXISTS motoristaindex1 ON motorista USING GIST(placa, gist_trgm_ops);

SELECT index_size(zonaindex) + index_size(corridaindex) + indexsize(motoristaindex) + indexsize(motoristaindex1);

DROP INDEX IF EXISTS zonaindex;
DROP INDEX IF EXISTS corridaindex;
DROP INDEX IF EXISTS motoristaindex;
DROP INDEX IF EXISTS motoristaindex1;


CREATE INDEX IF NOT EXISTS zonaindex ON zona USING gin(zona, gin_trgm_ops);
CREATE INDEX IF NOT EXISTS corridaindex ON corrida USING gin(placa, gin_trgm_ops);
CREATE INDEX IF NOT EXISTS motoristaindex ON motorista USING gin(cnh, gin_trgm_ops);
CREATE INDEX IF NOT EXISTS motoristaindex1 ON motorista USING gin(placa, gin_trgm_ops);

SELECT index_size(zonaindex) + index_size(corridaindex) + indexsize(motoristaindex) + indexsize(motoristaindex1);

DROP INDEX IF EXISTS zonaindex;
DROP INDEX IF EXISTS corridaindex;
DROP INDEX IF EXISTS motoristaindex;
DROP INDEX IF EXISTS motoristaindex1;