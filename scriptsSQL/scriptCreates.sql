DROP TABLE IF EXISTS Corrida;
DROP TABLE IF EXISTS Fila;
DROP TABLE IF EXISTS Cliente;
DROP TABLE IF EXISTS ClienteEmpresa;
DROP TABLE IF EXISTS ClienteFisico;
DROP TABLE IF EXISTS Motorista;
DROP TABLE IF EXISTS Zona;
DROP TABLE IF EXISTS Taxi;

CREATE TABLE Taxi (
  Placa VARCHAR(7) NOT NULL,
  Marca VARCHAR(30) NOT NULL,
  Modelo VARCHAR(30) NOT NULL,
  AnoFab INTEGER,
  Licenca VARCHAR(9),
  PRIMARY KEY(Placa)
);


--------------------------------------------------------------------------------------

CREATE TABLE ClienteEmpresa (
  CliId VARCHAR(4) NOT NULL,
  Nome VARCHAR(80) NOT NULL,
  CNPJ VARCHAR(14) NOT NULL UNIQUE,
  PRIMARY KEY(CliId)
);

CREATE TABLE ClienteFisico (
  CliId VARCHAR(4) NOT NULL,
  Nome VARCHAR(80) NOT NULL,
  CPF VARCHAR(14) NOT NULL UNIQUE,
  PRIMARY KEY(CliId)
);


CREATE TABLE Cliente (
  CliId BIGSERIAL NOT NULL PRIMARY KEY,
  Documento VARCHAR(14) NOT NULL UNIQUE,
  FOREIGN KEY (Documento) REFERENCES ClienteEmpresa(CNPJ) ON DELETE CASCADE,
  FOREIGN KEY (Documento) REFERENCES ClienteFisico(CPF) ON DELETE CASCADE
);

CREATE OR REPLACE FUNCTION insert_client()
RETURNS TRIGGER AS $$
BEGIN
    IF (TG_TABLE_NAME = 'ClienteEmpresa') THEN
        INSERT INTO Cliente(Documento) VALUES (NEW.CNPJ);
    ELSIF (TG_TABLE_NAME = 'ClienteFisico') THEN
        INSERT INTO Cliente(Documento) VALUES (NEW.CPF);
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE TRIGGER insert_user
AFTER INSERT ON ClienteEmpresa
FOR EACH ROW
EXECUTE FUNCTION insert_client();

CREATE OR REPLACE TRIGGER insert_user
AFTER INSERT ON ClienteFisico
FOR EACH ROW
EXECUTE FUNCTION insert_client();

--------------------------------------------------------------------------------------



create TABLE Corrida (
  idCorrida VARCHAR(4) NOT NULL,
  Placa VARCHAR(7) NOT NULL,
  DataPedido DATE NOT NULL,
  cliidCliente int not null,
  KMTotal numeric(5) not null,
  PRIMARY KEY(idCorrida, Placa, DataPedido, cliidCliente),
  FOREIGN KEY(cliidCliente)
    REFERENCES cliente(cliid)
      ON DELETE NO ACTION
      ON UPDATE NO ACTION,
  FOREIGN KEY(Placa)
    REFERENCES Taxi(Placa)
      ON DELETE NO ACTION
      ON UPDATE NO ACTION
);



CREATE TABLE Motorista (
  CNH VARCHAR(6) NOT NULL,
  Nome VARCHAR(80) NOT NULL,
  CNHValid INTEGER,
  Placa VARCHAR(7) NOT NULL,
  PRIMARY KEY(CNH),
  FOREIGN KEY(Placa)
    REFERENCES Taxi(Placa)
      ON DELETE NO ACTION
      ON UPDATE NO ACTION
);

CREATE TABLE Zona (
  id SERIAL PRIMARY KEY,
  Zona VARCHAR(40) NOT NULL
);

CREATE TABLE Fila (
   Zona INTEGER NOT NULL,
   CNH VARCHAR(6) NOT NULL,
   DataHoraIn TIMESTAMP,
   DataHoraOut TIMESTAMP,
   KmIn INTEGER,
   PRIMARY KEY (Zona, CNH),
   FOREIGN KEY(Zona)
     REFERENCES Zona(id)
       ON DELETE NO ACTION
       ON UPDATE NO ACTION,
   FOREIGN KEY(CNH)
     REFERENCES Motorista(CNH)
       ON DELETE NO ACTION
       ON UPDATE NO ACTION
);
