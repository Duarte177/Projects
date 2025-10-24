%% Aprendizagem Computacional - 2022/2023
%% Trabalho 2 - PL1 - G3
% Duarte Ferreira (2020235393)
% Cristiana Azevedo (2020221121)

% Treino de autoencoder - reduzir para 20, 10 e 5 features
function [FeatVectSel] = autoencoders(number_patient, n_features)

% carregar ficheiros
load(strcat(num2str(number_patient),".mat"), 'FeatVectSel');

% transpor a matriz
FeatVectSel = FeatVectSel';

autoenc = trainAutoencoder(FeatVectSel, n_features);
FeatVectSel = encode(autoenc,FeatVectSel');

FeatVectSel = FeatVectSel';  
save(strcat(num2str(number_patient),"_",num2str(n_features),"features.mat"),"FeatVectSel","Trg")

end