## Trabalho 1 - Banco de Dados 2
Este repositório contém os arquivos referentes ao primeiro trabalho desenvolvido a partir do terceiro semestre do curso de Engenharia de Software, sob a supervisão do professor Erinaldo Pereira.

### Detalhamento do Trabalho
1. Banco de Dados Taxi: Criação do banco de dados no Moodle. É permitido acrescentar atributos, mas não retirar elementos.
2. População do Banco: População do banco com até 10.000 registros por tabela.
3. Consultas Complexas: Desenvolvimento de consultas complexas (nível médio-alto), com um mínimo de 5 consultas. Cada consulta foi executada 100 vezes para obter a média de execução.
4. Criação de Índices: Para cada consulta, foi criado um tipo de índice. Os tipos de índices utilizados foram:
C1.1 - HASH
C1.2 - BTREE
C1.3 - GIN
C1.4 - BRIN
C1.5 - GIST
5. Comparação de Tempo de Execução dos Índices: Foi realizado um gráfico comparando os tempos médios de execução de cada tipo de índice.
6. Detalhamento da Escolha dos Índices: Foram detalhadas as razões pelas quais cada tipo de índice foi escolhido em relação aos outros, considerando as consultas realizadas e os resultados obtidos.
7. Análise dos Tamanhos dos Índices Gerados: Foi plotado um gráfico com os tamanhos dos índices gerados e uma análise dos mesmos.
### Integrantes do Grupo
Murilo Hasse
Matheus Antonio
Paulo Fontana
Leonardo Santana
Rodrigo Vanchtchuk


1. Criação banco:
    Durante criação do banco utilizamos modelo relacional base disponibilizado pelo professor para criação.
![image](https://github.com/Murilo-Hasse/trabalho1-bd2/assets/53916135/c87793db-b3a2-4f35-aa7f-b41699628e61)

Também tinhamos como base a criação base deste modelo, do qual poderiamos fazer alterações para estruturação do mesmo, estes scripts podem ser encontrados a partir da pasta scriptsSQL/CreateProfessor.sql.
  Ao avaliarmos como gostariamos de fazer este trabalho, algumas ideias surgiram, dentre elas a que mais se destacou seria a utilização da tabela apontada no modelo relacional, que parecia excluida na criação do banco, que era a ClienteEmpresa. Para isto, foi agregado ao banco a tabela ClienteFísico e ajustado para que tanto clienteEmpresa quanto clienteFisico relacionassem com tabela Cliente.
A partir disso foi desenvolvida uma trigger para que sempre que houvesse inclusão de dados em clienteFisico ou clienteEmpresa fosse criado esses dados para tabela Cliente e devido cliente ser bigserial, a partir da procedure chamada com a trigger, foi possivel atualizar o id de registro destas tabelas não perdendo assim o identificador de clientes.
Outros ajustes foram realizados, mudando tabelas de varchar para int e a criação de colunas que possibilitassem a melhor comunicação do banco.
O modelo lógico final ficou do seguinte modo:

![Imagem do WhatsApp de 2024-05-06 à(s) 16 33 47_d5a7a4c8](https://github.com/Murilo-Hasse/trabalho1-bd2/assets/53916135/2ed1a578-0260-4661-9a9c-1d92ca7032ea)


3. População do Banco:
   Para processo de população do banco, decidimos utilizar a biblioteca Faker do python, da qual possibilitaria a criação dos inserts disponiveis a partir da pasta scriptsSQL/Inserts. Os scripts estão ordenados com a numeração entre parenteses, devendo ser rodados sequencialmente para criação devida.

4. Desenvolvimento consultas:
  O desenvolvimento de consultas se baseou no desenvolvimento de história de usuários para levantamento das necessidades dos mesmos, o que possiblitou enrriquecer nossas consultas simulando problemas reais. Pela utilização dos indices ser especifica para alguns tipos de problemas, decidimos optar por consultas que partissem de caminhos lógicos para filtragem de valores numéricos e em outros casos para filtragem de valores do tipo texto. Optamos por uma abordagem complicando mais a construção a cada select afim de que tivessemos diferentes resultados.

5. Criação de Índices:
   Para criação dos indices, optamos por utilizar todos campos possiveis, afim de não limitar indices que trabalham somente com textos em consultas que detém em sua maioria de campos do tipo numéricos.
Os indices ficaram com seguinte geração:
### Select 1
    O primeiro Select tem o objetivo de extrair as contagens de corridas e o total da quilometragem percorrida, pensamos no caso de um gestor necessita averiguar se um taxista em específico está de fato realizando as corridas nos períodos que detém de trabalho e se as corridas na zona em questão estão sendo lucrativas baseado na km.

![image](https://github.com/Murilo-Hasse/trabalho1-bd2/assets/53916135/4d569f86-01d6-4bcb-9d63-4ab9d3ef61dd)
![image](https://github.com/Murilo-Hasse/trabalho1-bd2/assets/53916135/e923c599-5e46-4178-b56d-1781b38c6b02)
### Select 2
    O intuito desse Select é buscar contagem de corrida, tamanho médio das corridas, maior corrida e menor corrida. Utilizando o filtro de data(data inferior e a data seguinte). KM médio por corrida, MAX corrida, MIN corrida. Neste select tivemos a menor optimização através de índices, trazendo valores até 4x maior do que a busca sequencial.
    
![image](https://github.com/Murilo-Hasse/trabalho1-bd2/assets/53916135/1a410879-f597-454c-9f5b-17a72a79ba5d)
![image](https://github.com/Murilo-Hasse/trabalho1-bd2/assets/53916135/87f98e14-248a-4f3e-b6b4-bbab5d6d16d6)
### Select 3
    Este Select irá trazer um relatório relacionado às consultas de tempo dos motoristas. Trará motorista, placa do seu carro, tempo máximo de espera em fila, tempo médio de espera em fila, marca do táxi + modelo do táxi. No select em questão desejávamos utilizar uma concatenação de um campo, a fim de que a partir dela os filtros que se beneficiam de texto, pudessem  mostrar sua diferença, neste caso, porém o ocorrido foi que os valores númericos tiveram melhor resultado, sendo o select sem indice superior a todos.

    
![image](https://github.com/Murilo-Hasse/trabalho1-bd2/assets/53916135/fcbfdd35-ac4f-46cc-acff-9553b65ac0f6)\
![image](https://github.com/Murilo-Hasse/trabalho1-bd2/assets/53916135/4d65db3c-a87b-440b-b158-8f18068c434a)
### Select 4
    Para select 4 decidimos optar por realizar algumas consultas um pouco diferente, realizando assim, uma subquery, esta que busca retornar 3 informações básicas da corrida. 

![image](https://github.com/Murilo-Hasse/trabalho1-bd2/assets/53916135/1ef5fdc6-13d4-405a-92a1-45829fe46023)
![image](https://github.com/Murilo-Hasse/trabalho1-bd2/assets/53916135/7a148804-4bb2-45e4-9ed7-9bd781614a57)
### Select 5
    Esse último select foi para selecionar os melhores clientes dos últimos 12 meses, onde retornou se é cliente empresa ou cliente físico, a quantidade de Km percorrida, se ele é aprovado como vip e por último a coluna de zona.

        
![image](https://github.com/Murilo-Hasse/trabalho1-bd2/assets/53916135/38866360-3a10-4de8-8920-e6d8271f8862)
![image](https://github.com/Murilo-Hasse/trabalho1-bd2/assets/53916135/aef1fd51-287c-4b69-998c-f645510f3d5c)

OBS:
  Para todos selects é perceptível a utilização base de filtros de data, pois em quase todos problemas sugeridos no grupo ou ideias vindo de relatórios já criados, a data é recorrente. Como forma de evitar isso, decidimos incluir sempre que necessário(evitar o uso de data) um where secundário, que possibilitaria a plena optimização dos índices que não utilizam data, como caso do GIN e GIST. Para casos mais extremos, optamos por fazer o select buscando que não somente fossem utilizadas colunas diferentes, bem como, técnicas de complexidade distintas.


