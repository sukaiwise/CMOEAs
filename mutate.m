function [output] = mutate(input,mutateRate,sigma)
%MUTATE 此处显示有关此函数的摘要
%   mutateRate变异概率
% sigma步长
nVar = numel(input);
nMu = ceil(mutateRate*nVar);
indexs = randsample(nVar,nMu);
output = input;
output(indexs) = input(indexs)+sigma.*randn(size(indexs));
end

