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
%[1 -1 -1]; [-1 0 -1]; [1 1 -1]; [2 0 -1]
poligonoUm.normal = cross(poligonoUm.pontos(2,:) - poligonoUm.pontos(1,:), poligonoUm.pontos(1,:) - poligonoUm.pontos(3,:));
poligonoUm.normal = poligonoUm.normal / norm(poligonoUm.normal);

listaDeObjetos = [esferaUm, esferaDois, poligonoUm, esferaTres];

% INSTANCIANDO AS LUZES DO ESPA�O #########################################
luzUm = Luz;
luzUm.ponto = [2 -2 3];
luzUm.intensidade = 0.003;
luzUm.corEspecular = [255 255 0];

luzDois = Luz;
luzDois.ponto = [2 2 5];
luzDois.intensidade = 0.003;
luzDois.corEspecular = [0,0,255];

listaDeLuzes = [luzUm, luzDois];

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

% tsPoligonais = zeros(nx,ny);

quantidadeDeObjetos = length(listaDeObjetos);

vetorDeTsMaisProximo = zeros(1,2);

% pontoDeLuz = [2 -2 3];
% 2 2 5
% intensidadeDaLuz = 0.003;
% corEspecularDaLuz = [255 255 0]; % 254,178,76
constanteP = 10000;
corDoAmbiente = [255 255 255];
intensidadeDaCorDoAmbiente = 0.0002;

% teta = 125;
% transformadaDeEscala = [[cos(teta) -sin(teta)]; [sin(teta) cos(teta)]];

% descomentar para aplicar a transformacao
% transformadaDeEscala = [[1 0];[0 1]];

% figure, hold on;
% 
% pp1 = poligonoUm.pontos(1,:);
% pp2 = poligonoUm.pontos(2,:);
% pp3 = poligonoUm.pontos(3,:);
% 
% plot3(pp1(1),pp1(2),pp1(3),'r*');
% plot3(pp2(1),pp2(2),pp2(3),'r*');
% plot3(pp3(1),pp3(2),pp3(3),'r*');
% 

% sphere();
% [x,y,z] = sphere;
% surf(x,y,z);
% surf(x*2-2,y*2+3,z*2-4);
% axis equal;
% daspect([1 1 1]);
% plot3(pontoDeVisaoE(1),pontoDeVisaoE(2),pontoDeVisaoE(3),'bo');
% plot3(pontoDeLuz(1),pontoDeLuz(2),pontoDeLuz(3),'g*');

% ALGORITMO DO RAY TRACING ################################################
for x=1 : nx
    for y=1 : ny
        
        posU = left + (right - left) * (x + 0.5) / nx;
        posV = bottom + (top - bottom) * (y + 0.5) / ny;
        
%         if x==1 && y == ny
%             disp(posU);
%             disp(posV);
%         end
        
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
% %         posTransformada = [[1 0.4];[0 1]] * [(posTransformada(1)); (posTransformada(2))];
%         
%         posU = posTransformada(1) - deslocamentoDeU;
%         posV = posTransformada(2) - deslocamentoDeV;

        
        % Caso Obliquo ####################################################
        origem = pontoDeVisaoE;
        direcao = -distanciaFocal*vetorW + posU*vetorU + posV*vetorV;
        
        % Caso Ortografico ################################################
%         origem = pontoDeVisaoE + posU*vetorU + posV*vetorV;
%         direcao = -vetorW;
        
        for i=1 : quantidadeDeObjetos

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
%                 quiver3(origem(1),origem(2),origem(3), direcao(1),direcao(2),direcao(3),tDoPoligono);   
                
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
        
        if iObjetoMaisProximo == 0
            meuHSV = [0 0 0];
            corDoObjeto = hsv2rgb(meuHSV ./ [360, 1, 1]) * 255;
            corDoPixel = corDoObjeto;
        else
            pontoQueTocaOObjeto = origem + tMaisProximo * direcao;
%             quiver3(origem(1),origem(2),origem(3), direcao(1),direcao(2),direcao(3),tMaisProximo)
%             plot3(pontoQueTocaOObjeto(1),pontoQueTocaOObjeto(2),pontoQueTocaOObjeto(3),'r*')

            if isa(listaDeObjetos(iObjetoMaisProximo),'Esfera')
                vetorNormal = pontoQueTocaOObjeto - listaDeObjetos(iObjetoMaisProximo).centro;
                vetorNormal = vetorNormal / norm(vetorNormal);
            elseif isa(listaDeObjetos(iObjetoMaisProximo),'Poligono')
%                 vetorNormal = abs(listaDeObjetos(iObjetoMaisProximo).normal);
                vetorNormal = listaDeObjetos(iObjetoMaisProximo).normal;
            end
            
            
            corDoPixel = [0 0 0];
            for j=1 : length(listaDeLuzes)
                pontoDeLuz = listaDeLuzes(j).ponto;
                corEspecularDaLuz = listaDeLuzes(j).corEspecular;
                intensidadeDaLuz = listaDeLuzes(j).intensidade;
            
                vetorAoPontoDeLuz = pontoDeLuz - pontoQueTocaOObjeto;
    %             vetorAoPontoDeLuz = pontoQueTocaOObjeto - pontoDeLuz;
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
