--Necessitamos de um relatório que traga por zona a contagem de corridas, tamanho médio de corridas,
--maior corrida e menor corrida, utilizando um filtro de data(data inferior a data seguinte)

-- ZONA - PRINCIPAL
-- KM médio por corrida
-- MAX corrida
-- MIN corrida

SELECT 
	zona.zona as nome_zona, count(*) as contagem_corridas ,AVG(cor.kmtotal) as tamanho_medio_corrida,
	max(cor.kmtotal) as tamanho_maior_corrida, min(cor.kmtotal) as tamanho_menor_corrida
	
	FROM ZONA 
	INNER JOIN FILA 
		ON(ZONA.id = FILA.zona)
		
	INNER JOIN MOTORISTA AS MOT
		ON(FILA.CNH = MOT.CNH)
		
	INNER JOIN CORRIDA AS COR
		ON(MOT.PLACA = COR.PLACA)
	
	WHERE 
-- 		ZONA.ZONA = 'Pinto'
-- 	AND
		COR.datapedido between '2000-01-01' and '2020-12-31'
	
	group by zona.zona
	order by tamanho_medio_corrida