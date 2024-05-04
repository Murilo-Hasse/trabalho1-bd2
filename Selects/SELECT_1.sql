--Necessito extrair uma informação do banco, do qual traga, a contagem de corridas e o total de km percorridos
--por um de nossos taxistas do qual, traga filtro de zona(nome da zona), o periodo e o nome do taxista em questão.
SELECT count(*) as Quantidade_de_corridas,SUM(COR.kmtotal) as Total_de_Kms_percorridos
FROM CORRIDA AS COR

	INNER JOIN MOTORISTA AS MOT
		ON(COR.PLACA = MOT.PLACA)
	INNER JOIN FILA
		ON(MOT.CNH = FILA.CNH)
	INNER JOIN zona
		ON (zona.id = FILA.Zona)
WHERE
	zona.zona = 'Farias Grande'
AND
	COR.Datapedido between '01-01-1995' and '31-12-2022'
AND
	MOT.Nome = 'Bernardo Mendes';
