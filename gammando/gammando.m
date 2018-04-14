clc;
clear;

camelo = imread('camel.jpg');

camelo = double(camelo); % converte em valores double para permitir operacoes

gamma = 2;
gamma = 1/gamma;

camelo(:, :, 1) = camelo(:, :, 1) ./ 255;
camelo(:, :, 2) = camelo(:, :, 2) ./ 255;
camelo(:, :, 3) = camelo(:, :, 3) ./ 255;

camelo(:, :, 1) = (camelo(:, :, 1) .^ gamma) * 255;
camelo(:, :, 2) = (camelo(:, :, 2) .^ gamma) * 255;
camelo(:, :, 3) = (camelo(:, :, 3) .^ gamma) * 255;

camelo = uint8(camelo);
figure, imshow(camelo);
