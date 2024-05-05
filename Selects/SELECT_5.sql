-- Desejo deu um relatório que traga somente clientes que percorreram mais de 50 km nos ultimos 12 meses, preciso que esteja informado nesta estrutura se ele é cliente empresa ou
-- Fisico, a quantidade de km percorrida, uma coluna se ele é aprovado como vip e uma ultima coluna de zona.

SELECT 
	CASE 
		WHEN CliPJ.Nome IS NOT NULL THEN CliPJ.Nome 
		ELSE CliPF.Nome 
	END 
	AS Nome_Cliente, 
	CASE 
		WHEN CliPJ.Nome IS NOT NULL THEN 'Empresa' 
		ELSE 'Pessoa Física' 
	END 
	AS Tipo_Cliente,
	SUM(cor.kmtotal) AS kmtotal,
	CASE
		WHEN sum(cor.kmtotal) > 50 THEN 'Cliente Vip'     		
	END 
	AS Aprovado_Vip,
	fila.zona 
FROM cliente AS cli
LEFT JOIN 
	ClienteEmpresa CliPJ ON Cli.CliId = CliPJ.CliId 
LEFT JOIN 
	ClienteFisico CliPF ON Cli.CliId = CliPf.CliId
LEFT JOIN 
	corrida cor ON cor.cliidcliente = cli.cliid 
LEFT JOIN 
	motorista mot ON cor.placa = mot.placa 
LEFT JOIN
	fila ON fila.cnh = mot.cnh 
WHERE
	fila.zona IN (SELECT zona.id FROM zona WHERE zona = 'Pinto' GROUP BY zona.id) 
AND
	cor.datapedido BETWEEN '2023-01-01' AND '2023-12-31' 
GROUP BY clipj.nome, clipf.nome, fila.zona 
HAVING 
CASE 
	WHEN SUM(cor.kmtotal) > 50 THEN 'Cliente Vip'
END = 'Cliente Vip';
