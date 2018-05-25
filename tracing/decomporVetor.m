
function [vetorRotacao, vetorEscala, vetorRotacaoReverso] = decomporVetor(matriz)

% componentes auxiliares ##################################################
I = eye(2);
isUnique = false;

% coeficientes da equacao baseada na matrizA ##############################
a = 1;
b = -(matriz(1,1)+matriz(2,2));
c = matriz(1,1)*matriz(2,2)-matriz(2,1)*matriz(1,2);

% bhaskara trivial ########################################################
delta = b^2 - 4*a*c;
if delta < 0
   disp('Não possui raiz');
elseif delta == 0
    disp('Raiz unica, talvez bugue');
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
autoMatrizX = matriz - matriz1;
autoMatrizY = matriz - matriz2;

% obtendo autovetor associado #############################################
% matriz * [x ; y] = [0; 0]

x = 1;
y = -(autoMatrizX(1,1) * x);
autoVetorX = [x;y];
autoVetorX = autoVetorX / norm(autoVetorX);

x = 1;
y = -(autoMatrizY(1,1) * x);
autoVetorY = [x;y];
autoVetorY = autoVetorY / norm(autoVetorY);

% obtendo matrizes resultantes da decomposicao ############################

rodaUm = [ [autoVetorX(1) autoVetorY(1)] ; [autoVetorX(2) autoVetorY(2)] ];
diag = [ [raiz1 0] ; [0 raiz2] ];
rodaDois = rodaUm.';

% debugs ##################################################################

disp('para lambda 1');
disp('    lambda');
disp(raiz1);
disp('    matriz');
disp(autoMatrizX);
disp('    autovetor');
disp(autoVetorX);
disp('para lambda 2');
disp('    lambda');
disp(raiz2);
disp('    matriz');
disp(autoMatrizY);
disp('    autovetor');
disp(autoVetorY);

% retornos ################################################################
vetorRotacao = rodaUm;
vetorEscala = diag;
vetorRotacaoReverso = rodaDois;

end

