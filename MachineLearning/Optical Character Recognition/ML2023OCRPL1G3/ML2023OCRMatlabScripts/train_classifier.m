%% Aprendizagem Computacional - 2022/2023
%% PL1 - G3
% Duarte Ferreira (2020235393)
% Cristiana Azevedo (2020221121)

function trained_net = train_classifier(option, architecture, f_act)

load("DataSet.mat",'P_treino','T','Perfect_treino', 'T_teste2', 'P_teste2', 'T_teste1', 'P_teste1');


 if strcmp(option,'test')
  global f_actGlobal architecGlobal
  architecGlobal = architecture;
  f_actGlobal = f_act;
  mpaper;

 elseif strcmp(option,'train')
    % criacao de uma rede neuronal
    net = network; 

    % configuracao dos inputs, layers, weights e bias da camada de entrada
    net.numInputs = 1;
    net.inputs{1}.size = 256;
    net.numLayers=1;
    net.layers{1}.name="Classifier Layer";
    net.layers{1}.size=10;
    net.biasConnect(1) = 1;
    net.inputConnect(1) = 1;
    net.outputConnect(1) = 1;

    % associative memory
    if strcmp(architecture,"associative")
        P_treino = filters(architecture, P_treino, Perfect_treino);
        load("assoc_memory.mat","Wp");
        P_teste1 = Wp*P_teste1;
        P_teste2 = Wp*P_teste2;

        % configuracao a funcao de ativacao da primeira camada da rede neural 
        net.layers{1}.transferFcn = f_act;
    
        % weights and bias
        rng(0)
        W=-1+2.*rand(10,256);
        net.IW{1,1}=W;
        rng(0)
        b=-1+2.*rand(10,1);
        net.b{1,1}=b;
    
        % funcoes de ativacao
        if strcmp(f_act, 'hardlim')   % perceptron
            net.trainFcn = 'trainc';
            net.adaptFcn='learnp';
            net.inputWeights{1}.learnFcn = 'learnp';
            net.biases{1}.learnFcn = 'learnp';
        
        elseif strcmp(f_act, 'purelin') || strcmp(f_act, 'logsig') %gradiente
            net.trainFcn = 'trainlm';
            net.inputWeights{1}.learnFcn = 'trainlm';
            net.biases{1}.learnFcn = 'trainlm';
        end
    
    % binary perceptron
    elseif strcmp(architecture,"perceptron")
        P_treino = filters(architecture, P_treino, Perfect_treino);
        load("perceptron_net.mat", 'trained_perceptron');
        P_teste1 = sim(trained_perceptron, P_teste1);
        P_teste2 = sim(trained_perceptron, P_teste2);
        
     % configuracao a funcao de ativacao da primeira camada da rede neural 
        net.layers{1}.transferFcn = f_act;
    
        % weights and bias
        rng(0)
        W=-1+2.*rand(10,256);
        net.IW{1,1}=W;
        rng(0)
        b=-1+2.*rand(10,1);
        net.b{1,1}=b;
    
        % funcoes de ativacao
        if strcmp(f_act, 'hardlim')
            net.trainFcn = 'trainc';
            net.adaptFcn='learnp';
            net.inputWeights{1}.learnFcn = 'learnp';
            net.biases{1}.learnFcn = 'learnp';
    
        elseif strcmp(f_act, 'purelin') || strcmp(f_act, 'logsig') 
            net.trainFcn = 'trainlm';
            net.inputWeights{1}.learnFcn = 'trainlm';
            net.biases{1}.learnFcn = 'trainlm';
        end
    

    % 1 layer
    elseif strcmp(architecture,"1L") || strcmp(architecture,"1LSft") 
        % configuracao a funcao de ativacao da primeira camada da rede neural 
        net.layers{1}.transferFcn = f_act;
    
        % weights and bias
        rng(0)
        W=-1+2.*rand(10,256);
        net.IW{1,1}=W;
        rng(0)
        b=-1+2.*rand(10,1);
        net.b{1,1}=b;
    
        %Funções de Ativação
        if strcmp(f_act, 'hardlim')
            net.trainFcn = 'trainc';
            net.adaptFcn='learnp';
            net.inputWeights{1}.learnFcn = 'learnp';
            net.biases{1}.learnFcn = 'learnp';
    
        elseif strcmp(f_act, 'purelin') || strcmp(f_act, 'logsig') 
            net.trainFcn = 'trainlm';
            net.inputWeights{1}.learnFcn = 'trainlm';
            net.biases{1}.learnFcn = 'trainlm';
        end
    
    
    % 2 layers
    elseif strcmp(architecture,"2L") 
        % numero de camadas = 2
        net.numLayers=2;
    
        % configuracao da primeira camada oculta
        net.layers{1}.name="Hidden Layer";
        hiddenLayerNeurons=40;
        net.layers{1}.size=hiddenLayerNeurons;
    
        % configuracao da segunda camada (camada de classificação)
        net.layers{2}.name="Classifier Layer";
        net.layers{2}.size=10;
        
        % conexoes de bias
        net.biasConnect(1)=1;
        net.biasConnect(2)=1;
    
        % conexoes de entrada e saída
        net.inputConnect(1,1)=1;
        net.layerConnect(2,1)=1;
        net.outputConnect(1)=0;
        net.outputConnect(2)=1;
    
        % inicializacao dos weights e bias
        rng(0)
        W=-1+2.*rand(hiddenLayerNeurons,256);
        rng(0)
        b=-1+2.*rand(hiddenLayerNeurons,1);
        net.IW{1,1}=W;
        net.b{1}=b;
    
        rng(0)
        W=-1+2.*rand(10,hiddenLayerNeurons);
        net.LW{2,1}=W;
        rng(0)
        b=-1+2.*rand(10,1);
        net.b{2}=b;
    
        % funcoes de aprendizagem
        net.inputWeights{1,1}.learnFcn = 'trainlm';
        net.layerWeights{2,1}.learnFcn = 'trainlm';
        net.biases{1}.learnFcn = 'trainlm';
        net.biases{2}.learnFcn = 'trainlm';
        
        % configuracao das funcoes de ativacao para a primeira e segunda camadas
        net.layers{1}.transferFcn = f_act(1);
        net.layers{2}.transferFcn = f_act(2);
    
        % configuracao da funcao de treino
        net.trainFcn = 'trainlm';
    end

    net.trainParam.lr = 0.5;       % learning rate
    net.trainParam.epochs = 1000;  % maximum epochs
    net.trainParam.show = 35;      % show
    net.trainParam.goal = 1e-6;    % goal=objective
    net.performFcn = 'sse';        % criterion

    % Divisao dos dados em conjunto de treino(85%) e teste(15%)
    net.divideFcn = 'dividerand';      
    net.divideParam.trainRatio = 85/100;
    net.divideParam.valRatio = 15/100; 

    net = configure (net,P_treino,T);

    % TREINO
    trained_net = train(net,P_treino,T);

    output_treino = sim(trained_net,P_treino);
    output_teste1 = sim(trained_net,P_teste1);
    output_teste2 = sim(trained_net,P_teste2);
    
    % No caso de ser Softmax - cria-se mais uma rede neuronal e treina-se
    if strcmp(architecture,"1LSft")
        output_treino = softmax(output_treino);
        output_teste1 = softmax(output_teste1);
        output_teste2 = softmax(output_teste2);
    end
    
    % Pos-processamento - Heuristic
    output_treino = heuristic(output_treino);
    output_teste1 = heuristic(output_teste1);
    output_teste2 = heuristic(output_teste2);

    % RESULTADOS 
    figure(1)
    plotroc(T,output_treino)
    title('ROC: Treino')
    
    figure(2)
    plotconfusion(T,output_treino)
    title('Matrix: Treino')

    figure(3)
    plotroc(T_teste1,output_teste1)
    title('ROC: Teste 1')
    
    figure(4)
    plotconfusion(T_teste1,output_teste1)
    title('Matrix: Teste 1')

    figure(5)
    plotroc(T_teste2,output_teste2)
    title('ROC: Teste 2')
    
    figure(6)
    plotconfusion(T_teste2,output_teste2)
    title('Matrix: Teste 2')

    figure(7), plotregression(T,output_treino)
    figure(8), plotregression(T_teste1,output_teste1)
    figure(9), plotregression(T_teste2,output_teste2)


    % Guardar net
    if length(f_act) == 2
        save(strcat(architecture,'_',f_act(1),f_act(2),'_trained_net.mat'),'trained_net')
    else
        save(strcat(architecture,'_',f_act,'_trained_net.mat'),'trained_net')
    end
 end
end