%% Aprendizagem Computacional - 2022/2023
%% PL1 - G3
% Duarte Ferreira (2020235393)
% Cristiana Azevedo (2020221121)

function P2 = filters(architecture, P_treino, Perfect_treino)

load("DataSet.mat");

if strcmp(architecture,"associative")
   Wp = Perfect_treino*pinv(P_treino);
   save assoc_memory.mat Wp

   P2 = Wp*P_treino;

elseif strcmp(architecture,"perceptron")
    % criacao do Perceptron
    net=perceptron;
    net.name='Perceptron_Filter';
    net.trainFcn='trainc';
    net.adaptFcn='learnp';
    net=configure(net,P_treino,Perfect_treino);
    
    net.performParam.lr=0.5;
    net.trainParam.epochs=1e3;
    net.trainParam.show=35;
    net.trainParam.goal=1e-6;
    net.performFcn='sse';
    
    net.numLayers=1;
    net.layers{1}.size=256;
    net.layers{1}.transferFcn='hardlim';

    % treinar o perceptron
    view(net);
    net = train(net,P_treino,Perfect_treino);
    trained_perceptron=net;
    P2 = sim(net,P_treino);
    save perceptron_net.mat trained_perceptron

    
end

end
