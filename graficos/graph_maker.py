import matplotlib, matplotlib.pyplot as plt
from typing import List

matplotlib.use('TkAgg')

class PlotIndexGraph:
    def __init__(self, color_pallette_hex: List[str], labels: List[str]) -> None:
        self.__color_pallette = color_pallette_hex
        self.__labels = labels
        
        assert len(color_pallette_hex) == len(labels), "O tamanho da lista de paleta de cores deve ser o mesmo tamanho da lista de labels"


    def plot_and_show(self, values: List[float], graph_precision: int, title: str, font_size: int, x_label: str, y_label: str) -> None:
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
    labels = ['Sem Índice', 'HASH', 'BTREE', 'BRIN', 'GIN', 'GIST']
    color_pallette = ['#1B51F2', '#1D79F2', '#22A2F2', '#F2CF1D', '#1D79F2', '#1B51F2']
    
    
    values_select_1 = [13.22, 13.14, 11.50, 13.86, 13.56, 15.18]
    values_select_2 = [118.02, 432.94, 353.56, 381.22, 371.85, 371.56]
    values_select_3 = [227.36, 234.17, 230.55, 224.25, 225.26, 223.69]
    values_select_4 = [18.40, 13.85, 14.00, 13.29, 13.13, 13.94]
    values_select_5 = [16.05, 17.44, 7.36, 19.96, 19.46, 20.74]
    
    
    graph_select_1 = PlotIndexGraph(color_pallette, labels)
    
    graph_select_1.plot_and_show(values=values_select_5, 
                                 graph_precision=10, 
                                 title='SELECT 5', 
                                 font_size=32,
                                 x_label='Tipo de Índice',
                                 y_label='Tempo Médio (ms)')

    