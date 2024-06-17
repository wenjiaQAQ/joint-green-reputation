function strategyCheckAddSuccess(supplierRange, manufacturerRange, retailerRange, initialJRValues, initialT2GValues, n, adjMatrix, alpha)

    global strategyPlan;

    % Calculate peer average JR for each category
    supplierAverageJR = mean(initialJRValues(supplierRange));
    manufacturerAverageJR = mean(initialJRValues(manufacturerRange));
    retailerAverageJR = mean(initialJRValues(retailerRange));

    % Define the current node
    for i = 1:n
        currentJR = initialJRValues(i);
        currentT2G = initialT2GValues(i);
        neighbors = find(adjMatrix(i, :) == 1);
        numNeighbors = length(neighbors);

        % Determine the category of the current node
        if ismember(i, supplierRange)
            categoryAverageJR = supplierAverageJR;
        elseif ismember(i, manufacturerRange)
            categoryAverageJR = manufacturerAverageJR;
        else
            categoryAverageJR = retailerAverageJR;
        end

        % If current node's JR is greater than category average JR
        if currentJR > categoryAverageJR
            % Find nodes that want to connect to the current node
            nodesToConnect = [];
            for j = 1:n
                if strcmp(strategyPlan{j}, ['[1, ', num2str(i), ']'])
                    nodesToConnect = [nodesToConnect, j];
                end
            end
            
            % If there are nodes that want to connect and current node has less than 5 neighbors
            if ~isempty(nodesToConnect) && numNeighbors < 5
                % Find the node with the highest JR value
                maxJR = max(initialJRValues(nodesToConnect));
                maxJRNodes = nodesToConnect(initialJRValues(nodesToConnect) == maxJR);
                % If multiple, choose randomly
                chosenNode = maxJRNodes(randi(length(maxJRNodes)));

                % Calculate new JR value after adding the chosen node as neighbor
                newJR = (1 - alpha) * currentT2G + alpha * (currentJR + sum(initialJRValues(neighbors)) + initialJRValues(chosenNode)) / (numNeighbors + 1 + 1);
                
                % If new JR value is still greater than category average JR
                if newJR > categoryAverageJR
                    % Update strategyPlan for the nodes that were not chosen
                    nodesNotChosen = setdiff(nodesToConnect, chosenNode);
                    for k = 1:length(nodesNotChosen)
                        strategyPlan{nodesNotChosen(k)} = '[1, -1]';
                    end
                end
            end
        end
    end
end