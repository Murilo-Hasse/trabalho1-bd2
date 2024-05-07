-- "Perdi minhas chaves em um dos taxis, preciso saber quem é o motorista para poder comunicar a ele, seria possivel me indicar a lista de motoristas
-- que tive corrida, junto a data desta corrida em questão?"
-- Relatório que traga por clientes todos os motoristas que ele teve corrida, junto com a data da corrida em questão
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
) AS Subconsulta
WHERE cliente_nome LIKE '%Leonardo%'
