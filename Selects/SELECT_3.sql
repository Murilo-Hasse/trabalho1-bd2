-- “Preciso de um relatório que traga um retorno completo das consultas de corrida, 
-- como motorista que passou mais tempo ocioso durante a espera da fila. 
-- Este relatório trará todas informações como motorista, carro utilizado, 
-- placa, também preciso que indique o tempo média de espera durante o mês“
-- Consulta fila de corridas, qual motorista p/ zona passou mais tempo
-- Qual passou menos tempo por zona?


select max(fil.datahoraout - fil.datahorain) as maximo_tempo_fila, mot.nome as nome, mot.placa as placa_carro,
avg(fil.datahoraout - fil.datahorain) as media_tempo_fila, (taxi.marca)||' '||(taxi.modelo) as carro

  from fila fil
	inner join motorista mot
		on(fil.cnh = mot.cnh)
	inner join taxi
		using(placa)
		
	where
		(taxi.marca)||' '||(taxi.modelo) like '%a%'

	group by  mot.nome, mot.placa, carro
	order by maximo_tempo_fila desc



