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
  CliId int references Cliente(cliid),
  Nome VARCHAR(80) NOT NULL,
  CNPJ VARCHAR(18) NOT NULL UNIQUE,
  PRIMARY KEY(CliId)
);

CREATE TABLE ClienteFisico (
  CliId int references Cliente(cliid),
  Nome VARCHAR(80) NOT NULL,
  CPF VARCHAR(14) NOT NULL unique
);


CREATE TABLE Cliente (
  CliId BIGSERIAL NOT NULL PRIMARY KEY,
  Documento VARCHAR(14) NOT NULL UNIQUE
);

INSERT INTO ClienteFisico(Nome, CPF) VALUES ('Diogn Freitas', '159.853.702-41');
select * from clientefisico c 
select * from cliente c 

CREATE OR REPLACE FUNCTION insert_client()
RETURNS TRIGGER AS $$
declare 
	x INT;
BEGIN
    IF (TG_TABLE_NAME = 'clienteempresa') THEN
        INSERT INTO Cliente(Documento) VALUES (NEW.CNPJ);
       	select cliid into x from cliente where documento = (cnpj);
       	update clienteempresa set Cliid = x where cnpj = (cnpj);
    ELSIF (TG_TABLE_NAME = 'clientefisico') THEN
        INSERT INTO Cliente(Documento) values (NEW.CPF);
        select cliid into x from cliente where documento = (new.cpf);
       	update clientefisico set Cliid = x where cpf = (new.cpf);
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
  idCorrida serial unique NOT NULL,
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
