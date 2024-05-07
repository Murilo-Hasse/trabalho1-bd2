-- “Preciso de um relatório que traga um retorno completo das consultas de corridas e dos motoristas nelas,
-- Portanto, além do nome, necessito de outros dados: 
-- Como filtro para saber se o motorista esta com carteira vencida ou não,
-- O ano que ele deverá refazer carteira,
-- motorista que passou mais tempo ocioso durante a espera da fila. 
-- Este relatório trará todas informações como motorista, carro utilizado, 
-- placa, também preciso que indique o tempo média de espera“


SELECT 
	mot.nome as nome,
	case
		WHEN mot.cnhvalid < 2010 Then 'Renovar carteira'
		else 'Validade Ok'
	end
	,mot.cnhvalid as cnh_valida
	,mot.placa AS placa_carro,
	MAX(fil.datahoraout - fil.datahorain) AS maximo_tempo_fila, 
	AVG(fil.datahoraout - fil.datahorain) AS media_tempo_fila, 
	(taxi.marca) || ' ' || (taxi.modelo) AS carro
FROM fila AS fil
INNER JOIN motorista AS mot
	USING (CNH)
INNER JOIN taxi
	USING (placa)

	where taxi.marca = 'Toyota' and
	mot.cnhvalid > 2000
GROUP BY mot.nome, mot.placa, carro, mot.cnhvalid
ORDER BY maximo_tempo_fila;



