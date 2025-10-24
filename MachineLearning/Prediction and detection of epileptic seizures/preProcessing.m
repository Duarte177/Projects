%% Aprendizagem Computacional - 2022/2023
%% Trabalho 2 - PL1 - G3
% Duarte Ferreira (2020235393)
% Cristiana Azevedo (2020221121)

% Pre-processamento dos dados

function [processed_T, processed_P] = preProcessing(Trg, FeatVectSel, option, neural_network)

t = ones(length(Trg), 1);
% armazenar as convulsoes
seizures = []; 

% 1- interictal 2-preictal 3-ictal

for i = 1:length(Trg)
    if Trg(i) == 1
        t(i) = 3; % ictal (seizure)
        if Trg(i - 1) == 0 % posicao onde a convulsao começa
            t(max(1, i-300):i - 1) = 2; % preictal
            start_seizure = i;
        end
        if (i < length(Trg) && Trg(i + 1) == 0) || (i == length(Trg))
            end_seizure = i;
            t(i + 1:end_seizure) = 3; % definir pontos postictais como ictais
            seizures = [seizures [start_seizure; end_seizure]];
        end
    elseif Trg(i) == 0
        t(i) = 1; % interictal
    end
end

% Matriz T
T=[];

for i = 1:length(t) 
    if t(i)==1
     T(:,i) = [1 0 0]';
    elseif t(i)==2
     T(:,i) = [0 1 0]';
    elseif t(i)==3
     T(:,i) = [0 0 1]';
    end
end

% dividir o dataset
% 90% (treino + validacao) + 10% (teste)
seizure_length = round(0.90*length(seizures)); 



% matrizes P_treino e P_teste   
P = FeatVectSel()';            %cada coluna ira ter o valor das features
P_treino = P(:,1:seizures(2,seizure_length));
P_teste = P(:,seizures(2,seizure_length)+1:end);
target_treino= t(1:seizures(2,seizure_length),:);

% matrizes T_treino e T_teste
T_treino = T(:,1:seizures(2,seizure_length));
T_teste= T(:,seizures(2,seizure_length)+1:end);

%clustering(P,T); %representação gráfica do clustering para n_features=3

% Teste e Treino
if isequal(option,'test') % nao tem balanceamento
    processed_T = T_teste;
    processed_P = P_teste;

elseif isequal(option,'train') % tem balenceamento
    % Indices das arrays de cada classe
    interictal_ind = find(target_treino(:,1)==1);
    preictal_ind= find(target_treino(:,1)==2);
    ictal_ind = find(target_treino(:,1)==3);
    
    % Tamanho de cada classe
    interictal_length = size(interictal_ind,1);
    preictal_length = size(preictal_ind,1);
    ictal_length = size(ictal_ind,1);
    
    % Balanceamento da classe interictal
    sum = preictal_length + ictal_length;
    
    interictal_rand = interictal_ind(randperm(interictal_length));
    interictal_balanced = interictal_rand(1:sum,:);

    idx = [interictal_balanced' preictal_ind' ictal_ind'];
    processed_T = T_treino(:,idx);
    processed_P = P_treino(:,idx);
    target_treino = target_treino(idx,1);
end

% PRE-PROCESSAMENTO DAS DEEP NETWORKS
if isequal(neural_network, "CNN")
    [processed_P, processed_T] = CNN_preProcessing(processed_P, processed_T, option);

elseif isequal(neural_network, "LSTM")
    [processed_P, processed_T]= LSTM_preProcessing(processed_P, processed_T);
end

end
