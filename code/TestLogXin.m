%% This script is for testing

%% createAdjacencyMatrix.m
% check the degree range
A = createAdjacencyMatrix(n, supplierRange, manufacturerRange, retailerRange);
degree = sum(A,2);
degree(supplierRange)'              % present the degree of suppliers
degree(manufacturerRange)'           % present the degree of manufactures
degree(retailerRange)'              % present the degree of retailers

% check the connection
sum(degree(supplierRange))+sum(degree(retailerRange)) == sum(degree(manufacturerRange)) % should be true

% check jrCalculate()
i = 1;
adjM = adjMatrix(:, :, end);
D = diag(sum(adjM, 2));
round(dynamicJRUpdate(i),4) == round((1-alpha)*dynamicT2GUpdate(i) + alpha*(adjM(i,:)*dynamicJRUpdate)/D(i,i),4)

% 

strategyPlan2 = zeros(6,2);
strategyPlan2(1,:) = [1, 2];
strategyPlan2(2,:) = [0,NaN];
strategyPlan2(3,:) = [1, 2];
strategyPlan2(4,:) = [1, 2];
strategyPlan2(5,:) = [1, 4];
strategyPlan2(6,:) = [2, 1];
display(strategyPlan2)

strategyPlan2(strategyPlan2(:,1) == 1,2)
unique(strategyPlan2(strategyPlan2(:,1) == 1,2))

~isempty(unique(strategyPlan2(strategyPlan2(:,1) == 1,2)))
