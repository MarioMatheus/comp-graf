clc;
clear;

% matriz = [2 1 0; 4 7 -2; -3 0 -1];
% resultadoDaDeterminante = det(matriz);
% 
% disp(matriz);
% disp(['Deteminante: ', num2str(resultadoDaDeterminante)]);

p1 = [0 0 0];
p2 = [-2 3 -4];
p3 = [-1 0 0];

% p4 = [-3 -1 0];

pontoASerVerificado = [2.148069635081391 -2.205546145629032 2.940728194172042];

pontosDoPoligono = [p1; p2; p3];


% disp(pontosDoPoligono(2,:));
% disp( size(pontosDoPoligono,1) );

estaDentro = verificaPontoNoPoligono(pontosDoPoligono, pontoASerVerificado);
if estaDentro
    disp('O ponto esta dentro do poligono');
else
    disp('O ponto esta fora do poligono');
end
