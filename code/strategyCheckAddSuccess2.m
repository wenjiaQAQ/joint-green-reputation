%% This funtion is to check if the generated stratagePlan is successful
% Aim: Update strategyPlan
function strategyCheckAddSuccess2(currentJRValues, currentAdjMatrix, currentT2GValues, currentNumNeighborTable)
    global alpha strategyPlan
    global supplierAveJR manufacturerAveJR retailerAveJR supplierRange retailerRange


    % Find the current node (focal company that are chosen to be connected)
    currentNodes = unique(strategyPlan((strategyPlan(:,1) == 1),2));
    numCurrentNodes = length(currentNodes);
    if numCurrentNodes ~= 0
        for i = 1: numCurrentNodes % current Node: currentNodes(i)
            % data of the currentNode currentNodes(i)
            currentJR = currentJRValues(currentNodes(i));
            currentT2G = currentT2GValues(currentNodes(i));
            neighbors = find(currentAdjMatrix(currentNodes(i), :) == 1);
            numNeighbors = length(neighbors);
            tooManyNeighbors = currentNumNeighborTable(currentNodes(i), 6); % 1 := #neighbor >=5
            categoryCurrentNodes = currentNumNeighborTable(currentNodes(i), 1); % 1 := supplier;  2 := manufacture;  3 := retailer
            
            % Determine the category of the current node
            categoryAverageJR = helperCategoryAveJR(categoryCurrentNodes, supplierAveJR, manufacturerAveJR, retailerAveJR);
                        
            % Find id of the nodes that want to connect to the current node
            nodesToConnect = find(strategyPlan(:,2) == currentNodes(i));
            % If current node has too many neighbors nodesToConnect => update to [1, -1]
            if tooManyNeighbors
                if categoryCurrentNodes == 2 % current node is a Manufacture
                    numSupplierNeighbors = currentNumNeighborTable(currentNodes(i), 2); 
                    nodesToConnectSupplier = nodesToConnect(nodesToConnect <= supplierRange(end));
                    nodesToConnectRetailer = nodesToConnect(nodesToConnect >= retailerRange(1));
                    if numSupplierNeighbors >= 5 % have too many supplier neighbors
                        % nodesToConnectSupplier fail to add
                        nodesFailtoAdd = nodesToConnectSupplier;
                    else
                        nodesFailtoAdd = nodesToConnectRetailer;
                    end
                else % current node is a Supplier or a Retailer
                    nodesFailtoAdd = nodesToConnect;
                end
            else % still have space for new neighbors, select the node with the higest JR to connect
                nodesFailtoAdd= helperExcludeNodeHightestJR(currentT2G, currentJR, alpha, categoryAverageJR, numNeighbors, nodesToConnect, currentJRValues);
            end
            % For nodesFailtoAdd, update their plan with [1, -1]
            strategyPlan = helperPlanUpdate(strategyPlan, nodesFailtoAdd, [1, -1]);
        end
    end
end
