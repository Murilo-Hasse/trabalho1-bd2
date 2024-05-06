-- “Preciso de um relatório que traga um retorno completo das consultas de corrida, 
-- como motorista que passou mais tempo ocioso durante a espera da fila. 
-- Este relatório trará todas informações como motorista, carro utilizado, 
-- placa, também preciso que indique o tempo média de espera durante o mês“
-- Consulta fila de corridas, qual motorista p/ zona passou mais tempo
-- Qual passou menos tempo por zona?


SELECT 
	mot.nome as nome, mot.placa AS placa_carro,
	MAX(fil.datahoraout - fil.datahorain) AS maximo_tempo_fila, 
	AVG(fil.datahoraout - fil.datahorain) AS media_tempo_fila, 
	(taxi.marca) || ' ' || (taxi.modelo) AS carro
FROM fila AS fil
INNER JOIN motorista AS mot
	ON fil.cnh = mot.cnh
INNER JOIN taxi
	USING placa
WHERE
	taxi.marca || ' ' || taxi.modelo LIKE '%a%'

GROUP BY mot.nome, mot.placa, carro
ORDER BY maximo_tempo_fila DESC;



