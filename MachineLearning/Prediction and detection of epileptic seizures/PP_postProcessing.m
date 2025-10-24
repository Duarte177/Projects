%% Aprendizagem Computacional - 2022/2023
%% Trabalho 2 - PL1 - G3
% Duarte Ferreira (2020235393)
% Cristiana Azevedo (2020221121)

% Pos-processamneto - point by point

function [prev_SE, prev_SP, det_SE, det_SP] = PP_postProcessing(Data,Target)

% matriz de confusao - mostra as contagens de classificacoes corretas e erradas para cada classe.
matrix = confusionmat(Target,Data);
% [m,order] = confusionmat(TargetTest,TestResults);
% figure
% confusionchart(m,order);

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

% SENSITIVITY AND SPECIFICITY

% preictal - previsao
prev_SE = TP(2)/(TP(2)+FN(2))*100;
prev_SP = TN(2)/(TN(2)+FP(2))*100;

% ictal - detecao
det_SE = TP(3)/(TP(3)+FN(3))*100;
det_SP = TN(3)/(TN(3)+FP(3))*100;

end
