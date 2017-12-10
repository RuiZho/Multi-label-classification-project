load('features.mat');
load('miml data.mat');
p = randperm(2000);
Xtrain = X(p(1,1:1500), :);
ytrain = targets(:, p(1,1:1500))';
Xtest = X(p(1,1501:end), :);
ytest = targets(:, p(1,1501:end))';

svmScores = zeros(500, 5);

for i = 1:5
    Model = fitcsvm(Xtrain,ytrain(:,i),'KernelFunction','rbf', 'BoxConstraint', 1.5,...
    'KernelScale', 'auto');
    [~, score] = predict(Model, Xtest);
    svmScores(:,i) = score(:,2); 
end

P_y = (svmScores > 0) - (svmScores < 0);
T_y = P_y;
[a,I] = max(svmScores,[],2);
for i = 1:500
    if a(i,1) < 0
        T_y(i, I(i,1)) = 1;
    end
end

save('result', 'P_y', 'T_y', 'ytest');

