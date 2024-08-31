%% This function generate plans for agents
% Each company compares their current JR with peers of the same catogory
% if current JR > peerAverage: do nothing ~ [0, NaN]
% if current JR < peerAverage:
%   if numNeighbors <= 2 : transfrom ~ [3, NaN]
%   if numNeighbors < 5:
%       build connection with one whose JR (idAim) > peerAverage ~ [1, idAim]
%       if there is not such idAim ~ [0, NaN]
%   if numNeighbor >= 5
%       cut off the connection wiht one whose JR is the lowest ~ [2, idAim]
function strategyFirstPlan2()

    global dynamicJRUpdate adjMatrix n supplierRange 
    global manufacturerRange retailerRange supplierAveJR 
    global manufacturerAveJR retailerAveJR strategyPlan
    
    currentJRValues = dynamicJRUpdate(:, end);
    currentAdjMatrix = adjMatrix(:, :, end);

    % Calculate peer average JR for each category
    supplierAveJR = mean(currentJRValues(supplierRange));
    manufacturerAveJR = mean(currentJRValues(manufacturerRange));
    retailerAveJR = mean(currentJRValues(retailerRange));
    
    % Construct the currentJRPeerJRTable
    currentJRPeerJRTable(:,1) = currentJRValues;
    currentJRPeerJRTable(supplierRange,2) = supplierAverageJR;    
    currentJRPeerJRTable(manufacturerRange,2) = manufacturerAverageJR;
    currentJRPeerJRTable(retailerRange,2) = retailerAverageJR;

    % Each node's JR, neighbors, #neighbors
    % Degree matrix D (n x n)
    D = diag(sum(currentAdjMatrix, 2));
    currentJRPeerJRTable(:, 3) = diag(D);
    
    
    
    %% JR > peerAverage: do nothing ~ [0, NaN]
    needNothing = find(currentJRPeerJRTable(:,1) > currentJRPeerJRTable(:,2));
    if ~isempty(needNothing) && all(needNothing <= n)
        strategyPlan = helperPlanUpdate(strategyPlan, needNothing, [0, NaN]);
    end
    
    %% numNeighbors <= 2 : transfrom ~ [3, NaN]
    needTransfer = find(currentJRPeerJRTable(:,1) <= currentJRPeerJRTable(:,2) & currentJRPeerJRTable(:,3) <= 2);
    if ~isempty(needTransfer) && all(needTransfer <= n)
        strategyPlan = helperPlanUpdate(strategyPlan, needTransfer, [3, NaN]);
    end
    
    %% numNeighbor >= 5, cut off the connection wiht one whose JR is the lowest ~ [2, idAim]
    idfor2 = currentJRPeerJRTable(:,1) <= currentJRPeerJRTable(:,2) & currentJRPeerJRTable(:,3) >= 5; % [0 1 1 0 0 0 1 0 ...]
    idfor2(manufacturerRange) = 0; % exclude manufacturerRange
    idfor2(manufacturerRange' & currentJRPeerJRTable(manufacturerRange,3) >= 10) = 1; % unless manufacturerRange >=10
    % the id of companies who needs to cut off
    needtoCut = find(idfor2 == 1);
    numNeedtoCut = length(needtoCut); % the number of company who needs to cut with neighbors
    % for the companies who needs to cut, cut off with their lowest neighbor
    if (numNeedtoCut~=0)
        for i = 1:numNeedtoCut
            neighbors = find(currentAdjMatrix(needtoCut(i), :)==1);
            % if the node is not manufacture
            if ~isempty(find(manufacturerRange == needtoCut(i), 1)) % the node is a manufacture. Idea1: maintain at least one connection with suppliers / retailers;
                % idea2: cut off with the neighbor who is from the specific side which has more than 5 cooperators, and meanwhile has the lowest JR
                neighbors_suppliers = neighbors(neighbors <= supplierRange(end));
                neighbors_retailers = neighbors(neighbors > manufacturerRange(end));
                if sum(neighbors_suppliers) >= sum(neighbors_retailers) % need to cut with one supplier neighbor
                    neighbors = neighbors_suppliers;
                else % need to cut with one retailer neighbors
                    neighbors = neighbors_retailers;
                end
            end
            % Find the lowest JR of needtoCut(i)'s neighbor, and cut connection
            minJR = min(currentJRValues(neighbors));
            minJRNeighbors = neighbors(currentJRValues(neighbors) == minJR);
            % Random choose one if there are multiple
            neighborToDisconnect = minJRNeighbors(randi(length(minJRNeighbors)));
            strategyPlan = helperPlanUpdate(strategyPlan, needtoCut(i), [2, neighborToDisconnect]);
        end
    end
    
    %% The rest companies are current JR < peerAverage, need to either build new connections or do nothing
    ones_vector = ones(size(idfor0)); % Create a vector of ones with the same size as idfor0
    ones_vector([needNothing; needTransfer; needtoCut]) = 0;
    needtoAdd = find(ones_vector == 1);
    numNeedtoAdd = length(needtoAdd);
    if (numNeedtoAdd~=0)
        for i = 1:numNeedtoAdd
            if ismember(needtoAdd(i), supplierRange)
                futureNeighborRange = manufacturerRange;
            elseif ismember(needtoAdd(i), manufacturerRange)
                futureNeighborRange = [supplierRange, retailerRange];
            else
                futureNeighborRange = manufacturerRange;
            end
            
            % Find the future neighbor category and remove the existing
            % connections
            neighbors = find(currentAdjMatrix(needtoAdd(i),:)==1);
            potentialNeighbors = setdiff(futureNeighborRange, neighbors);
            % Find node J which JR > peer average
            filteredNeighbors = filteredNeighborsGenerate(potentialNeighbors, currentJRPeerJRTable);
            
            if ~isempty(filteredNeighbors)
                % Random choose one potential neighbor
                futureNeighborID = filteredNeighbors(randi(length(filteredNeighbors)));
                strategyPlan = helperPlanUpdate(strategyPlan, needtoAdd(i), [1, futureNeighborID]);
            else
                % No suitable future neighbors, for example, When node has [3,4] neighbor 
                % and all potentialNeighbors already made connections
                % Let this situation be maintain for NOW
                strategyPlan = helperPlanUpdate(strategyPlan, needtoAdd(i), [0, NaN]);
            end
        end
    end
end