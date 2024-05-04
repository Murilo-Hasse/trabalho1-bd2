--“Desejamos oferecer a nossos clientes com maior incidência um serviço VIP do qual destinará a nova frota 
--de taxis VIP, para isto preciso de um relatório que retorne a posição de clientes por zona, da qual retorna 
--os clientes que fizeram maior KM por corrida. Preciso que hajam filtros por:
--Zona;
--Data;“
--Posição de clientes por zona (TOP 5) - Maior KM

select clipj.nome as clientePJ, sum(cor.kmtotal) as totalKM
    from corrida cor
    inner join
        cliente cli on (cor.cliidcliente = cli.cliid)
    inner join
--         clientefisico cliPF on (cli.cliid = cast(cliPF.cliid as bigint))
--     inner join
        clienteempresa cliPJ on (cli.cliid = cast(cliPJ.cliid as bigint))
    inner join
        motorista mot on (mot.placa = cor.placa)
    inner join
        fila on(fila.cnh = mot.cnh)
	group by clientePJ;
