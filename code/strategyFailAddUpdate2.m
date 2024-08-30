%% This function is to update the plan for nodes who failed to build new connection
% if numNeighbors < 2 => trans
% else if the JR of focal node is lower than all neighbors => maintain
% else cut off with the neighbor with lowest JR
function strategyFailAddUpdate2()
    global strategyPlan dynamicJRUpdate adjMatrix n

    currentJRValues = dynamicJRUpdate(:, end);
    currentAdjMatrix = adjMatrix(:, :, end);

    for i = 1:n
        % Find all nodes that failed add
        failedNodes = find(strategyPlan(:,1) == 1 & strategyPlan(:,2) == 2);
        numFailedNodes = length(failedNodes);
        
        for i = 1:numFailedNodes
            % data of the failedNode i
            neighbors = find(currentAdjMatrix(i, :) == 1);
            numNeighbors = length(neighbors);
            if numNeighbors < 2 % Transition to green !!!
                strategyPlan(i,:) = [3, NaN];
            else
                currentJR = currentJRValues(i);
                neighborsJR = currentJRValues(neighbors);
                % Maintain if current JR is less than all neighbors' JR
                if currentJR < min(neighborsJR)
                    strategyPlan(i,:) = [0, NaN];
                else
                    % Cut the neighbor with the lowest JR value !!!!!
                    minJR = min(currentJRValues(neighbors));
                    minJRNodes = intersect(find(currentJRValues == minJR), neighbors);
                    % If multiple, choose randomly
                    chosenNode = minJRNodes(randi(length(minJRNodes)));
                    strategyPlan(i) = [2, chosenNode];
                end
            end
            
        end
    end
end