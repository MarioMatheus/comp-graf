clear;
clc;

% INSTANCIANDO OS OBJETOS DO ESPAÇO #######################################
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

cuboMagico = Cubo;
cuboMagico.lado = 10;
cuboMagico.centro = [-8 10 -15];

% pontosDoPoligonos = cuboParaPoligono(cuboTeste);
quadradoBase = Poligono;
quadradoTopo = Poligono;
quadradoFrontal = Poligono;
quadradoTraseira = Poligono;
quadradoEsquerda = Poligono;
quadradoDireita = Poligono;

[quadradoBase.pontos, quadradoFrontal.pontos, quadradoTraseira.pontos, quadradoTopo.pontos, quadradoEsquerda.pontos, quadradoDireita.pontos] = cuboParaPoligono(cuboMagico);

quadradoBase.cor = 100;
quadradoBase.normal = cross(quadradoBase.pontos(2,:) - quadradoBase.pontos(1,:), quadradoBase.pontos(1,:) - quadradoBase.pontos(3,:));
quadradoBase.normal = -(quadradoBase.normal / norm(quadradoBase.normal));

quadradoTopo.cor = 100;
quadradoTopo.normal = cross(quadradoTopo.pontos(2,:) - quadradoTopo.pontos(1,:), quadradoTopo.pontos(1,:) - quadradoTopo.pontos(3,:));
quadradoTopo.normal = -(quadradoTopo.normal / norm(quadradoTopo.normal));

quadradoFrontal.cor = 100;
quadradoFrontal.normal = cross(quadradoFrontal.pontos(2,:) - quadradoFrontal.pontos(1,:), quadradoFrontal.pontos(1,:) - quadradoFrontal.pontos(3,:));
quadradoFrontal.normal = quadradoFrontal.normal / norm(quadradoFrontal.normal);


quadradoTraseira.cor = 100;
quadradoTraseira.normal = cross(quadradoTraseira.pontos(2,:) - quadradoTraseira.pontos(1,:), quadradoTraseira.pontos(1,:) - quadradoTraseira.pontos(3,:));
quadradoTraseira.normal = quadradoTraseira.normal / norm(quadradoTraseira.normal);


quadradoEsquerda.cor = 100;
quadradoEsquerda.normal = cross(quadradoEsquerda.pontos(2,:) - quadradoEsquerda.pontos(1,:), quadradoEsquerda.pontos(1,:) - quadradoEsquerda.pontos(3,:));
quadradoEsquerda.normal = -(quadradoEsquerda.normal / norm(quadradoEsquerda.normal));


quadradoDireita.cor = 100;
quadradoDireita.normal = cross(quadradoDireita.pontos(2,:) - quadradoDireita.pontos(1,:), quadradoDireita.pontos(1,:) - quadradoDireita.pontos(3,:));
quadradoDireita.normal = -(quadradoDireita.normal / norm(quadradoDireita.normal));



% listaDeObjetos = [esferaUm, esferaDois, poligonoUm, esferaTres];
listaDeObjetos = [quadradoBase, quadradoTopo, quadradoFrontal, quadradoTraseira, quadradoEsquerda, quadradoDireita];

% INSTANCIANDO AS LUZES DO ESPAÇO #########################################
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
nx = 200; ny = 200;                             % Resolução da Imagem
left = -5; right = 5; top = 5; bottom = -5;     % Área da Imagem

pontoDeVisaoE = [2 -2 3];                       % Ponto de Visão: 'e'
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

% PARÂMETROS DA TRANSFORMAÇÃO #############################################
% teta = 125;
% transformadaDeEscala = [[cos(teta) -sin(teta)]; [sin(teta) cos(teta)]];
% transformadaDeEscala = [[1 0];[0 1]];


% ALGORITMO DO RAY TRACING ################################################
for x=1 : nx
    for y=1 : ny
        
        posU = left + (right - left) * (x + 0.5) / nx;
        posV = bottom + (top - bottom) * (y + 0.5) / ny;
        
        % CÁLCULOS PARA TRANFORMAÇÕES #####################################
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


        % DEFINIÇÃO DO CASO A SER ABORDADO ################################        
        % Caso Obliquo ####################################################
        origem = pontoDeVisaoE;
        direcao = -distanciaFocal*vetorW + posU*vetorU + posV*vetorV;
        
        % Caso Ortografico ################################################
%         origem = pontoDeVisaoE + posU*vetorU + posV*vetorV;
%         direcao = -vetorW;
        
        for i=1 : quantidadeDeObjetos
            
            % TENTATIVAS DE ROTACAO - TAKE 2 ##############################
%             anguloDeRotacao = 30; % em graus
%             a = anguloDeRotacao;
%             matrizDeRotacao = [[cos(a) -sin(a) 0]; [sin(a) cos(a) 0]; [0 0 1]];
%             matrizRUVW = pontoParaMatrizRUVW(cuboMagico.centro);
%             
%             % TEM Q SER PONTO POR PONTO DENTRO DOS PONTOS #################
%             for p=1 : 4
%                 top = listaDeObjetos(i).pontos;
%                 um = top(p,:);
%             end
%             
%             listaDeObjetos(i).pontos = (listaDeObjetos(i).pontos) * matrizRUVW;
%             listaDeObjetos(i).pontos = (listaDeObjetos(i).pontos) * matrizDeRotacao;
%             listaDeObjetos(i).pontos = (listaDeObjetos(i).pontos) * matrizRUVW.';
%             
%             listaDeObjetos(i).normal = cross(listaDeObjetos(i).pontos(2,:) - listaDeObjetos(i).pontos(1,:), listaDeObjetos(i).pontos(1,:) - listaDeObjetos(i).pontos(3,:));
%             listaDeObjetos(i).normal = -(listaDeObjetos(i).normal / norm(listaDeObjetos(i).normal));

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
        if iObjetoMaisProximo == 0  %Se não há objeto, pinta-se de preto
            meuHSV = [0 0 0];
            corDoObjeto = hsv2rgb(meuHSV ./ [360, 1, 1]) * 255;
            corDoPixel = corDoObjeto;
        else %Se há verifica o obj e é calculada a normal
            pontoQueTocaOObjeto = origem + tMaisProximo * direcao;

            if isa(listaDeObjetos(iObjetoMaisProximo),'Esfera')
                vetorNormal = pontoQueTocaOObjeto - listaDeObjetos(iObjetoMaisProximo).centro;
                vetorNormal = vetorNormal / norm(vetorNormal);
            elseif isa(listaDeObjetos(iObjetoMaisProximo),'Poligono')
                vetorNormal = listaDeObjetos(iObjetoMaisProximo).normal;
            end
            
            corDoPixel = [0 0 0];
            % Após cáculo da normal, é realizado o cálculo de Lambert ou 
            % Phong realizando o somatório para cada luz no ambiente.
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

figure, imshow(imagemFinalFliped);
