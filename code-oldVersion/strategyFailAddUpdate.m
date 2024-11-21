function strategyFailAddUpdate(n)

    global strategyPlan;
    global dynamicJRUpdate;
    global adjMatrix;

    currentJRValues = dynamicJRUpdate(:, end);
    currentAdjMatrix = adjMatrix(:, :, end);

    for i = 1:n
        % Find all nodes that failed add
        if strcmp(strategyPlan{i}, '[1, -1]')
            neighbors = find(currentAdjMatrix(i, :) == 1);
            numNeighbors = length(neighbors);

            % Transition to green
            if numNeighbors <= 2
                strategyPlan{i} = '[3, NA]';
            else
                currentJR = currentJRValues(i);
                neighborsJR = currentJRValues(neighbors);
                % Maintain if current JR is less than all neighbors' JR
                if currentJR < min(neighborsJR)
                    strategyPlan{i} = '[0, NA]';
                else
                    % Cut the neighbor with the lowest JR value
                    [minJR, idx] = min(neighborsJR);
                    neighborToDisconnect = neighbors(idx);
                    strategyPlan{i} = ['[2, ', num2str(neighborToDisconnect), ']'];
                end
            end
        end
    end
end