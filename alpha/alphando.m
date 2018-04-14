% Composicao Alpha
% c = alpha * cf + (1 - alpha) * cb | alpha E [0, 1]

clc; % Limpa console
clear; % remove todas as variaveis do workspace

alphaChannel = imread('alpha_channel.png');
background = imread('background.jpg');
foreground = imread('foreground.png');

alpha = 0.55;
img = immultiply(foreground, alphaChannel.*(1/255));
resultado = img.*alpha + (1-alpha).*background;

figure, imshow(resultado);
