function [pop,F] = fastNonDominatedSort(pop)

nPop = numel(pop);
for i = 1:nPop
    pop(i).dominationSet=[];
    pop(i).dominatedCount = 0;
end
F{1}=[];
for i = 1:nPop
    for j = i+1:nPop

        if dominate(pop(i),pop(j))
            pop(i).dominationSet = [pop(i).dominationSet j];
            pop(j).dominatedCount = pop(j).dominatedCount+1;
        end
        if dominate(pop(j),pop(i))
            pop(j).dominationSet = [pop(j).dominationSet i];
            pop(i).dominatedCount = pop(i).dominatedCount+1;
        end

    end
    if pop(i).dominatedCount == 0
        F{1} = [F{1} i];
        pop(i).rank = 1;
    end
end
k = 1;
while true
    nextFront = [];
    for i = F{k}
        for j = pop(i).dominationSet
            pop(j).dominatedCount = pop(j).dominatedCount-1;
            if pop(j).dominatedCount == 0
                nextFront = [nextFront j];
                pop(j).rank = k+1;
            end
        end
    end
    if isempty(nextFront)
        break;
    end
    F{k+1} = nextFront;
    k = k+1;
end
end
function res = dominate(a,b)
    res=all(a.object<=b.object)&&any(a.object<b.object);
end