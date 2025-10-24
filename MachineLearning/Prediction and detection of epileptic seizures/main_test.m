%% Aprendizagem Computacional - 2022/2023
%% Trabalho 2 - PL1 - G3
% Duarte Ferreira (2020235393)
% Cristiana Azevedo (2020221121)

function [prev_SE, prev_SP, det_SE, det_SP, seizures_detected, seizures_predicted,accuracy] = main_test(filename)

split_name = split(filename, '_');
neural_network=split_name{3};

patient=split_name{1};

features=split_name{2};
n_features_str = strrep(features, 'F', '');
n_features_double = str2double(n_features_str);
n_features = round(n_features_double);


if n_features == 29
    file=strcat(patient,".mat");
    load(file, "FeatVectSel", "Trg");
else
    load(strcat(num2str(patient), "_", num2str(n_features),"features.mat"),"FeatVectSel","Trg");
end


if strcmp(neural_network, "LSTM")
        load(fullfile(pwd,'Trained Networks', 'LSTM', num2str(patient), filename),"-mat","trained_net");

    elseif isequal(neural_network, "CNN")
        load(fullfile(pwd,"Trained Networks","CNN", num2str(patient), filename),"-mat","trained_net");

    elseif isequal(neural_network, "LRN")
        load(fullfile(pwd,'Trained Networks', 'SNN', num2str(patient), filename),"-mat","trained_net");

    elseif isequal(neural_network, "FFN")
        load(fullfile(pwd,'Trained Networks', 'SNN', num2str(patient), filename),"-mat","trained_net");
end

[T, P] = preProcessing(Trg, FeatVectSel, 'test', neural_network);

if strcmp(neural_network,"LRN") || strcmp(neural_network,"FFN")
    train_results = sim(trained_net, P);
    [~, T_train] = max(T); 
    [~, train_output] = max(train_results);
    accuracy = sum(train_output == T_train)/numel(T_train) * 100;

    [prev_SE, prev_SP, det_SE, det_SP] = PP_postProcessing(train_output, T_train);
    [seizures_detected, seizures_predicted] = SS_postProcessing(train_output, T_train);

elseif strcmp(neural_network,'CNN') || strcmp(neural_network,'LSTM')
    train_results = classify(trained_net,P);
    accuracy = (sum(train_results == T)/numel(T))*100;
    T = grp2idx(T);
    train_results = grp2idx(train_results);
   
    [prev_SE, prev_SP, det_SE, det_SP] = PP_postProcessing(train_results, T);
    [seizures_detected, seizures_predicted] = SS_postProcessing(train_results, T);

end
end