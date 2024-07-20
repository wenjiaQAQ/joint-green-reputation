clc;
%addpath(genpath('D:\uva\courses\thesis\code'))

global n;
global t;                    %t=0
global K;%size: t+1x1   update[K0,0.4,0.2,...]
global alpha;
global numSuppliers;
global numManufacturers;
global numRetailers;
global supplierRange;
global manufacturerRange
global retailerRange
global initialT2GValues;
global initialJRValues;
global adjMatrix;
global strategyPlan;
global dynamicT2GUpdate;
global dynamicJRUpdate;
global supplierAverageJR;
global manufacturerAverageJR;
global retailerAverageJR;
global steadyState;


% Initialize variables
n = 20;  % {20,500}
t = 500;
alpha = 0.7;  % {0.2,0.5,0.7}
K = 0.75;  % {0.25,0.5,0.75}
% Initialize strategy plan cell array
strategyPlan = cell(n, 1);
steadyState = t;
numIterations = 30;  % Number of repetitions for the experiment
allData = cell(1, numIterations);

% Let the node be equally distributed
numSuppliers = round(n * 0.33);
numManufacturers = round(n * 0.33);
numRetailers = n - numSuppliers - numManufacturers;

% Index ranges
supplierRange = 1:numSuppliers;
manufacturerRange = numSuppliers + 1 : numSuppliers + numManufacturers;
retailerRange = numSuppliers + numManufacturers + 1 : n;
% disp('supplierRange:');
% disp(supplierRange);
% disp('manufacturerRange:');
% disp(manufacturerRange);
% disp('retailerRange:');
% disp(retailerRange);

for currentIteration = 1:numIterations
    % Create initial adjacency matrix (t=0)
    adjMatrix = createAdjacencyMatrix(n, supplierRange, manufacturerRange, retailerRange);
    % disp(adjMatrix(:,:,1)); 
    
    % Initial value of T2G
    initialT2GValues = zeros(n, 1);
    % Random choose nK nodes be green
    initialG = randperm(n, round(n * K));
    initialT2GValues(initialG) = 1;
    % disp('initialT2GValues:');
    % showTable(n, initialT2GValues);
    % Initialize dynamicT2GUpdate
    dynamicT2GUpdate = initialT2GValues;
    
    %initial value of JR
    weightT2G = 1 - alpha;
    initialJRValues = weightT2G * initialT2GValues;
    % Initialize dynamicJRUpdate
    dynamicJRUpdate = initialJRValues; 
    % disp('initialJRValues:');
    % showTable(n, initialJRValues);
    
    %First Strategy Plan
    strategyFirstPlan(supplierRange, manufacturerRange, retailerRange, n);
    % disp('strategyFirstPlan:');
    % disp(strategyPlan);
    
    % Check Add Success Strategy Plan
    strategyCheckAddSuccess(supplierRange, manufacturerRange, retailerRange, n, alpha);
    % disp('strategyCheckAddSuccess:');
    % disp(strategyPlan);
    
    % Update Fail Add Strategy Plan (final version)
    strategyFailAddUpdate(n);
    % disp('strategyFailAddUpdate:');
    % disp(strategyPlan);
    
    % Update T2G
    updateT2G();
    % disp('update T2G:');
    % disp(dynamicT2GUpdate);
    
    % Update adjMatric
    updateAdjacencyMatrix();
    % disp('Updated adjacency matrix:');
    % disp(adjMatrix(:, :, end));
    % for i = 1:n
    %     neighbors = find(adjMatrix(i, :, end)); 
    %     fprintf('Node %d has neighbors: %s\n', i, mat2str(neighbors)); 
    % end
    
    
    % Update JR value
    updateJR(alpha);
    % disp('Updated JR values:');
    % disp(dynamicJRUpdate);
    
    % Loop for t iterations
    %runIterations(t, alpha, numIterations);
    runIterations(t, alpha);
    allData{currentIteration} = dynamicT2GUpdate;
end

filename = 'D:\uva\courses\thesis\AllIterationsData.xlsx';
for i = 1:numIterations
    sheetName = ['Iteration ' num2str(i)];
    writematrix(allData{i}, filename, 'Sheet', sheetName);
end

%Plot average T2G Diffusion Curve
plotAverageT2GDiffusionCurve(t, numIterations)

% Plot the T2G diffusion curve
% plotT2GDiffusionCurve(steadyState);

% Plot the JR diffusion curve
%plotJRDiffusionCurve(t);

% Plot AdjMatrix Structure
%plotAdjMatrixStructure();

% Plot average degree and variancce degree
%outputDegreeStatsTable();