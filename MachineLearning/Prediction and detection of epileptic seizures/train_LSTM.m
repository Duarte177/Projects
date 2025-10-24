%% Aprendizagem Computacional - 2022/2023
%% Trabalho 2 - PL1 - G3
% Duarte Ferreira (2020235393)
% Cristiana Azevedo (2020221121)


% Criar a rede neuronal LSTM treiná-la
function [prev_SE, prev_SP, det_SE, det_SP, seizures_detected, seizures_predicted,accuracy] = train_LSTM(patient,T, P, hidden_units, n_features, epochs, solver, layer)

% Layers
if layer==1
    layers=[sequenceInputLayer(n_features)
            lstmLayer(hidden_units,'OutputMode','last') 
            fullyConnectedLayer(3) 
            softmaxLayer
            classificationLayer];
    
elseif layer==2
    layers = [sequenceInputLayer(n_features)
            lstmLayer(hidden_units,'OutputMode','sequence')
            dropoutLayer(0.2) %0.2 é a probabilidade de dropout
            lstmLayer(hidden_units,'OutputMode','last')
            dropoutLayer(0.2)
            fullyConnectedLayer(4)
            softmaxLayer
            classificationLayer];
end

% Training Options

options = trainingOptions(solver, ... 
    'ExecutionEnvironment','auto', ...
    'GradientThreshold', 1, ...
    'Verbose', 0, ...
    'MaxEpochs',epochs, ...
    'MiniBatchSize',300,...
    'Shuffle','never', ...    
     'LearnRateSchedule','piecewise',...
    'Plots','training-progress');

% Train Network
trained_net = trainNetwork(P, T, layers, options);

% Results
train_results = classify(trained_net,P);

% Display accuracy
accuracy = (sum(train_results == T)/numel(T))*100;

T = grp2idx(T);
train_results = grp2idx(train_results);
 
[prev_SE, prev_SP, det_SE, det_SP] = PP_postProcessing(train_results, T);
[seizures_detected, seizures_predicted] = SS_postProcessing(train_results, T);

filename = strcat(num2str(patient),"_",num2str(n_features),'F_LSTM_', solver, '_', num2str(epochs), '_', mat2str(hidden_units), 'HU_', mat2str(layer), 'L.mat'); 
save(fullfile(pwd,'Trained Networks', 'LSTM', num2str(patient), filename),'trained_net',"T");

end
