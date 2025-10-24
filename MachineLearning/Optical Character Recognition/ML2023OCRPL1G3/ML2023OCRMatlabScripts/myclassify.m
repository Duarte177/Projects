%% Aprendizagem Computacional - 2022/2023
%% PL1 - G3
% Duarte Ferreira (2020235393)
% Cristiana Azevedo (2020221121)

%% Classificador 
% Este programa faz as previsões com base na rede neuronal treinada

function prediction = myclassify(Pdata,filled_inx)

    global f_actGlobal architecGlobal
    net = "";

    % associative memory
    if strcmp(architecGlobal, 'associative') 
        net=strcat('associative_',f_actGlobal,'_trained_net.mat');
        load('assoc_memory','Wp');
        Pdata = Wp*Pdata;
      
    % binary perceptron
    elseif strcmp(architecGlobal, 'perceptron') 
        net=strcat('perceptron_',f_actGlobal,'_trained_net.mat');

        load('perceptron_net.mat','trained_perceptron');
        Pdata = trained_perceptron(Pdata);
    
    % one layer
    elseif strcmp(architecGlobal, '1L') 
        net=strcat('1L_',f_actGlobal,'_trained_net.mat');

    elseif strcmp(architecGlobal, '1LSft') 
        net=strcat('1LSft_',f_actGlobal,'_trained_net.mat');
    
    % two layers    
    elseif strcmp(architecGlobal, '2L') 
        net=strcat('2L_',f_actGlobal(1),f_actGlobal(2),'_trained_net.mat');
    end

    % carregar a rede neuronal treinada
    load(net,'trained_net');

    % teste
    testResult = trained_net(Pdata);
    [~,ind] = max(testResult);
    prediction = ind(filled_inx);
end