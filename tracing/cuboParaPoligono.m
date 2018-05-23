

function [ poligonos ] = cuboParaPoligono( cubo )
    x = 1; y = 2; z = 3;

    quadradoBase = [[0 0 0]; [0 0 0]; [0 0 0]; [0 0 0]];
    quadradoTopo = [[0 0 0]; [0 0 0]; [0 0 0]; [0 0 0]];
    quadradoFrontal = [[0 0 0]; [0 0 0]; [0 0 0]; [0 0 0]];
    quadradoTraseira = [[0 0 0]; [0 0 0]; [0 0 0]; [0 0 0]];
    quadradoEsquerda = [[0 0 0]; [0 0 0]; [0 0 0]; [0 0 0]];
    quadradoDireita = [[0 0 0]; [0 0 0]; [0 0 0]; [0 0 0]];
    
    %######################################################################
    
    quadradoBase(1,x) = cubo.centro(x) + (cubo.lado/2);
    quadradoBase(1,y) = cubo.centro(y) - (cubo.lado/2);
    quadradoBase(1,z) = cubo.centro(z) - (cubo.lado/2);
    
    quadradoBase(2,x) = cubo.centro(x) + (cubo.lado/2); 
    quadradoBase(2,y) = cubo.centro(y) + (cubo.lado/2);
    quadradoBase(2,z) = cubo.centro(z) - (cubo.lado/2);
    
    quadradoBase(3,x) = cubo.centro(x) - (cubo.lado/2); 
    quadradoBase(3,y) = cubo.centro(y) + (cubo.lado/2);
    quadradoBase(3,z) = cubo.centro(z) - (cubo.lado/2);
    
    quadradoBase(4,x) = cubo.centro(x) - (cubo.lado/2);
    quadradoBase(4,y) = cubo.centro(y) - (cubo.lado/2);
    quadradoBase(4,z) = cubo.centro(z) - (cubo.lado/2);
    
    %######################################################################
    
    quadradoFrontal(1,x) = cubo.centro(x) - (cubo.lado/2);
    quadradoFrontal(1,y) = cubo.centro(y) - (cubo.lado/2);
    quadradoFrontal(1,z) = cubo.centro(z) + (cubo.lado/2);
    
    quadradoFrontal(2,x) = cubo.centro(x) - (cubo.lado/2); 
    quadradoFrontal(2,y) = cubo.centro(y) + (cubo.lado/2);
    quadradoFrontal(2,z) = cubo.centro(z) + (cubo.lado/2);
    
    quadradoFrontal(3,x) = quadradoBase(3,x); 
    quadradoFrontal(3,y) = quadradoBase(3,y);
    quadradoFrontal(3,z) = quadradoBase(3,z);
    
    quadradoFrontal(4,x) = quadradoBase(4,x);
    quadradoFrontal(4,y) = quadradoBase(4,y);
    quadradoFrontal(4,z) = quadradoBase(4,z);
    
    %######################################################################
    
    quadradoTraseira(1,x) = cubo.centro(x) + (cubo.lado/2);
    quadradoTraseira(1,y) = cubo.centro(y) - (cubo.lado/2);
    quadradoTraseira(1,z) = cubo.centro(z) + (cubo.lado/2);
    
    quadradoTraseira(2,x) = cubo.centro(x) + (cubo.lado/2); 
    quadradoTraseira(2,y) = cubo.centro(y) + (cubo.lado/2);
    quadradoTraseira(2,z) = cubo.centro(z) + (cubo.lado/2);
    
    quadradoTraseira(3,x) = quadradoBase(2,x); 
    quadradoTraseira(3,y) = quadradoBase(2,y);
    quadradoTraseira(3,z) = quadradoBase(2,z);
    
    quadradoTraseira(4,x) = quadradoBase(1,x);
    quadradoTraseira(4,y) = quadradoBase(1,y);
    quadradoTraseira(4,z) = quadradoBase(1,z);
    
    %######################################################################
    
    quadradoTopo(1,x) = quadradoTraseira(1,x);
    quadradoTopo(1,y) = quadradoTraseira(1,y);
    quadradoTopo(1,z) = quadradoTraseira(1,z);
    
    quadradoTopo(2,x) = quadradoTraseira(2,x);
    quadradoTopo(2,y) = quadradoTraseira(2,y);
    quadradoTopo(2,z) = quadradoTraseira(2,z);
    
    quadradoTopo(3,x) = cubo.centro(x) - (cubo.lado/2);
    quadradoTopo(3,y) = cubo.centro(y) + (cubo.lado/2);
    quadradoTopo(3,z) = cubo.centro(z) + (cubo.lado/2);
    
    quadradoTopo(4,x) = cubo.centro(x) - (cubo.lado/2); 
    quadradoTopo(4,y) = cubo.centro(y) - (cubo.lado/2);
    quadradoTopo(4,z) = cubo.centro(z) + (cubo.lado/2);
    
    %######################################################################
    
    quadradoEsquerda(1,x) = quadradoTopo(1,x);
    quadradoEsquerda(1,y) = quadradoTopo(1,y);
    quadradoEsquerda(1,z) = quadradoTopo(1,z);
    
    quadradoEsquerda(2,x) = quadradoTopo(4,x);
    quadradoEsquerda(2,y) = quadradoTopo(4,y);
    quadradoEsquerda(2,z) = quadradoTopo(4,z);
    
    quadradoEsquerda(3,x) = quadradoBase(4,x);
    quadradoEsquerda(3,y) = quadradoBase(4,x);
    quadradoEsquerda(3,z) = quadradoBase(4,x);
    
    quadradoEsquerda(4,x) = quadradoBase(1,x);
    quadradoEsquerda(4,y) = quadradoBase(1,x);
    quadradoEsquerda(4,z) = quadradoBase(1,x);
    
    %######################################################################
    
    quadradoDireita(1,x) = quadradoTopo(3,x);
    quadradoDireita(1,y) = quadradoTopo(3,y);
    quadradoDireita(1,z) = quadradoTopo(3,z);
    
    quadradoDireita(2,x) = quadradoTopo(2,x);
    quadradoDireita(2,y) = quadradoTopo(2,y);
    quadradoDireita(2,z) = quadradoTopo(2,z);
    
    quadradoDireita(3,x) = quadradoBase(2,x);
    quadradoDireita(3,y) = quadradoBase(2,x);
    quadradoDireita(3,z) = quadradoBase(2,x);
    
    quadradoDireita(4,x) = quadradoBase(3,x);
    quadradoDireita(4,y) = quadradoBase(3,x);
    quadradoDireita(4,z) = quadradoBase(3,x);
    
    %######################################################################
    
    poligonos = [quadradoBase, quadradoTopo, quadradoEsquerda, quadradoDireita, quadradoFrontal, quadradoTraseira];

end

