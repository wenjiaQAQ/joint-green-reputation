function runIterations()
    global t adjMatrix dynamicT2GUpdate steadyState

    % Time step threshold for stable detection
    steadyStateThreshold = 2;
    noChangeSteps = 0; 

    for iteration = 1:t
        % Get the current T2G and adjMatrix
        previousT2G = dynamicT2GUpdate(:, end);
        previousAdjMatrix = adjMatrix(:, :, end);
        
        %First Strategy Plan
        strategyFirstPlan2();

        % Check Add Success Strategy Plan
        strategyCheckAddSuccess2()

        % Update Fail Add Strategy Plan (final version)
        strategyFailAddUpdate2()
    

%         % First Strategy Plan
%         strategyFirstPlan(supplierRange, manufacturerRange, retailerRange, n);
%         % disp(['strategyFirstPlan at iteration ', num2str(iteration), ':']);
%         % disp(strategyPlan);
% 
%         % Check Add Success Strategy Plan
%         strategyCheckAddSuccess(supplierRange, manufacturerRange, retailerRange, n, alpha);
%         % disp(['strategyCheckAddSuccess at iteration ', num2str(iteration), ':']);
%         % disp(strategyPlan);
% 
%         % Update Fail Add Strategy Plan
%         strategyFailAddUpdate(n);
%         % disp(['strategyFailAddUpdate at iteration ', num2str(iteration), ':']);
%         % disp(strategyPlan);

        % Update T2G based on the strategy plan
        updateT2G();

        % Update adjacency matrix based on the strategy plan
        updateAdjacencyMatrix();

        % Update JR based on the new adjacency matrix and T2G values
        updateJR();

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
end
