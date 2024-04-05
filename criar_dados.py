from faker import Faker
import os
import random

placas = list()

def gerar_clientes():    
    faker = Faker("PT-BR")    
    for i in range(0, 10000):
        nome = faker.name()
        cpf = faker.cpf()
        with open('clientes.sql', 'a') as file:
            file.write(f"INSERT INTO Cliente(CliId, Nome, CPF) VALUES ('{i}', '{nome}', '{cpf}');\n")


def gerar_zonas():
    faker = Faker("PT-BR")
    for i in range(0, 12164):
        with open('zonas.sql', 'a') as file:
            file.write(f"INSERT INTO Zona(Zona) VALUES ('{faker.city()}');\n")
            

def gerar_taxis():
    faker = Faker("PT-BR")
    for i in range(0, 13826):
        placa = faker.license_plate()
        placas.append(placa)
        marca = faker.company()
        modelo = faker.word().capitalize()
        ano_fab = faker.random_int(min=1990, max=2023)
        licenca = faker.random_element(elements=('A', 'B', 'C')) + str(faker.random_number(digits=6))

        with open('taxis.sql', 'a') as file:
            file.write(f"INSERT INTO Taxi(Placa, Marca, Modelo, AnoFab, Licenca) VALUES ('{placa}', '{marca}', '{modelo}', {ano_fab}, '{licenca}');\n")
            
            
def gerar_empresas():    
    faker = Faker("PT-BR")
    fake_empresa = Faker("EN-US")
    for i in range(0, 10000):
        nome = fake_empresa.word().capitalize()
        cnpj = faker.cnpj()
        with open('empresas.sql', 'a') as file:
            file.write(f"INSERT INTO ClienteEmpresa(CliId, Nome, CNPJ) VALUES ('{i}', '{nome}', '{cnpj}');\n")


def gerar_motoristas():    
    faker = Faker("PT-BR")
    for i in range(0, 11253):
        cnh = faker.random_number(digits=11)
        nome = faker.name()
        validade = faker.random_number(digits=8)
        placa = random.choice(placas)
        with open('motoristas.sql', 'a') as file:
            file.write(f"INSERT INTO Motorista(CNH, Nome, CNHValid, Placa) VALUES ('{cnh}', '{nome}', {validade}, '{placa}');\n")
            

def gerar_corridas():    
    faker = Faker("PT-BR")
    for i in range(0, 16384):
        id_cliente = random.randint(1, 10000)
        placa = random.choice(placas)
        data = faker.date()
        with open('corridas.sql', 'a') as file:
            file.write(f"INSERT INTO Corrida(CliId, Placa, DataPedido) VALUES ('{id_cliente}', '{placa}', {data});\n")
            
            
            
if __name__ == '__main__':    
    try:
        os.remove('clientes.sql')
        os.remove('taxis.sql')
        os.remove('zonas.sql')
        os.remove('empresas.sql')
        os.remove('motoristas.sql')
        os.remove('corridas.sql')
    except:
        pass
    gerar_clientes()
    gerar_zonas()
    gerar_taxis()
    gerar_empresas()
    gerar_motoristas()
    gerar_corridas()
    