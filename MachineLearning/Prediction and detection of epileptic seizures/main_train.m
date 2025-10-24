%% Aprendizagem Computacional - 2022/2023
%% Trabalho 2 - PL1 - G3
% Duarte Ferreira (2020235393)
% Cristiana Azevedo (2020221121)

function [prev_SE, prev_SP, det_SE, det_SP, seizures_detected, seizures_predicted, accuracy] = main_train(patient, n_features, option, neural_network, solver, epochs, ...
    n_convLayers, filter_size, n_filters, convStride, poolingType, poolingSize, poolingStride, ...
    hidden_units, layer, ...
    hidden_layers, neurons, training_style, train_function, activation_function, delays, optimization)


% Carregar o ficheiro
if str2double(n_features)== 29
    filename=strcat(patient,".mat");
    load(filename, "FeatVectSel", "Trg");
else
    load(strcat(num2str(patient), "_", num2str(n_features),"features.mat"),"FeatVectSel","Trg");
end

% TREINO
if isequal(option,'train')

    [processed_T, processed_P] = preProcessing(Trg, FeatVectSel, option, neural_network);
  
    if isequal(neural_network, "LSTM")
        [prev_SE, prev_SP, det_SE, det_SP, seizures_detected, seizures_predicted,accuracy] = train_LSTM(patient, processed_T, processed_P, hidden_units, n_features, epochs, solver, layer);
        
    elseif isequal(neural_network, "CNN")
        [prev_SE, prev_SP, det_SE, det_SP, seizures_detected, seizures_predicted,accuracy] = train_CNN(processed_P, processed_T, patient,n_features, n_convLayers, solver, epochs, filter_size, n_filters,convStride, poolingType, poolingSize, poolingStride);
    
    elseif isequal(neural_network, "LRN")
        [prev_SE, prev_SP, det_SE, det_SP, seizures_detected, seizures_predicted,accuracy] = train_Shallow(processed_T, processed_P, patient, n_features, neural_network, hidden_layers, neurons, training_style, train_function, activation_function, delays, optimization);
    
    elseif isequal(neural_network, "FFN")
        [prev_SE, prev_SP, det_SE, det_SP, seizures_detected, seizures_predicted,accuracy] = train_Shallow(processed_T, processed_P, patient, n_features, neural_network, hidden_layers, neurons, training_style, train_function, activation_function, delays, optimization);
    end
    
end


end