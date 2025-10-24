%% Aprendizagem Computacional - 2022/2023
%% Trabalho 2 - PL1 - G3
% Duarte Ferreira (2020235393)
% Cristiana Azevedo (2020221121)

% Pos-processamneto - seizure by seizure

function [seizures_detected, seizures_predicted] = SS_postProcessing(Data,Target)

TrgResult = zeros(length(Data), 1);

% SEIZURES DETETADAS E PREVISTAS
% encontrar pelo menos 5 pontos consecutivos com a mesma classificacao
for i = 1:length(Data)
    if i <= length(Data) - 10

        interictal = nnz(find(Data(i:i+9) == 1));
        preictal = nnz(find(Data(i:i+9) == 2));
        ictal = nnz(find(Data(i:i+9) == 3));
        
        [Max, ind] = max([interictal, preictal, ictal]);
        
        if Max >= 5
            TrgResult(i) = ind;
        else
            TrgResult(i) = Data(i);
        end
    else
        TrgResult(i) = Data(i);
    end
end

matrix = confusionmat(Target, TrgResult);

TP = zeros(1,3);    % true positive
FN = zeros(1,3);    % false negative
FP = zeros(1,3);    % false positive
TN = zeros(1,3);    % true negative

for i=1:3
    TP(i) = matrix(i,i);
    FN(i) = sum(matrix(i,:))-matrix(i,i);
    FP(i) = sum(matrix(:,i))-matrix(i,i);
    TN(i) = sum(matrix(:))-TP(i)-FP(i)-FN(i);
end

% preictal - previsao
seizures_predicted = TP(2)/(TP(2)+FN(2))*100;

% ictal - detecao
seizures_detected = TP(3)/(TP(3)+FN(3))*100;

end