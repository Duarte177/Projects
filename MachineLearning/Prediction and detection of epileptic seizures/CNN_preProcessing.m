%% Aprendizagem Computacional - 2022/2023
%% Trabalho 2 - PL1 - G3
% Duarte Ferreira (2020235393)
% Cristiana Azevedo (2020221121)

% Pre Processamento dos Dados para as redes CNN

function [processed_P, processed_T] = CNN_preProcessing(Data,Target,choice)

% Cell Array - Estrutura que vai juntar as varias imagens para a CNN
CA={};

if strcmp(choice,"test")
    processed_P = [];
    processed_T = [];
    % segmentar os dados em janelas de tamanho 29
    for i = 1:29:length(Data)
        % garantir que seja possível formar uma imagem completa de 29x29 pixels
        if i < length(Data) - 28
            actualCell = Data(:,i:i+28)
            % armazenar cada janela numa célula
            CA{end+1,1} = actualCell;
        end
    end

    % criar target para cada um dos grupos
    for i = 1:29:length(Target)
        if i < length(Target) - 28
            % calcular o numero de ocorrencias de cada classe
            n_interictal = nnz(find(all(Target(1,i:i+28) == 1)));
            n_preictal = nnz(find(all(Target(2,i:i+28) == 1)));
            n_ictal = nnz(find(all(Target(3,i:i+28) == 1)));

            L = [n_interictal n_preictal n_ictal];
            [~,ind] = max(L);

            processed_T = [processed_T ind];
        end
    end

    % converter o array processed_T numa variavel categorica
    processed_T = categorical(processed_T');
    % formar da matriz 4D
    processed_P = cat(4, CA{:});



elseif strcmp(choice,"train")
    % a) pre ictal
    idx_preictal = (Target(2,:) == 1);
    preictal_data = Data(:,idx_preictal);

    for i = 1:29:length(preictal_data)
        try
            actualCell = preictal_data(:,i:i+28);
            CA{end+1,1} = actualCell;
        catch
            continue;
        end
    end
    % numero de imagens de pre-ictal
    sz_preictal = length(CA); 


    % b) ictal
    idx_ictal = (Target(3,:) == 1);
    ictal_data = Data(:,idx_ictal);
    for i = 1:29:length(ictal_data)
        try
            actualCell = ictal_data(:,i:i+28);
            CA{end+1,1} = actualCell;
        catch
            continue;
        end
    end
    % numero de imagens de ictal
    sz_ictal = length(CA) - sz_preictal;
    % soma da quantidade de dados que exitem das classes 2 e 3
    sz_data = length(CA);


    % c) inter-ictal
    idx_interictal = (Target(1,:) == 1);
    interictal_data = Data(:,idx_interictal);
    n = 0;
    for i = 1:29:length(interictal_data)
        % balanceamento dos Dados
        while n < sz_data 
            try
                CA{end+1,1} = [Data(:,i:i+28)];
                n = n+1;
            catch
                continue;
            end
        end
    end
    % formar da matriz 4D
    processed_P = cat(4,CA{:});

    % criar matriz T e converter o array pro_T numa variavel categorica
    pro_T = [2*ones(1,sz_preictal) 3*ones(1,sz_ictal) 4*ones(1,sz_data)];
    processed_T = categorical(pro_T');
end

end
