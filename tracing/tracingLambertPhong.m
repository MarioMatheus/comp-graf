clear;
clc;

% INSTANCIANDO OS OBJETOS DO ESPA�O #######################################
esferaUm = Esfera;
esferaUm.cor = 100;
esferaUm.raio = 1;
esferaUm.centro = [0 0 0];

esferaDois = Esfera;
esferaDois.cor = 200;
esferaDois.raio = 3.8;
esferaDois.centro = [-2 3 -4];

esferaTres = Esfera;
esferaTres.cor = 150;
esferaTres.raio = 1.5;
esferaTres.centro = [-1 0 0];

poligonoUm = Poligono;
poligonoUm.cor = 1;
poligonoUm.pontos = [[-1 -1 -3]; [-1 3 -3]; [1 2 -1]; [2 -1 -1]];
poligonoUm.normal = cross(poligonoUm.pontos(2,:) - poligonoUm.pontos(1,:), poligonoUm.pontos(1,:) - poligonoUm.pontos(3,:));
poligonoUm.normal = poligonoUm.normal / norm(poligonoUm.normal);

% OS CUBOS AQUI ###########################################################
ladoCubo = 2;
cuboUm = Cubo;
cuboUm.lado = ladoCubo;
cuboUm.centro = [-8 10 -15];

cubos = [cuboUm]; % PRIMEIRO CUBO DO PLOT #################################
centros = [ % CENTRO DE CUBOS ADICIONAIS ##################################
    [-8 12 -15];%[-8 14 -15];
    [-10 10 -15];[-10 12 -15];%[-10 14 -15];
    %[-12 10 -15];[-12 12 -15];[-12 14 -15];
    
    [-8 10 -17]; [-8 12 -17];%[-8 14 -17];
    [-10 10 -17];[-10 12 -17];%[-10 14 -17];
    %[-12 10 -17];[-12 12 -17];[-12 14 -17];
    
    %[-8 10 -19]; [-8 12 -19];[-8 14 -19];
    %[-10 10 -19];[-10 12 -19];[-10 14 -19];
    %[-12 10 -19];[-12 12 -19];[-12 14 -19];
];

% COM BASE NOS CENTRO, CRIA-SE OS CUBOS ###################################
for cubando = 1 : size(centros,1)
    cubo = Cubo;
    cubo.lado = ladoCubo;
    
    cubo.centro = centros(cubando,:);
    cubos(end+1) = cubo;
end

% #########################################################################

pBase = Poligono;
pFrontal = Poligono;
pTraseira = Poligono;
pTopo = Poligono;
pEsquerda = Poligono;
pDireita = Poligono;

initialPoligono = Poligono;
initialPoligono.pontos = [[0 0 0]; [0 0 0]; [0 0 0]; [0 0 0]];
initialPoligono.cor = 0;

listaDeObjetos = [initialPoligono];

% ADICIONANDO NA LISTA DE OBJETOS AS FACES DOS CUBOS ######################
for cubo = 1 : length(cubos)
    [pBase.pontos, pFrontal.pontos, pTraseira.pontos, pTopo.pontos, pEsquerda.pontos, pDireita.pontos] = cuboParaPoligono(cubos(cubo));
    
    corUm = rand*255; corDois = rand*255; corTres = rand*255;
    pBase.cor = corUm; pFrontal.cor = corDois; pTraseira.cor = corTres; pTopo.cor = corUm; pEsquerda.cor = corDois; pDireita.cor = corTres;
   
    listaDeObjetos(end+1) = pBase;
    listaDeObjetos(end+1) = pFrontal;
    listaDeObjetos(end+1) = pTraseira;
    listaDeObjetos(end+1) = pTopo;
    listaDeObjetos(end+1) = pEsquerda;
    listaDeObjetos(end+1) = pDireita;
end

listaDeObjetosAuxiliares = listaDeObjetos;

% INSTANCIANDO AS LUZES DO ESPA�O #########################################
luzUm = Luz;
luzUm.ponto = [2 -2 3];
luzUm.intensidade = 0.003;
luzUm.corEspecular = [255 255 0];

luzDois = Luz;
luzDois.ponto = [2 2 5];
luzDois.intensidade = 0.003;
luzDois.corEspecular = [0,0,255];

luzTres = Luz;
luzTres.ponto = [-8 10 15];
luzTres.intensidade = 0.5;
luzTres.corEspecular = [100,100,50];

listaDeLuzes = [luzUm];

% DECLARANDO ASPECTOS DA IMAGEM ###########################################
nx = 200; ny = 200;                             % Resolu��o da Imagem
left = -5; right = 5; top = 5; bottom = -5;     % �rea da Imagem

pontoDeVisaoE = [2 -2 3];                       % Ponto de Vis�o: 'e'
% 2 -2 3
% -2 2 3

% CALCULANDO A BASE ORTONORMAL UVW ALINHADA COM O VETOR 'e' ###############
normaDeE = norm(pontoDeVisaoE);
vetorW = pontoDeVisaoE / normaDeE;

vetorT = vetorW;
[~,indice] = min(abs(vetorW));  % Identifica o elemento de menor magnitude
vetorT(indice) = 1;             % e atribui a 1

vetorU = cross(vetorT,vetorW);
normaDeU = norm(vetorU);
vetorU = vetorU / normaDeU;

vetorV = cross(vetorW,vetorU);


% DECLARANDO VARIAVEIS PARA O CALCULO DA IMAGEM ###########################
distanciaFocal = 5;
imagemFinal = zeros(nx,ny,3);
imagemFinalFliped = zeros(ny,nx,3);

quantidadeDeObjetos = length(listaDeObjetos);
vetorDeTsMaisProximo = zeros(1,2);

constanteP = 10000;
corDoAmbiente = [255 255 255];
intensidadeDaCorDoAmbiente = 0.0005;

% PAR�METROS DA TRANSFORMA��O #############################################
% teta = 125;
% transformadaDeEscala = [[cos(teta) -sin(teta)]; [sin(teta) cos(teta)]];
% transformadaDeEscala = [[1 0];[0 1]];
fig = figure; hold on;
multiplicadorAngulacao = 5;

for angulo = 1 : 90
    % TENTATIVAS DE ROTACAO - TAKE 6 ##########################################
    % figure, hold on; 
    a = angulo / multiplicadorAngulacao; % 0.001; % em graus
    matrizDeRotacao = [[cos(a) -sin(a) 0]; [sin(a) cos(a) 0]; [0 0 1]];
    matrizRUVW = pontoParaMatrizRUVW(cuboUm.centro);

    for i=1: quantidadeDeObjetos
        % TEM Q SER PONTO POR PONTO DENTRO DOS PONTOS ###############
        
        aux = listaDeObjetosAuxiliares(i).pontos;
        %Plota o cubo antes de rotacionar
    %     aux2 = aux';
    %     aux2 = [aux' aux2(:, 1)];
    %     plot3(aux2(1, :), aux2(2, :), aux2(3, :), '--');
    % 
    %     plot3(aux(1, 1), aux(1, 2), aux(1, 3), '.');
    %     plot3(aux(2, 1), aux(2, 2), aux(2, 3), '.');
    %     plot3(aux(3, 1), aux(3, 2), aux(3, 3), '.');
    %     plot3(aux(4, 1), aux(4, 2), aux(4, 3), '.');

        for j=1 : 4
            % transformacao = matrizRUVW * matrizDeRotacao * matrizRUVW.';
            ponto = aux(j,:).';
            ponto = matrizRUVW * ponto;
            ponto = matrizDeRotacao * ponto;
            ponto = matrizRUVW.' * ponto;
            % ponto = transformacao * ponto;
            ponto = ponto.';
            aux(j,:) = ponto;
        end
        listaDeObjetos(i).pontos = aux;

        %Plota o cubo depois de rotacionar
    %     aux2 = listaDeObjetos(i).pontos';
    %     aux2 = [listaDeObjetos(i).pontos' aux2(:, 1)];
    %     plot3(aux2(1, :), aux2(2, :), aux2(3, :));
    % 
    %     plot3(listaDeObjetos(i).pontos(1, 1), listaDeObjetos(i).pontos(1, 2), listaDeObjetos(i).pontos(1, 3), '*');
    %     plot3(listaDeObjetos(i).pontos(2, 1), listaDeObjetos(i).pontos(2, 2), listaDeObjetos(i).pontos(2, 3), '*');
    %     plot3(listaDeObjetos(i).pontos(3, 1), listaDeObjetos(i).pontos(3, 2), listaDeObjetos(i).pontos(3, 3), '*');
    %     plot3(listaDeObjetos(i).pontos(4, 1), listaDeObjetos(i).pontos(4, 2), listaDeObjetos(i).pontos(4, 3), '*');

        listaDeObjetos(i).normal = cross(listaDeObjetos(i).pontos(2,:) - listaDeObjetos(i).pontos(1,:), listaDeObjetos(i).pontos(1,:) - listaDeObjetos(i).pontos(3,:));
        listaDeObjetos(i).normal = -(listaDeObjetos(i).normal / norm(listaDeObjetos(i).normal));
        if mod(i,6)==3 || mod(i,6)==4
            listaDeObjetos(i).normal = (listaDeObjetos(i).normal) * -1;
        end
    end

    % ALGORITMO DO RAY TRACING ################################################
    for x=80 : nx-80
        for y=80 : ny-80

            posU = left + (right - left) * (x + 0.5) / nx;
            posV = bottom + (top - bottom) * (y + 0.5) / ny;

            % C�LCULOS PARA TRANFORMA��ES #####################################
    %         deslocamentoDeU = left + (right - left) * (1 + 0.5) / nx;
    %         deslocamentoDeV = bottom + (top - bottom) * (ny + 0.5) / ny;
    %         
    %         deslocamentoDeU = abs(deslocamentoDeU);
    %         deslocamentoDeV = abs(deslocamentoDeV);
    %         
    %         % (x,y=0,0) menoxX = 1, maior y = ny
    %         posU = posU + deslocamentoDeU;
    %         posV = posV + deslocamentoDeV;
    %         
    %         posTransformada = transformadaDeEscala * [(posU); (posV)];
    %         
    %         posU = posTransformada(1) - deslocamentoDeU;
    %         posV = posTransformada(2) - deslocamentoDeV;


            % DEFINI��O DO CASO A SER ABORDADO ################################        
            % Caso Obliquo ####################################################
            origem = pontoDeVisaoE;
            direcao = -distanciaFocal*vetorW + posU*vetorU + posV*vetorV;

            % Caso Ortografico ################################################
    %         origem = pontoDeVisaoE + posU*vetorU + posV*vetorV;
    %         direcao = -vetorW;
            for i=1 : quantidadeDeObjetos

                % MAPEANDO OBJETOS POR PIXEL ##################################
                if isa(listaDeObjetos(i),'Esfera')
                    a = dot(direcao,direcao);
                    b = dot(2*direcao,(origem-listaDeObjetos(i).centro));
                    c = dot((origem-listaDeObjetos(i).centro),(origem-listaDeObjetos(i).centro)) - (listaDeObjetos(i).raio^2); 
                    delta = b^2 - 4*a*c;

                    if delta == 0
                        disp('Delta igual a 0 aki');
                    end
                    if delta > 0
                        t1 = (dot(-direcao,origem-listaDeObjetos(i).centro) + sqrt((dot(direcao, origem-listaDeObjetos(i).centro))^2 - a*c)) / a;
                        t2 = (dot(-direcao,origem-listaDeObjetos(i).centro) - sqrt((dot(direcao, origem-listaDeObjetos(i).centro))^2 - a*c)) / a;
                        menorT = min(abs(t1),abs(t2));

                        if vetorDeTsMaisProximo(1) > menorT || vetorDeTsMaisProximo(1) == 0
                            vetorDeTsMaisProximo(1) = menorT;
                            vetorDeTsMaisProximo(2) = i;
                        end

                    end


                elseif isa(listaDeObjetos(i),'Poligono')
                    numerador = dot((listaDeObjetos(i).pontos(1,:) - origem), listaDeObjetos(i).normal);
                    denominador = dot(direcao, listaDeObjetos(i).normal);
                    tDoPoligono = numerador / denominador;

                    pontoASerVerificado = origem + tDoPoligono * direcao;

                    estaNoPoligono = verificaPontoNoPoligono(listaDeObjetos(i).pontos, pontoASerVerificado);

                    if estaNoPoligono == 1
                        if vetorDeTsMaisProximo(1) > tDoPoligono || vetorDeTsMaisProximo(1) == 0
                            vetorDeTsMaisProximo(1) = tDoPoligono;
                            vetorDeTsMaisProximo(2) = i;
                        end
                    end

                end

            end

            % COLORINDO A IMAGEM USANDO CONVERSAO DE HSV PARA RGB #############
            iObjetoMaisProximo = vetorDeTsMaisProximo(2);
            tMaisProximo = vetorDeTsMaisProximo(1);

            % VERIFICANDO OBJETO MAIS PROXIMO #################################
            if iObjetoMaisProximo == 0  %Se n�o h� objeto, pinta-se de preto
                meuHSV = [0 0 0];
                corDoObjeto = hsv2rgb(meuHSV ./ [360, 1, 1]) * 255;
                corDoPixel = corDoObjeto;
            else %Se h� verifica o obj e � calculada a normal
                pontoQueTocaOObjeto = origem + tMaisProximo * direcao;

                if isa(listaDeObjetos(iObjetoMaisProximo),'Esfera')
                    vetorNormal = pontoQueTocaOObjeto - listaDeObjetos(iObjetoMaisProximo).centro;
                    vetorNormal = vetorNormal / norm(vetorNormal);
                elseif isa(listaDeObjetos(iObjetoMaisProximo),'Poligono')
                    vetorNormal = listaDeObjetos(iObjetoMaisProximo).normal;
                end

                corDoPixel = [0 0 0];
                % Ap�s c�culo da normal, � realizado o c�lculo de Lambert ou 
                % Phong realizando o somat�rio para cada luz no ambiente.
                for j=1 : length(listaDeLuzes)
                    pontoDeLuz = listaDeLuzes(j).ponto;
                    corEspecularDaLuz = listaDeLuzes(j).corEspecular;
                    intensidadeDaLuz = listaDeLuzes(j).intensidade;

                    vetorAoPontoDeLuz = pontoDeLuz - pontoQueTocaOObjeto;
                    vetorAoPontoDeLuz = vetorAoPontoDeLuz / norm(vetorAoPontoDeLuz);

                    hue = listaDeObjetos(iObjetoMaisProximo).cor;
                    meuHSV = [hue 1 1];
                    corDoObjeto = hsv2rgb(meuHSV ./ [360, 1, 1]) * 255;

                    parametrosExtras = [0 0 0];


                    % PARA ADICIONAR/REMOVER OS PARAMETROS DO Blinn-Phong DESCOMENTE/COMENTE ABAIXO
                    vetorAoPontoDeVisao = pontoDeVisaoE - pontoQueTocaOObjeto;
                    vetorAoPontoDeVisao = vetorAoPontoDeVisao / norm(vetorAoPontoDeVisao);
                    vetorHalf = (vetorAoPontoDeLuz + vetorAoPontoDeVisao) / norm(vetorAoPontoDeLuz + vetorAoPontoDeVisao);
                    parametrosExtras(1) = corEspecularDaLuz(1) * intensidadeDaLuz * max(0, dot(vetorNormal,vetorHalf))^constanteP + corDoAmbiente(1) * intensidadeDaCorDoAmbiente;
                    parametrosExtras(2) = corEspecularDaLuz(2) * intensidadeDaLuz * max(0, dot(vetorNormal,vetorHalf))^constanteP + corDoAmbiente(2) * intensidadeDaCorDoAmbiente;
                    parametrosExtras(3) = corEspecularDaLuz(3) * intensidadeDaLuz * max(0, dot(vetorNormal,vetorHalf))^constanteP + corDoAmbiente(3) * intensidadeDaCorDoAmbiente;
                    % PARA ADICIONAR/REMOVER OS PARAMETROS DO Blinn-Phong DESCOMENTE/COMENTE ACIMA

                    corDoPixel(1) = corDoPixel(1) + corDoObjeto(1) * intensidadeDaLuz * max(0,dot(vetorNormal,vetorAoPontoDeLuz)) + parametrosExtras(1);
                    corDoPixel(2) = corDoPixel(2) + corDoObjeto(2) * intensidadeDaLuz * max(0,dot(vetorNormal,vetorAoPontoDeLuz)) + parametrosExtras(2);
                    corDoPixel(3) = corDoPixel(3) + corDoObjeto(3) * intensidadeDaLuz * max(0,dot(vetorNormal,vetorAoPontoDeLuz)) + parametrosExtras(3);
                end


            end


            imagemFinal(x,y,1) = corDoPixel(1);
            imagemFinal(x,y,2) = corDoPixel(2);
            imagemFinal(x,y,3) = corDoPixel(3);


            vetorDeTsMaisProximo(1) = 0;
            vetorDeTsMaisProximo(2) = 0;

        end
    end


    % EXIBINDO IMAGEM #########################################################

    imagemFinalFliped(:,:,1) = imagemFinal(:,:,1)';
    imagemFinalFliped(:,:,2) = imagemFinal(:,:,2)';
    imagemFinalFliped(:,:,3) = imagemFinal(:,:,3)';
    imshow(imagemFinalFliped);
    refresh(fig);
    pause(0.0001);
    disp(angulo);
end

