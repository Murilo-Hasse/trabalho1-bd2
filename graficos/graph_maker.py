import matplotlib, matplotlib.pyplot as plt
from typing import List

matplotlib.use('TkAgg')

class PlotIndexGraph:
    def __init__(self, color_pallette_hex: List[str], labels: List[str]) -> None:
        self.__color_pallette = color_pallette_hex
        self.__labels = labels
        
        assert len(color_pallette_hex) == len(labels), "O tamanho da lista de paleta de cores deve ser o mesmo tamanho da lista de labels"
        ]


    def plot_and_show(self, values: list, graph_precision: int, title: str, font_size: int, x_label: str, y_label: str) -> None:
        assert len(values) == len(labels), "A lista de valores deve conter tamanho igual a lista de labels"
        assert all(isinstance(i, float | int) for i in values), "A lista de valores deve conter apenas valores numéricos"
        
        
        y_ticks = [float(i) for i in range(0, int(max(values) * 1.5), graph_precision)]
        
        y_ticks.extend(values)
        y_ticks.sort()
        
        bars = plt.bar(self.__labels, values)
        plt.yticks(y_ticks)
        
        
        [bar.set_color(self.__color_pallette[idx]) for idx, bar in enumerate(bars)]
        
        plt.title(title, fontdict={'fontsize': font_size})
        
        plt.ylabel(y_label, fontdict={'fontsize': font_size - font_size // 2})
        plt.xlabel(x_label, fontdict={'fontsize': font_size - font_size // 2})
        
        plt.show()  

if __name__ == '__main__':
    labels = ['Sem Índice', 'HASH', 'BTREE', 'GIN', 'GIST', 'BRIN']
    color_pallette = ['#1B51F2', '#1D79F2', '#22A2F2', '#F2CF1D', '#1D79F2', '#1B51F2']
    
    font_size = 32
    
    
    values_select_1 = [13.22, 13.14, 11.50, 13.86, 13.56, 15.18]
    values_select_2 = [1.27, 1.53, 3.26, 0.57, 0.96, 1.60]
    values_select_3 = [10.20, 12.17, 10.94, 12.33, 12.53, 12.60]
    values_select_4 = [18.40, 13.85, 14.00, 13.29, 13.13, 13.94]
    values_select_5 = [16.05, 17.44, 7.36, 19.96, 19.46, 20.74]
    
    
    graph_select_1 = PlotIndexGraph(color_pallette, labels)
    
    graph_select_1.plot_and_show(values=values_select_1, graph_precision=10, title='Tempo médio de execução SELECT 1', font_size=font_size, x_label='Tipo de Índice', y_label='Tempo médio (Em MS)')
    graph_select_1.plot_and_show(values=values_select_2, graph_precision=5, title='Tempo médio de execução SELECT 2', font_size=font_size, x_label='Tipo de Índice', y_label='Tempo médio (Em MS)')
    graph_select_1.plot_and_show(values=values_select_3, graph_precision=17, title='Tempo médio de execução SELECT 3', font_size=font_size, x_label='Tipo de Índice', y_label='Tempo médio (Em MS)')
    graph_select_1.plot_and_show(values=values_select_4, graph_precision=12, title='Tempo médio de execução SELECT 4', font_size=font_size, x_label='Tipo de Índice', y_label='Tempo médio (Em MS)')
    graph_select_1.plot_and_show(values=values_select_5, graph_precision=10, title='Tempo médio de execução SELECT 5', font_size=font_size, x_label='Tipo de Índice', y_label='Tempo médio (Em MS)')
        
    labels = ['HASH', 'BTREE', 'GIN', 'GIST', 'BRIN']
    color_pallette = ['#1B51F2', '#1D79F2', '#22A2F2', '#F2CF1D', '#1D79F2']    
        
    graph_size_1 = [6889472, 2695168, 1695744, 4997120, 196608]
    graph_size_2 = [10125312, 3195776, 2293760, 6373376, 344064]
    graph_size_3 = [6668288, 4046848, 1081344, 2998272, 294912]
    graph_size_4 = [4276224, 1916928, 606208, 1220608, 245760]
    graph_size_5 = [11681792, 4833280, 2433024, 6438912, 442368]
        
    graph_size = PlotIndexGraph(color_pallette, labels)
    graph_size.plot_and_show(values=graph_size_1, graph_precision=5_000_000, title='Tamanho de Índices do SELECT 1', font_size=font_size, x_label='Tipo de Índice', y_label='Tamanho do Índice(em Bytes)')
    graph_size.plot_and_show(values=graph_size_2, graph_precision=5_000_000, title='Tamanho de Índices do SELECT 2', font_size=font_size, x_label='Tipo de Índice', y_label='Tamanho do Índice(em Bytes)')
    graph_size.plot_and_show(values=graph_size_3, graph_precision=5_000_000, title='Tamanho de Índices do SELECT 3', font_size=font_size, x_label='Tipo de Índice', y_label='Tamanho do Índice(em Bytes)')
    graph_size.plot_and_show(values=graph_size_4, graph_precision=5_000_000, title='Tamanho de Índices do SELECT 4', font_size=font_size, x_label='Tipo de Índice', y_label='Tamanho do Índice(em Bytes)')
    graph_size.plot_and_show(values=graph_size_5, graph_precision=5_000_000, title='Tamanho de Índices do SELECT 5', font_size=font_size, x_label='Tipo de Índice', y_label='Tamanho do Índice(em Bytes)')


    