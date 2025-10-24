%% Aprendizagem Computacional - 2022/2023
%% Trabalho 2 - PL1 - G3
% Duarte Ferreira (2020235393)
% Cristiana Azevedo (2020221121)

function [prev_SE, prev_SP, det_SE, det_SP, seizures_detected, seizures_predicted, seizures_total,accuracy] = train_test_networks(patient, n_features, option, neural_network, solver, epochs, ...
    n_convLayers, filter_size, n_filters, convStride, poolingType, poolingSize, poolingStride, ...
    hidden_units, layer, ...
    hidden_layers, neurons, training_style, train_function, activation_function, delays, optimization)

% Carregar o ficheiro
if n_features == 29
    filename=strcat(patient,".mat");
    load(filename, "FeatVectSel", "Trg");
else
    load(strcat(num2str(patient), "_", num2str(n_features),"features.mat"),"FeatVectSel","Trg");
end

% TREINO
if isequal(option,'train')

    [processed_T, processed_P] = preProcessing(Trg, FeatVectSel, option, neural_network);
  
    if isequal(neural_network, "LSTM")
        [prev_SE, prev_SP, det_SE, det_SP, seizures_detected, seizures_predicted, seizures_total,accuracy] = train_LSTM(patient, processed_T, processed_P, hidden_units, n_features, epochs, solver, layer);
        
    elseif isequal(neural_network, "CNN")
        [prev_SE, prev_SP, det_SE, det_SP, seizures_detected, seizures_predicted, seizures_total,accuracy] = train_CNN(processed_P, processed_T, patient,n_features, n_convLayers, solver, epochs, filter_size, n_filters,convStride, poolingType, poolingSize, poolingStride);
    
    elseif isequal(neural_network, "LRN")
        [prev_SE, prev_SP, det_SE, det_SP, seizures_detected, seizures_predicted, seizures_total,accuracy] = train_Shallow(processed_T, processed_P, patient, n_features, neural_network, hidden_layers, neurons, training_style, train_function, activation_function, delays, optimization);
    
    elseif isequal(neural_network, "FFN")
        [prev_SE, prev_SP, det_SE, det_SP, seizures_detected, seizures_predicted, seizures_total,accuracy] = train_Shallow(processed_T, processed_P, patient, n_features, neural_network, hidden_layers, neurons, training_style, train_function, activation_function, delays, optimization);
    end


% TESTE
elseif isequal(option,'test')

    if strcmp(neural_network, "LSTM")
        filename = strcat(num2str(patient),"_",num2str(n_features),'F_LSTM_', solver, '_', num2str(epochs), '_', mat2str(hidden_units), 'HU_', mat2str(layer), 'L.mat'); 
        net = load(fullfile(pwd,'Trained Networks', 'LSTM', num2str(patient), filename),"-mat");

    elseif isequal(neural_network, "CNN")
        fileName = strcat(num2str(patient),"_",num2str(n_features),'F_CNN_', solver, '_', num2str(epochs), 'ConvL_', num2str(convLayers), 'N', mat2str(n_filters),'x',mat2str(filter_size),'Filt',  mat2str(convStride),'Str','_PoolL_', poolingType, 'T', mat2str(poolingSize),'S', mat2str(poolingStride), 'Str.mat');
        net = load(fullfile(pwd,"Trained Networks","CNN", num2str(patient), fileName),"-mat");

    elseif isequal(neural_network, "LRN")
        filename = strcat(num2str(patient),"_",num2str(n_features),'F_LRN_', optimization,'Opt_', num2str(delays), 'LDel_', train_function, '_', activation_function, '_', mat2str(neurons), 'Neur_', num2str(hidden_layers), 'HidL.mat');
        net = load(fullfile(pwd,'Trained Networks', 'SNN', num2str(patient), filename),"-mat");

    elseif isequal(neural_network, "FFN")
        filename = strcat(num2str(patient),"_",num2str(n_features),'F_FFN_', optimization,'Opt_', num2str(delays), 'LDel_', train_function, '_', activation_function, '_', mat2str(neurons), 'Neur_', num2str(hidden_layers), 'HidL.mat');
        net = load(fullfile(pwd,'Trained Networks', 'SNN', num2str(patient), filename),"-mat");
    end

    [Target, Data] = preProcessing(Trg, FeatVectSel, option, neural_network);

    if strcmp(Type,"FFN") || strcmp(Type,"LRN")
        TestResults = sim(net,Data);
        [~,Target] = max(Target);
        [~,TestResults] = max(TestResults);
        
    elseif strcmp(Type,"LSTM") || strcmp(Type,"CNN")
        TestResults = classify(net,Data);
        Target = grp2idx(Target); 
        TestResults = grp2idx(TestResults);
    end
    [prev_SE, prev_SP, det_SE, det_SP] = PP_postProcessing(TestResults, Target);          % point by point
    [seizures_detected, seizures_predicted, seizures_total] = SS_postProcessing(TestResults, Target);   % seizure by seizure

end