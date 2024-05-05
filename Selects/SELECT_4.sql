SELECT 
    cliente_nome,
    nome_motorista,
    DATA_Corrida
FROM (
    SELECT 
        CASE 
            WHEN clipj.nome IS NOT NULL THEN clipj.nome
            ELSE clipf.nome
        END AS cliente_nome,
        mot.nome AS nome_motorista,
        cor.datapedido AS DATA_Corrida
    FROM cliente Cli
    LEFT JOIN clienteempresa clipj USING (cliid)
    LEFT JOIN clientefisico clipf USING (cliid)
    LEFT JOIN corrida cor ON (cor.cliidcliente = cli.cliid)
    LEFT JOIN taxi USING (placa)
    LEFT JOIN motorista mot USING (placa)
    GROUP BY clipj.nome, clipf.nome, nome_motorista, cor.datapedido
) AS subquery
WHERE cliente_nome LIKE '%Leonardo%'
