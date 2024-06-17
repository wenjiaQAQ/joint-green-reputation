function runIterations(t, alpha)
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

    for iteration = 1:t
        % First Strategy Plan
        strategyFirstPlan(supplierRange, manufacturerRange, retailerRange, dynamicJRUpdate(:, end), n, adjMatrix);
        disp(['strategyFirstPlan at iteration ', num2str(iteration), ':']);
        disp(strategyPlan);

        % Check Add Success Strategy Plan
        strategyCheckAddSuccess(supplierRange, manufacturerRange, retailerRange, dynamicJRUpdate(:, end), dynamicT2GUpdate(:, end), n, adjMatrix, alpha);
        disp(['strategyCheckAddSuccess at iteration ', num2str(iteration), ':']);
        disp(strategyPlan);

        % Update Fail Add Strategy Plan
        strategyFailAddUpdate(dynamicJRUpdate(:, end), n, adjMatrix);
        disp(['strategyFailAddUpdate at iteration ', num2str(iteration), ':']);
        disp(strategyPlan);

        % Update T2G based on the strategy plan
        updateT2G();
        disp(['update T2G at iteration ', num2str(iteration), ':']);
        disp(dynamicT2GUpdate);

        % Update adjacency matrix based on the strategy plan
        updateAdjacencyMatrix();
        disp(['Updated adjacency matrix at iteration ', num2str(iteration), ':']);
        disp(adjMatrix(:, :, end));
        for i = 1:n
            neighbors = find(adjMatrix(i, :, end)); 
            fprintf('Node %d has neighbors at iteration %d: %s\n', i, iteration, mat2str(neighbors)); 
        end

        % Update JR based on the new adjacency matrix and T2G values
        updateJR(alpha);
        disp(['Updated JR values at iteration ', num2str(iteration), ':']);
        disp(dynamicJRUpdate);
    end
end
