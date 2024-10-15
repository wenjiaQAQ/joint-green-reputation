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
    
    global alpha;                % weight of joint green reputation
    %% network structure
    global adjMatrix;
    
    %% Dynamics
    global strategyPlan;        % dimension: n*1
    global dynamicT2GUpdate;    % dimension: n*1
    global dynamicJRUpdate;     % dimension: n*(t+1)
    global steadyState;         % the time step of reaching stable state
    % global T2GHistory; 
    % Initialize variables
    n = N;  % {20,500}
    t = T; % Termination times
    alpha = Alpha;  % {0.2,0.5,0.7}
    K = k;  % {0.25,0.5,0.75}
    numIterations = numIter;  % Number of repetitions for the experiment

    % Define the Excel file name
    addpath('.\Pre-exp\Data');
    dynamicT2Gfile = '.\Pre-exp\Data\dynamicT2G.xlsx';
    dynamicJRfile = '.\Pre-exp\Data\dynamicJR.xlsx';
    startRow = 1;
    dynamicAdjMatrixfile = '.\Pre-exp\Data\dynamicAdjMatrix.xlsx';
    startRowAdj = 1;
    for currentIteration = 1:numIterations
        % Initialize strategy plan n*2 matrix
        strategyPlan = zeros(n, 2);
        steadyState = t;     % Terminating time step
    
        dynamicT2GUpdate = zeros(n, (t+1));
        dynamicJRUpdate = zeros(n, (t+1));
        adjMatrix = zeros(n, n, (t+1));
    
        % Let the node be equally distributed
        numSuppliers = round(n * 0.33);
        numManufacturers = round(n * 0.33);
        numRetailers = n - numSuppliers - numManufacturers;
        
        % Index ranges
        supplierRange = 1:numSuppliers;
        manufacturerRange = numSuppliers + 1 : numSuppliers + numManufacturers;
        retailerRange = numSuppliers + numManufacturers + 1 : n;


        % Create initial adjacency matrix (t=0)
        adjMatrix(:, :, 1) = createAdjacencyMatrix();
        
        % Initial value of T2G
        initialT2GValues = zeros(n, 1);
        % Random choose nK nodes be green
        initialG = randperm(n, round(n * K));
        initialT2GValues(initialG) = 1;
        % T2GHistory((currentIteration-1)*t+1,:) = initialT2GValues';
        % Initialize dynamicT2GUpdate
        dynamicT2GUpdate(1,:) = initialT2GValues;
        
        % Calculate joint green repuataion
        dynamicJRUpdate(1,:) = jrCalculate(initialT2GValues, adjMatrix(:, :, 1));
            
        % Loop for t iterations
        runSimulationStep();
        
        % Every (t+1) rows of records represent one iteration; n columns
        % represent the companies
        writematrix(dynamicT2GUpdate.', dynamicT2Gfile, 'Sheet', 1, 'Range', sprintf('A%d', startRow));
        writematrix(dynamicJRUpdate.', dynamicJRfile, 'Sheet', 1, 'Range', sprintf('A%d', startRow));
        startRow  = startRow + T+1;
        % Every n(t+1) rows of records represent one iteration, each n row
        % of records represent the adjecenty matrix a one time step
        writematrix(dynamicAdjMatrixfile, dynamicAdjMatrixfile, 'Sheet', 1, 'AutoFitWidth', 'Range', sprintf('A%d', startRowAdj))
        startRowAdj = startRowAdj + N*(T+1);
    end
end