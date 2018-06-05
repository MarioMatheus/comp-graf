
function [estaDentro] = verificaPontoNoPoligono(pontosDoPoligono, pontoASerVerificado)
    
    aux = 1;
    pontos = pontosDoPoligono;
    qtdPontos = size(pontos, 1);
    resultadosDaDeterminante = 1:qtdPontos;
    
    for i=1 : qtdPontos
        pontoDoPoligonoAnterior = pontos(aux,:);
        aux = aux + 1;
        if aux > qtdPontos
            aux = 1;
        end
        pontoDoPoligonoSucessor = pontos(aux,:);
        matriz = [pontoDoPoligonoSucessor; pontoDoPoligonoAnterior; pontoASerVerificado];
        resultadosDaDeterminante(i) = det(matriz);
    end
    
    p = 0;
    z = 0;
    for i=1 : qtdPontos
        if resultadosDaDeterminante(i) < 0
            p = p - 1;
        elseif resultadosDaDeterminante(i) > 0
            p = p + 1;
        else
            z = z + 1;
        end
    end
    
    
    % considerando pontos jah coplanares, para pontos em cima da borda do
    % poligono
    % para contar com pontos na linha, descomente abaixo
    % p = p + z;
    
    
    if abs(p) == qtdPontos
        estaDentro = true;
    else
        estaDentro = false;
    end

end
