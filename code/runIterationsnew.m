function runIterationsnew(t, alpha, numIterations)
    global n;
    global adjMatrix;
    global dynamicT2GUpdate;
    global dynamicJRUpdate;
    global supplierRange;
    global manufacturerRange;
    global retailerRange;
    global strategyPlan;
    global initialT2GValues;
    global initialJRValues;
    global steadyState;

    % Time step threshold for stable detection
    steadyStateThreshold = 2;
    noChangeSteps = 0; 

    for iteration = 1:t
        % Get the current T2G and adjMatrix
        previousT2G = dynamicT2GUpdate(:, end);
        previousAdjMatrix = adjMatrix(:, :, end);

        % First Strategy Plan
        strategyFirstPlan(supplierRange, manufacturerRange, retailerRange, n);
        % disp(['strategyFirstPlan at iteration ', num2str(iteration), ':']);
        % disp(strategyPlan);

        % Check Add Success Strategy Plan
        strategyCheckAddSuccess(supplierRange, manufacturerRange, retailerRange, n, alpha);
        % disp(['strategyCheckAddSuccess at iteration ', num2str(iteration), ':']);
        % disp(strategyPlan);

        % Update Fail Add Strategy Plan
        strategyFailAddUpdate(n);
        % disp(['strategyFailAddUpdate at iteration ', num2str(iteration), ':']);
        % disp(strategyPlan);

        % Update T2G based on the strategy plan
        updateT2G();
        % disp(['update T2G at iteration ', num2str(iteration), ':']);
        % disp(dynamicT2GUpdate);

        % Update adjacency matrix based on the strategy plan
        updateAdjacencyMatrix();
        % disp(['Updated adjacency matrix at iteration ', num2str(iteration), ':']);
        % disp(adjMatrix(:, :, end));
        % for i = 1:n
        %     neighbors = find(adjMatrix(i, :, end)); 
        %     fprintf('Node %d has neighbors at iteration %d: %s\n', i, iteration, mat2str(neighbors)); 
        % end

        % Update JR based on the new adjacency matrix and T2G values
        updateJR(alpha);
        % disp(['Updated JR values at iteration ', num2str(iteration), ':']);
        % disp(dynamicJRUpdate);

         % Check changes of T2G and adjMatrix
        if isequal(previousT2G, dynamicT2GUpdate(:, end)) && isequal(previousAdjMatrix, adjMatrix(:, :, end))
            noChangeSteps = noChangeSteps + 1;
        else
            noChangeSteps = 0;
        end

        % If there is no change for several time steps, steady state is considered to be reached
        if noChangeSteps >= steadyStateThreshold
            disp('Steady state reached at:');
            disp(iteration);
            steadyState = iteration;
            break;
        end
    end

    % If steady state is reached, keep the last value for the remaining iterations
    if noChangeSteps >= steadyStateThreshold && iteration < numIterations
        finalT2G = dynamicT2GUpdate(:, end);
        finalAdjMatrix = adjMatrix(:, :, end);
        finalJR = dynamicJRUpdate(:, end);

        for remainingIter = iteration+1:numIterations
            dynamicT2GUpdate = [dynamicT2GUpdate, finalT2G];
            adjMatrix(:, :, end+1) = finalAdjMatrix;
            dynamicJRUpdate = [dynamicJRUpdate, finalJR];
        end
    end
end
