-- Desejo deu um relatório que traga somente clientes que percorreram mais de 50 km nos ultimos 12 meses, preciso que esteja informado nesta estrutura se ele é cliente empresa ou
-- Fisico, a quantidade de km percorrida, uma coluna se ele é aprovado como vip e uma ultima coluna de zona.

SELECT CASE 
           WHEN CliPJ.Nome IS NOT NULL THEN CliPJ.Nome 
           ELSE CliPF.Nome 
       END AS Nome_Cliente, 
       CASE 
           WHEN CliPJ.Nome IS NOT NULL THEN 'Empresa' 
           ELSE 'Pessoa Física' 
       END AS Tipo_Cliente,
       sum(cor.kmtotal) as kmtotal,
       Case
       		when sum(cor.kmtotal) > 50 then 'Cliente Vip'     		
       end as Aprovado_Vip,
		fila.zona 
       
    from cliente as cli
	
    LEFT JOIN 
		ClienteEmpresa CliPJ ON Cli.CliId = CliPJ.CliId 
	LEFT JOIN 
		ClienteFisico CliPF ON Cli.CliId = CliPf.CliId
	left join 
		corrida cor on cor.cliidcliente = cli.cliid 
	left join 
		motorista mot on cor.placa = mot.placa 
	left join
		fila on fila.cnh = mot.cnh 
	where
		fila.zona in (select zona.id from zona where zona = 'Pinto' group by zona.id) and
		cor.datapedido between '2023-01-01' and '2023-12-31' 
	group by clipj.nome, clipf.nome, fila.zona 
	having case 
		when sum(cor.kmtotal) > 50 then 'Cliente Vip'
	end = 'Cliente Vip';
	
