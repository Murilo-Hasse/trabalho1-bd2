SELECT c.Nome AS Nome_Cliente, 
       CASE WHEN e.Nome IS NOT NULL THEN e.Nome 
            ELSE f.Nome END AS Nome_Representante, 
       t.Placa, 
       r.DataPedido, 
       r.KMTotal, 
       z.Zona 
FROM Cliente AS c 
LEFT JOIN ClienteEmpresa AS e 
    ON c.CliId = e.CliId 
LEFT JOIN ClienteFisico AS f 
    ON c.CliId = f.CliId 
JOIN Corrida AS r 
    ON c.CliId = r.cliidCliente 
JOIN Taxi AS t 
    ON r.Placa = t.Placa 
JOIN Fila AS l 
    ON t.Placa = l.CNH 
JOIN Zona AS z 
    ON l.Zona = z.id
WHERE r.DataPedido BETWEEN '2024-01-01' AND '2024-03-31'
AND 
    r.KMTotal > 100
ORDER BY 
    r.DataPedido DESC, 
    r.KMTotal DESC;

