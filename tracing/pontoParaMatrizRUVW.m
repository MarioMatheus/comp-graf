function [ matriz ] = pontoParaMatrizRUVW( ponto )

    vetorW = ponto / norm(ponto);

    vetorT = vetorW;
    [~,indice] = min(abs(vetorW));  % Identifica o elemento de menor magnitude
    vetorT(indice) = 1;             % e atribui a 1

    vetorU = cross(vetorT,vetorW);
    normaDeU = norm(vetorU);
    vetorU = vetorU / normaDeU;

    vetorV = cross(vetorU,vetorW);
    
    matriz = [vetorU; vetorV; vetorW];

end
