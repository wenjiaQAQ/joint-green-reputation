%% Basic elements & init
%% This function run the model numIterations times, and each time is terminated at t
% The input of this function include: N, T, Alpha, k, numIter
% Output of this function contains two xlsx files: T2GHistory, dynamicJRUpdate, adjMatrix
function JGRRun(N, T, Alpha, k, numIter)
    global n;                    % #companies n = numSuppliers+numManufacturers+numRetailers
    global numSuppliers;        
    global numManufacturers;
    global numRetailers;
    global supplierRange;        % id of suppliers; dimension: 1*numSuppliers
    global manufacturerRange;    % id of manufactures; dimension: 1*numManufactures
    global retailerRange;        % id of retailers; dimension: 1*numRetailers
    
    global t;                    % timestep; t=0
    global K;                    % init tran ratio
    global initialT2GValues;     % Dimension: n*1
    
    global alpha;                % weight of joint green reputation
    %% network structure
    global adjMatrix;
    
    %% Dynamics
    global strategyPlan;        % dimension: n*1
    global dynamicT2GUpdate;    % dimension: n*1
    global dynamicJRUpdate;     % dimension: n*(t+1)
    global steadyState;         % the time step of reaching stable state
    global T2GHistory; 
    % Initialize variables
    n = N;  % {20,500}
    t = T; % Termination times
    alpha = Alpha;  % {0.2,0.5,0.7}
    K = k;  % {0.25,0.5,0.75}
    
    % Initialize strategy plan n*2 matrix
    strategyPlan = zeros(n, 2);
    steadyState = t;     % Terminating time step
    numIterations = numIter;  % Number of repetitions for the experiment

    T2GHistory = zeros((t+1)*numIterations,n);
    % **********************************************
    % allData = cell(1, numIterations);

    % Let the node be equally distributed
    numSuppliers = round(n * 0.33);
    numManufacturers = round(n * 0.33);
    numRetailers = n - numSuppliers - numManufacturers;
    
    % Index ranges
    supplierRange = 1:numSuppliers;
    manufacturerRange = numSuppliers + 1 : numSuppliers + numManufacturers;
    retailerRange = numSuppliers + numManufacturers + 1 : n;

    for currentIteration = 1:numIterations
        % Create initial adjacency matrix (t=0)
        adjMatrix = createAdjacencyMatrix();
        
        % Initial value of T2G
        initialT2GValues = zeros(n, 1);
        % Random choose nK nodes be green
        initialG = randperm(n, round(n * K));
        initialT2GValues(initialG) = 1;
        T2GHistory((currentIteration-1)*t+1,:) = initialT2GValues';
        % Initialize dynamicT2GUpdate
        dynamicT2GUpdate = initialT2GValues;
        
        % Calculate joint green repuataion
        dynamicJRUpdate = jrCalculate();
            
        % Loop for t iterations
        runSimulationStep();
%         allData{currentIteration} = dynamicT2GUpdate;
    end
    
    filename = 'D:\uva\courses\thesis\AllIterationsData.xlsx';
    for i = 1:numIterations
        sheetName = ['Iteration ' num2str(i)];
        writematrix(allData{i}, filename, 'Sheet', sheetName);
    end
end