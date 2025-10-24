%% Aprendizagem Computacional - 2022/2023
%% Trabalho 2 - PL1 - G3
% Duarte Ferreira (2020235393)
% Cristiana Azevedo (2020221121)


% Criar e treinar a rede neuronal (CNN)

function [prev_SE, prev_SP, det_SE, det_SP, seizures_detected, seizures_predicted, accuracy] = train_CNN(P,T,patient,n_features, convLayers,solver,epochs,...
    filter_size, n_filters, convStride, pooling, poolingSize, poolingStride)

training_options=trainingOptions(solver,...
    Plots="training-progress",...
    Verbose=false,...
    MaxEpochs=epochs,...
    ValidationFrequency=30,...
    Shuffle="every-epoch",...
    LearnRateSchedule="piecewise",...
    ExecutionEnvironment="cpu"); 

        layers=[imageInputLayer([str2double(n_features) 29 1])];

switch convLayers
    case 1
        switch pooling
            case "max"
                poolingLayer=maxPooling2dLayer(str2double(poolingSize),Stride=poolingStride);
            case "avg"
                poolingLayer=averagePooling2dLayer(str2double(poolingSize),Stride=poolingStride);
        end
        
        layers=[layers
            convolution2dLayer(str2double(filter_size),str2double(n_filters),Stride=convStride)
            batchNormalizationLayer
            reluLayer
            poolingLayer];
    case 2
        switch pooling
            case "max"
                poolingLayer_1=maxPooling2dLayer(str2double(poolingSize(1)),Stride=poolingStride);
                poolingLayer_2=maxPooling2dLayer(str2double(poolingSize(2)),Stride=poolingStride);
            case "avg"
                poolingLayer_1=averagePooling2dLayer(str2double(poolingSize(1)),Stride=poolingStride);
                poolingLayer_2=averagePooling2dLayer(str2double(poolingSize(2)),Stride=poolingStride);
        end
        layers=[layers
            convolution2dLayer(str2double(filter_size(1)),str2double(n_filters(1)),Stride=convStride)
            batchNormalizationLayer
            reluLayer
            poolingLayer_1
            
            convolution2dLayer(str2double(filter_size(2)),str2double(n_filters(2)),Stride=convStride)
            batchNormalizationLayer
            reluLayer
            poolingLayer_2];


    case 3
        switch pooling
            case "max"
                poolingLayer_1=maxPooling2dLayer(str2double(poolingSize(1)),Stride=poolingStride);
                poolingLayer_2=maxPooling2dLayer(str2double(poolingSize(2)),Stride=poolingStride);
                poolingLayer_3=maxPooling2dLayer(str2double(poolingSize(3)),Stride=poolingStride);
            case "avg"
                poolingLayer_1=averagePooling2dLayer(str2double(poolingSize(1)),Stride=poolingStride);
                poolingLayer_2=averagePooling2dLayer(str2double(poolingSize(2)),Stride=poolingStride);
                poolingLayer_3=averagePooling2dLayer(str2double(poolingSize(3)),Stride=poolingStride);
        end
        layers=[layers
            convolution2dLayer(str2double(filter_size(1)),str2double(n_filters(1)),Stride=convStride)
            batchNormalizationLayer
            reluLayer
            poolingLayer_1
            
            convolution2dLayer(str2double(filter_size(2)),str2double(n_filters(2)),Stride=convStride)
            batchNormalizationLayer
            reluLayer
            poolingLayer_2
            
            convolution2dLayer(str2double(filter_size(3)),str2double(n_filters(3)),Stride=convStride)
            batchNormalizationLayer
            reluLayer
            poolingLayer_3];
end
% final layers
layers=[layers
    fullyConnectedLayer(3) 
    softmaxLayer 
    classificationLayer];

% train CNN
trained_net = trainNetwork(P,T,layers,training_options);

% results
train_results = classify(trained_net,P);
accuracy = (sum(train_results == T)/numel(T))*100;

T = grp2idx(T);
train_results = grp2idx(train_results);

% post-processing
[prev_SE, prev_SP, det_SE, det_SP] = PP_postProcessing(train_results, T);
[seizures_detected, seizures_predicted] = SS_postProcessing(train_results, T);

% save
filename = strcat(num2str(patient),"_",num2str(n_features),'F_CNN_', solver, '_', num2str(epochs), 'ConvL_', num2str(convLayers),'Filt',  mat2str(convStride),'Str', ...
    '_PoolL_', pooling,'S', mat2str(poolingStride), 'Str.mat');

save(fullfile(pwd,"Trained Networks","CNN", num2str(patient), filename),'trained_net',"T")
end

