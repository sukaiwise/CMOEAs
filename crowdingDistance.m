function [pop] = crowdingDistance(pop)
%CROWDINGDISTANCE 此处显示有关此函数的摘要
%   pop is the sub population of the specfic front of all the fronts
objs = [pop.object];
nObj = size(objs,1);
nElement = numel(pop);
distance = zeros(nObj,nElement);
for i = 1:nObj
    [sortedObjs,indexs] = sort(objs(i,:));
    distance(i,indexs(1)) = inf;
    distance(i,indexs(end)) = inf;
    for j = 2:nElement-1
        distance(i,indexs(j)) = abs(sortedObjs(j+1)-sortedObjs(j-1))/abs(sortedObjs(1)-sortedObjs(end));

    end
end

for i = 1:nElement
    pop(i).crowdingDistance = sum(distance(:,i));
end
end

