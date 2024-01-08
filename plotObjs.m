function plotObjs(pop)
objs=[pop.object];
plot(objs(1,:),objs(2,:),'r*','MarkerSize',8);
xlabel('1^{st} Objective');
ylabel('2^{nd} Objective');
title('Non-dominated Solutions');
grid on;
end