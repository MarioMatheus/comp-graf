clc;
clear;
matrizA = [2 1; 1 1];

% componentes auxiliares ##################################################
I = eye(2);
isUnique = false;

% coeficientes da equacao baseada na matrizA ##############################
a = 1;
b = -(matrizA(1,1)+matrizA(2,2));
c = matrizA(1,1)*matrizA(2,2)-matrizA(2,1)*matrizA(1,2);

% bhaskara trivial ########################################################
delta = b^2 - 4*a*c;
if delta < 0
   disp('Não possui raiz'); 
elseif delta == 0
    raizUnica = -b/a;
    matriz1 = I*raizUnica;
    matriz2 = I*raizUnica;
    isUnique = true;
else
    raiz1 = (-b + sqrt(delta))/2*a;
    raiz2 = (-b - sqrt(delta))/2*a;
    matriz1 = I*raiz1;
    matriz2 = I*raiz2;
end

% matrizes com autovalores ################################################
autoMatrizX = matrizA - matriz1;
autoMatrizY = matrizA - matriz2;

% autoMatrizX * [X;Y] = x1y1;
% autoMatrizY * [X;Y] = x2y2;
% matrizS = x1y1:x2y2;
% matrizST = matrizS^-1;
% 
% if isUnique == true
%    matrizD = [raizUnica 0;0 raizUnica];
% else
%     matrizD = [raiz1 0; 0 raiz2];
% end
