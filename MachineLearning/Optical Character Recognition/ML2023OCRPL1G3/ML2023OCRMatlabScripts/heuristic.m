%% Aprendizagem Computacional - 2023/2024
%% PL1 - G3
% Duarte Ferreira (2020235393)
% Cristiana Azevedo (2020221121)

% Codigo para a funcao heuristic: converte as saídas de uma rede neural para um 
% formato onde apenas o maior valor em cada coluna é definido como 1, e todos os 
% outros valores na mesma coluna são definidos como 0.

function classification = heuristic(results)
    % encontra os indices dos valores maximos em cada coluna
    [~, ind] = max(results);
    % inicializa a matriz de classificacao com zeros
    classification = zeros(size(results));
    % defina os valores maximos em cada coluna como 1, o restante permanece como 0
    for i = 1:size(results,2)
        classification(ind(i), i)=1;
    end
end
