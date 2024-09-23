%% This function is to update the plan for nodes who failed to build new connection
% if numNeighbors < 2 => trans
% else if the JR of focal node is lower than all neighbors => maintain
% else cut off with the neighbor with lowest JR
function strategyFailAddUpdate2()
    global strategyPlan dynamicJRUpdate adjMatrix supplierRange manufacturerRange

    currentJRValues = dynamicJRUpdate(:, end);
    currentAdjMatrix = adjMatrix(:, :, end);

    % Find all nodes that failed add [1,-1]
    failedNodes = find(strategyPlan(:,1) == 1 & strategyPlan(:,2) == -1);
    numFailedNodes = length(failedNodes);
    
    if (numFailedNodes >=1)
        for i = 1:numFailedNodes
            % data of the failedNodes(i)
            neighbors = find(currentAdjMatrix(failedNodes(i), :) == 1);
            numNeighbors = length(neighbors);
            if numNeighbors < 2 % Transition to green !!!
                strategyPlan = helperPlanUpdate(strategyPlan, failedNodes(i), [3, NaN]);
            else
                currentJR = currentJRValues(failedNodes(i));
                neighborsJR = currentJRValues(neighbors);
                % If current JR is less than all neighbors' JR => Maintain 
                if currentJR < min(neighborsJR)
                    strategyPlan = helperPlanUpdate(strategyPlan, failedNodes(i), [0, NaN]);
                else
                    if ~isempty(find(manufacturerRange == failedNodes(i), 1)) % this is a manufacturer
                        neighbors_suppliers = neighbors(neighbors <= supplierRange(end));
                        neighbors_retailers = neighbors(neighbors > manufacturerRange(end));
                        if length(neighbors_suppliers) == 1 % remove the only supplier neighbor from "neighbors"
                            neighbors(neighbors == neighbors_suppliers) = [];
                        elseif length(neighbors_retailers) == 1 % remove the only supplier neighbor from "neighbors"
                            neighbors(neighbors == neighbors_retailers) = [];
                        end
                    end
                    % Cut the neighbor with the lowest JR value !!!!!
                    minJR = min(currentJRValues(neighbors));
                    minJRNodes = intersect(find(currentJRValues == minJR), neighbors);
                    % If multiple, choose randomly
                    chosenNode = minJRNodes(randi(length(minJRNodes)));
                    strategyPlan = helperPlanUpdate(strategyPlan, failedNodes(i), [2, chosenNode]);
                end
            end
        end
    end
end