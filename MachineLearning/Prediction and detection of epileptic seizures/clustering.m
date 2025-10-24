%% Aprendizagem Computacional - 2022/2023
%% Trabalho 2 - PL1 - G3
% Duarte Ferreira (2020235393)
% Cristiana Azevedo (2020221121)

% Funcao para realizar o clustering

function clustering(Reduced_Features, newT)

Reduced_Features = Reduced_Features';

interictal_points = find(all(newT == [1 0 0 ]'));
preictal_points = find(all(newT == [0 1 0 ]'));
ictal_points = find(all(newT == [0 0 1 ]'));

figure;
scatter3(Reduced_Features(interictal_points, 1), Reduced_Features(interictal_points, 2),Reduced_Features(interictal_points, 3), 'ro')
hold on
scatter3(Reduced_Features(preictal_points, 1), Reduced_Features(preictal_points, 2),Reduced_Features(preictal_points, 3), 'go')

scatter3(Reduced_Features(ictal_points, 1), Reduced_Features(ictal_points, 2),Reduced_Features(ictal_points, 3), 'bo')
hold off

xlabel('Feature 1')
ylabel('Feature 2')
zlabel('Feature 3')
legend('Interictal','Preictal', 'Ictal')
title('Reduced Features')

% k - means

clusters = 3;
idx = kmeans(Reduced_Features, clusters);

figure;
scatter3(Reduced_Features(find(idx==1), 1), Reduced_Features(find(idx==1), 2), Reduced_Features(find(idx==1), 3), 'ro')
hold on
scatter3(Reduced_Features(find(idx==2), 1), Reduced_Features(find(idx==2), 2), Reduced_Features(find(idx==2), 3), 'go')
scatter3(Reduced_Features(find(idx==3), 1), Reduced_Features(find(idx==3), 2), Reduced_Features(find(idx==3), 3), 'bo')
hold off 

xlabel('Feature 1')
ylabel('Feature 2')
zlabel('Feature 3')
legend('Cluster 1','Cluster 2','Cluster 3')
title('K-means')

end