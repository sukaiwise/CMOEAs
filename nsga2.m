clc;
clear;
close all;
tic;
%problem
problem = @(x) MOP4(x);
nVar = 3;
varSize = [1 nVar];
varMin = -5;
varMax = 5;
nobj = numel(problem(unifrnd(varMin,varMax,varSize)));
%%

%algorithm parameters
maxIt = 100;
nPop = 100;

pCrossover = 0.7;
nCrossover = 2*round(pCrossover*nPop/2);

pMutation = 0.4;
nMutation = round(pMutation*nPop);

mutateRate = 0.02;
sigma = 0.1*(varMax-varMin);
%% initialization
empty_individual.position = [];
empty_individual.object = [];
empty_individual.rank = [];
empty_individual.dominationSet = [];
empty_individual.dominatedCount = 0;
empty_individual.crowdingDistance = [];

pop = repmat(empty_individual, nPop, 1);

for i = 1:nPop
    pop(i).position = unifrnd(varMin,varMax,varSize);
    pop(i).object = problem(pop(i).position);
end
%% main loop
for it = 1:maxIt
    %crossover
    popc = repmat(empty_individual , nCrossover/2 , 2);
    for k = 1:nCrossover/2
        i1 = randi([1 nPop]);
        p1 = pop(i1);

        i2 = randi([1 nPop]);
        p2 = pop(i2);

        [popc(k, 1).position, popc(k, 2).position] = crossover(p1.position, p2.position);

        popc(k, 1).object = problem(popc(k, 1).position);
        popc(k, 2).object = problem(popc(k, 2).position);
    end
    popc = popc(:);%合并为列向量
    %mutate
    popm = repmat(empty_individual,nMutation,1);
    for k = 1:nMutation
        i = randi([1 nPop]);
        p = pop(i);
        popm(k).position = mutate(p.position,mutateRate,sigma);
        popm(k).object = problem(popm(k).position);
    end

    %merge
    pop = [pop
        popc
        popm];
    [pop,fronts] = fastNonDominatedSort(pop);
    popFront = [];
    frontNum=1;
    while length(popFront)+length(fronts{frontNum})<nPop
        popFront = [popFront
            pop(fronts{frontNum})];
        frontNum = frontNum+1;
    end
    numDistanceSort = nPop-length(popFront);
    popDistance = pop(fronts{frontNum});
    popDistance = crowdingDistance(popDistance);
    [~,indexs] = sort([popDistance.crowdingDistance], 'descend');%取出拥挤距离并排序，获得相应的下标
    popDistance = popDistance(indexs);
    popDistance = popDistance(1:numDistanceSort);
    pop=[popFront
        popDistance];
    %绘制动态变化过程
%     [pop,fronts] = fastNonDominatedSort(pop);
%     disp(['Iteration' num2str(it) ':number of F1 =' num2str(length(fronts{1}))]);
%     figure(1);
%     plotObjs(pop(fronts{1}));
    disp(['Iteration' num2str(it)]);
end
[pop,fronts] = fastNonDominatedSort(pop);
% disp(['Iteration' num2str(it) ':number of F1 =' num2str(length(fronts{1}))]);
figure(1);
plotObjs(pop(fronts{1}));
toc;
