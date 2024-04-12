from faker import Faker
import os
import random
from abc import ABC, abstractmethod

class AbstractGenerator(ABC):
    def __init__(self, seed: int, language: str, taxi_path: str, driver_path: str) -> None:
        super().__init__()
        self._faker = Faker(language, seed=seed)
        self._taxi_path = taxi_path
        self._driver_path = driver_path
        
    
    @abstractmethod
    def generate_fake_taxis(self, quantity: int) -> None:
        if os.path.exists(self._taxi_path):
            os.remove(self._taxi_path)
    
    
    @abstractmethod
    def generate_fake_drivers(self, quantity: int) -> None:
        if os.path.exists(self._driver_path):
            os.remove(self._driver_path)

class Generator(AbstractGenerator):
    def __init__(self, seed: int, language: str, taxi_path: str, driver_path: str) -> None:
        super().__init__(seed, language, taxi_path, driver_path)
        self.__plates = list()
         
    def generate_fake_taxis(self, quantity: int) -> None:
        super().generate_fake_taxis(quantity)
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
            
        with open(self._taxi_path, 'w') as file:
            file.write(file_as_str)
    
    def generate_fake_drivers(self, quantity: int) -> None:
        super().generate_fake_drivers(quantity)
        
        file_as_str = ''
    
        for i in range(0, quantity):
            cnh = self._faker.random_number(digits=11)
            name = self._faker.name()
            validade = self._faker.date()
            placa = self.__plates[i]
            
            file_as_str += (f"INSERT INTO Motorista(CNH, Nome, CNHValid, Placa) VALUES ('{cnh}', '{name}', {validade}, '{placa}');\n")
            
        with open(self._driver_path, 'w') as file:
            file.write(file_as_str)
            
            
if __name__ == '__main__':
    fake_generator = Generator(1024, 'PT-BR', 'taxis.sql', 'motoristas.sql')
    fake_generator.generate_fake_taxis(10000)
    fake_generator.generate_fake_drivers(10000)
    