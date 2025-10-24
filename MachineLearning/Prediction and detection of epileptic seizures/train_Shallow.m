%% Aprendizagem Computacional - 2022/2023
%% Trabalho 2 - PL1 - G3
% Duarte Ferreira (2020235393)
% Cristiana Azevedo (2020221121)


% Criar as redes neuronais Shallow (FFN E LRN) e treiná-las

function [prev_SE, prev_SP, det_SE, det_SP, seizures_detected, seizures_predicted,accuracy]  = train_Shallow(T, P, patient,n_features,type_neuralNetwork, hidden_layers, neurons, type_training, train_function, activation_function, delays, optimization)

% criação das redes
if strcmp(type_neuralNetwork,"FFN") % Feed Forward Network
    if strcmp(type_training,"BT") % Batch training
        net = feedforwardnet(str2double(neurons),train_function);
        net.trainFcn = train_function;
    else % Incremental learning
        net = feedforwardnet(str2double(neurons),"trainr");
        net.trainFcn = "trainr";
        net.adaptFCN = "learngd";
    end

elseif strcmp(type_neuralNetwork,"LRN") % Layer Recurrent Network
    layer_delays = 1:str2double(delays);
    if strcmp(type_training,"BT")
        net = layrecnet(layer_delays,str2double(neurons),train_function);
    else 
        net = layrecnet(layer_delays,str2double(neurons),"trainr");
    end
end

% configuring the training options and activation functions of a neural network
if strcmp(type_training, "BT")
    for i = 1:length(hidden_layers)
        net.layers{i}.transferFcn = activation_function(i);
    end

else % IL
    for i = 1:length(hidden_layers)
        net.layers{i}.transferFcn = activation_function(i);
        net.inputWeights{i,:}.learnFcn = "learngd";
    end
end
 
net = configure(net,P,T);

% training parameters
net.performParam.lr = 0.1; % learning rate
net.trainParam.epochs = 1000; % maximum epochs
net.trainParam.goal = 1e-6; % goal=objective
net.trainParam.min_grad = 1e-6; %minimum magnitude of gradient descent, for which the training of neural network terminates
net.trainParam.max_fail = 100; %validation_error>net.trainParam.max_fail -> the training is stopped                                                                                                                         
net.performFcn = 'sse'; % criterion
 

% weights
interictal = find( T(1,:) == 1);
preictal = find( T(2,:) == 1);
ictal = find( T(3,:) == 1);

total = length(interictal) + length(preictal) + length(ictal);
weight_interictal = total/ length(interictal);
weight_preictal = total/ length(preictal);
weight_ictal = total/ length(ictal);

error_weight = all(T == [1 0 0]') .* weight_interictal + ...
    all(T == [0 1 0]') .* weight_preictal + ...
    all(T == [0 0 1]') .* weight_ictal;

% divisão dos dados em validação (10%) e treino (90%)
net.divideFcn = 'divideind';
idx_train = round(size(P, 2) * 0.90);
net.divideParam.trainInd = 1:idx_train;  % trein
net.divideParam.valInd = idx_train + 1:size(P, 2);    % validation
 
% train network
if strcmp(type_training, "BT")
    if optimization == 1 % Parallel
        trained_net = train(net, P, T, [], [], error_weight, 'UseParallel', 'yes');
    
    elseif optimization == 2 % GPU
        trained_net = train(net, P, T, [], [], error_weight, 'UseGPU', 'yes');
    
    elseif optimization == 3 % GPU + Parallel
        trained_net = train(net, P, T, [], [], error_weight, 'UseParallel', 'yes', 'UseGPU', 'yes');
    
    else  % None
        trained_net = train(net,P,T,[],[],error_weight);
    end
else
    if optimization == 1 % Parallel
        trained_net = train(net, P, T, [], [], error_weight) 
    
    elseif optimization == 2 % GPU
        trained_net = train(net, P, T, [], [], error_weight)
    
    elseif optimization == 3 % GPU + Parallel
        trained_net = train(net, P, T, [], [], error_weight)
    
    else  % None
        trained_net = train(net,P,T,[],[],error_weight);
    end
end


train_results = sim(trained_net, P);
[~, T_train] = max(T); 
[~, train_output] = max(train_results);
accuracy = sum(train_output == T_train)/numel(T_train) * 100;

% post-processing
[prev_SE, prev_SP, det_SE, det_SP] = PP_postProcessing(train_output, T_train);

[seizures_detected, seizures_predicted] = SS_postProcessing(train_output, T_train);

filename = strcat(num2str(patient), "_", num2str(n_features), 'F_', type_neuralNetwork, '_', num2str(optimization), 'Opt_', num2str(delays), 'LDel_', train_function, '_', num2str(hidden_layers), 'HidL.mat');

save(fullfile(pwd,"Trained Networks","SNN",num2str(patient),filename),'trained_net',"T");

end

  