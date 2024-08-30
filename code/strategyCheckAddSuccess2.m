%% This funtion is to check if the generated stratagePlan is successful
% Aim: Update strategyPlan
function strategyCheckAddSuccess2(supplierAveJR, manufacturerAveJR, retailerAveJR)
    global alpha strategyPlan dynamicT2GUpdate dynamicJRUpdate adjMatrix

    currentT2GValues = dynamicT2GUpdate(:, end);
    % disp('dynamicT2GUpdate');
    % disp(dynamicT2GUpdate);
    currentJRValues = dynamicJRUpdate(:, end);
    % disp('currentJRValues');
    % disp(currentJRValues);
    currentAdjMatrix = adjMatrix(:, :, end);

    % Find the current node (focal company that are chosen to be connected)
    currentNodes = unique(strategyPlan(strategyPlan(:,1) == 1,2));
    numCurrentNodes = length(currentNodes);
    if numCurrentNodes ~= 0
        for i = 1: numCurrentNodes % current Node: currentNodes(i)
            % data of the currentNode i
            currentJR = currentJRValues(i);
            currentT2G = currentT2GValues(i);
            neighbors = find(currentAdjMatrix(i, :) == 1);
            numNeighbors = length(neighbors);
            
            % Determine the category of the current node
            categoryAverageJR = helperCategoryAveJR(nodeID, supplierAveJR, manufacturerAveJR, retailerAveJR);
            
            % Find nodes that want to connect to the current node
            nodesToConnect = intersect(neighbors, find(strategyPlan(:,2) == currentNodes(i)));
            if ~isempty(nodesToConnect) % If there are nodes that want to connect
                if numNeighbors >= 5 % If current node has more than 5 neighbors, nodesToConnect => update to [1, -1]
                    strategyPlan(nodesToConnect,:) = [1, -1];
                else % If current node has less than 5 neighbors
                    % Find the node with the highest JR value
                    maxJR = max(currentJRValues(nodesToConnect));
                    maxJRNodes = intersect(find(currentJRValues == maxJR), nodesToConnect); % !!!!
                    % If multiple, choose randomly
                    chosenNode = maxJRNodes(randi(length(maxJRNodes)));

                    % Calculate new JR value after adding the chosen node as neighbor
                    newJR = (1-alpha)*currentT2G + alpha*(currentJR*numNeighbors - (1-alpha)*currentT2G*numNeighbors + maxJR)/(numNeighbors+1);
                    
                    if newJR > categoryAverageJR % If new JR value is still greater than category average JR
                        % Update strategyPlan for the nodes that were not chosen
                        nodesNotChosen = setdiff(nodesToConnect, chosenNode);
                        for k = 1:length(nodesNotChosen)
                            strategyPlan(nodesNotChosen,:) = [1, -1];
                        end
                    else % Otherwise all building new connection fail !!!
                        strategyPlan(nodesToConnect,:) = [1, -1]; 
                    end
                end
            end
        end
    end
end
