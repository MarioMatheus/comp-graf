clear;
clc;


a = []; b = 3;

a(end+1) = b;
a(end+1) = b;
a(end+1) = b;
centros = [[-8 12 -15]];
disp(centros(1,:));


% anguloDeRotacao = 30; % em graus
% a = anguloDeRotacao;
% matrizDeRotacao = [[cos(a) -sin(a) 0]; [sin(a) cos(a) 0]; [0 0 1]];
% matrizRUVW = pontoParaMatrizRUVW([5 5 5]);
% 
% p1 = Poligono;
% p2 = Poligono;
% p1.pontos = [[5 5 6]; [3 4 5]; [6 7 8]; [9 10 11]];
% p2.pontos = [[01 11 12]; [31 14 51]; [16 71 81]; [19 110 111]];
% 
% lista = [p1, p2];
% 
% disp(lista(1).pontos);
% disp(lista(2).pontos);
% 
% for i=1 : length(lista)
%     aux = lista(i).pontos;
%     for j=1 : 4
%         transformacao = matrizRUVW * matrizDeRotacao * matrizRUVW.';
%         ponto = aux(j,:).';
%         ponto = transformacao * ponto;
%         ponto = ponto.';
%         aux(j,:) = ponto;
%     end
%     lista(i).pontos = aux;
% end
% 
% disp(lista(1).pontos);
% disp(lista(2).pontos);
