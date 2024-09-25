function runSimulationStep()
    global t adjMatrix dynamicT2GUpdate dynamicJRUpdate steadyState

    % Time step threshold for stable detection
    steadyStateThreshold = 2;
    noChangeSteps = 0; 

    for step = 1:t
        % Get the current T2G and adjMatrix
        currentT2GValues = dynamicT2GUpdate(:, end);
        currentJRValues = dynamicJRUpdate(:, end);
        currentAdjMatrix = adjMatrix(:, :, end);
        
        %First Strategy Plan
        strategyFirstPlan2(currentJRValues, currentAdjMatrix, currentT2GValues);

        % Check Add Success Strategy Plan
        strategyCheckAddSuccess2(currentJRValues, currentAdjMatrix, currentT2GValues)

        % Update Fail Add Strategy Plan (final version)
        strategyFailAddUpdate2(currentJRValues, currentAdjMatrix, currentT2GValues)

        % Update T2G based on the strategy plan
        updateT2G();

        % Update adjacency matrix based on the strategy plan
        updateAdjacencyMatrix();

        % Update JR based on the new adjacency matrix and T2G values
        updateJR();

         % Check changes of T2G and adjMatrix
        if isequal(currentT2GValues, dynamicT2GUpdate(:, end)) && isequal(currentAdjMatrix, adjMatrix(:, :, end))
            noChangeSteps = noChangeSteps + 1;
        else
            noChangeSteps = 0;
        end

        % If there is no change for several time steps, steady state is considered to be reached
        if noChangeSteps >= steadyStateThreshold
            disp('Steady state reached at:');
            disp(step);
            steadyState = step;
            break;
        end
    end
end
