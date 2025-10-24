%% Aprendizagem Computacional - 2022/2023
%% Trabalho 2 - PL1 - G3
% Duarte Ferreira (2020235393)
% Cristiana Azevedo (2020221121)

% Pré Processamento dos Dados para as redes LSTM

function [DataLSTM,TargetLSTM] = LSTM_preProcessing(Data,Target)

% encontrar os indices do maximo em cada coluna de Target
[~,Trg] = max(Target);
TargetLSTM = categorical(Trg');

DataLSTM = {};
% percorrer as colunas de Data
for i = 1:size(Data,2) 
    % armazenar cada coluna de Data na célula DataLSTM
     DataLSTM{end+1, 1} = Data(:,i);  
end

end