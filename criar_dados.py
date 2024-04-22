from faker import Faker
import os
import random
from abc import ABC, abstractmethod
from pathlib import Path

PATH = Path(__file__).parent


def save_to_file(func):
    def wrapper(this, quantity):
        path, content = func(this, quantity)
        with open(path, 'w') as file:
            file.write(content)
    return wrapper


class AbstractGenerator(ABC):
    def __init__(self, seed: int, language: str, taxi_path: str, driver_path: str, user_path: str, course_path: str) -> None:
        super().__init__()
        
        files = [file.lower() for file in os.listdir(PATH) if file.endswith('.sql')]

        for path in files:
            if(path == 'procedures.sql'):
                continue
            os.remove(path)
        
        self._faker = Faker(language, seed=seed)
        self._taxi_path = taxi_path
        self._driver_path = driver_path
        self._user_path = user_path
        self._course_path = course_path


class Generator(AbstractGenerator):
    def __init__(self, seed: int, language: str, taxi_path: str, driver_path: str, user_path: str, course_path) -> None:
        super().__init__(seed, language, taxi_path, driver_path, user_path, course_path)
        self.__plates = list()
        self.__cnhs = list()
        self.__user_quantity = 0
    
    
    @save_to_file
    def generate_fake_taxis(self, quantity: int) -> None:
        number = 0
        file_as_str = ''
        
        car_brands = ["Volkswagen", "Chevrolet", "Fiat", "Ford", "Toyota", "Honda", "Renault", "Hyundai", "Jeep", "Nissan"]
        car_types = [
            "Gol", "Onix", "Uno", "Ka", "Corolla", "Civic", "Sandero", "HB20", "Renegade", "Versa", "Fox", "Prisma", "Palio", "Fiesta", "Etios", "Fit", "Cruze", "Celta", "C3", "Siena",
            "Toro", "EcoSport", "Golf", "Logan", "HR-V", "Tracker", "Astra", "Captur", "Picanto", "Fusion", "Duster", "Cobalt", "Sentra", "Compass", "Up!", "Fusca", "Kwid", "March", "City", "Hilux", "Uno", "F-250", "Hilux SW4", "Sorento", "Frontier", "Tucson", "Grand Siena", "Tiguan", "XC60"
        ]
        
        for i in range(0, quantity):
            placa = f'AAA-{str(number).zfill(4)}'
            self.__plates.append(placa)
            
            brand = random.choice(car_brands)
            type = random.choice(car_types)
            
            year = self._faker.random_int(min=1990, max=2023)
            license = self._faker.random_element(elements=('A', 'B', 'C')) + str(self._faker.random_number(digits=6))
            
            file_as_str += (f"INSERT INTO Taxi(Placa, Marca, Modelo, AnoFab, Licenca) VALUES ('{placa}', '{brand}', '{type}', {year}, '{license}');\n")
            number += 1
            
        return self._taxi_path, file_as_str
    
    @save_to_file
    def generate_fake_drivers(self, quantity: int) -> None:        
        file_as_str = ''
    
        for i in range(0, quantity):
            cnh = self._faker.random_number(digits=11)
            self.__cnhs.append(cnh)
            name = self._faker.name()
            validade = self._faker.date()
            placa = self.__plates[i]
            
            file_as_str += (f"INSERT INTO Motorista(CNH, Nome, CNHValid, Placa) VALUES ('{cnh}', '{name}', {validade}, '{placa}');\n")
            
        return self._driver_path, file_as_str
    
    @save_to_file
    def generate_fake_users(self, quantity: int) -> None:
        self.__user_quantity = quantity

        
        file_as_str = ''
    
        for i in range(0, quantity):
            name = self._faker.name()
            cpf = self._faker.cpf()
            
            file_as_str += (f"INSERT INTO Cliente(CliId, Nome, CPF) VALUES ('{i}', '{name}', {cpf});\n")
            
        return self._user_path, file_as_str
    
    @save_to_file
    def generate_fake_drives(self, quantity: int) -> None:    
        file_as_str = ''
        for i in range(0, quantity):
            user_id = random.randint(0, self.__user_quantity)
            plate = random.choice(self.__plates)
            date = self._faker.date()
            
            file_as_str += (f"INSERT INTO Corrida(CliId, Placa, DataPedido) VALUES ('{user_id}', '{plate}', '{date}');\n")
        
        return self._course_path, file_as_str
            
            
if __name__ == '__main__':
    fake_generator = Generator(1024, 'PT-BR', 'taxis.sql', 'motoristas.sql', 'clientes.sql', 'corridas.sql')
    fake_generator.generate_fake_taxis(10000)
    fake_generator.generate_fake_drivers(10000)
    fake_generator.generate_fake_users(19789)
    fake_generator.generate_fake_drives(65535)
    