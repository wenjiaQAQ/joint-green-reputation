%% This function generate plans for agents
% Each company compares their current JR with peers of the same catogory
% if current JR > peerAverage: do nothing ~ [0, NA]
% if current JR < peerAverage:
%   if numNeighbors <= 2 : transfrom ~ [3, NA]
%   if numNeighbors < 5:
%       build connection with one whose JR (idAim) > peerAverage ~ [1, idAim]
%       if there is not such idAim ~ [0, NA]
%   if numNeighbor >= 5
%       cut off the connection wiht one whose JR is the lowest ~ [2, idAim]
function strategyPlan2 = strategyFirstPlan2()

    global dynamicJRUpdate;
    global adjMatrix;
    
    global supplierRange manufacturerRange retailerRange n;        % id of retailers; dimension: 1*numRetailers
    
    strategyPlan2 = cell(20, 1);
    currentJRValues = dynamicJRUpdate(:, end);
    currentAdjMatrix = adjMatrix(:, :, end);

    % Calculate peer average JR for each category
    supplierAverageJR = mean(currentJRValues(supplierRange));
    manufacturerAverageJR = mean(currentJRValues(manufacturerRange));
    retailerAverageJR = mean(currentJRValues(retailerRange));
    
    % Construct the currentJRPeerJRTable
    currentJRPeerJRTable(:,1) = currentJRValues;
    currentJRPeerJRTable(supplierRange,2) = supplierAverageJR;    
    currentJRPeerJRTable(manufacturerRange,2) = manufacturerAverageJR;
    currentJRPeerJRTable(retailerRange,2) = retailerAverageJR;

    % Each node's JR, neighbors, #neighbors
    % Degree matrix D (n x n)
    D = diag(sum(currentAdjMatrix, 2));
    currentJRPeerJRTable(:, 3) = diag(D);
    
    %% JR > peerAverage: do nothing ~ [0, NA]
    idfor0 = currentJRPeerJRTable(:,1) > currentJRPeerJRTable(:,2);
    needNothing = find(idfor0 == 1);
    if all(needNothing <= length(strategyPlan2))
        strategyPlan2(needNothing) = {'[0, Na]'};
    else
        error('Indices in needNothing exceed the dimensions of strategyPlan.');
    end
    
    %% numNeighbors <= 2 : transfrom ~ [3, NA]
    idfor3 = currentJRPeerJRTable(:,1) <= currentJRPeerJRTable(:,2) & currentJRPeerJRTable(:,3) <= 2;
    needTransfer = find(idfor3 == 1);
    if all(needTransfer <= length(strategyPlan2))
        strategyPlan2(needTransfer) = {'[3, NA]'};
    else
        error('Indices in needNothing exceed the dimensions of strategyPlan.');
    end
    
    %% numNeighbor >= 5, cut off the connection wiht one whose JR is the lowest ~ [2, idAim]
    idfor2 = currentJRPeerJRTable(:,1) <= currentJRPeerJRTable(:,2) & currentJRPeerJRTable(:,3) >= 5;
    idfor2(manufacturerRange) = 0; % exclude manufacturerRange
    idfor2(manufacturerRange' & currentJRPeerJRTable(manufacturerRange,3) >= 10) = 1; % unless manufacturerRange >=10
    % companies who needs to cut off
    needtoCut = find(idfor2 == 1);
    numNeedtoCut = length(needtoCut);
    allNodes = 1:1:n;
    % cut off with their lowest neighbor
    if (numNeedtoCut~=0)
        for i = 1:numNeedtoCut
            % Find the lowest JR of needtoCut(i)'s neighbor, and cut
            % connection
            neighbors = allNodes(currentAdjMatrix(:,needtoCut(i))==1);
            minJR = min(currentJRValues(neighbors));
            minJRNeighbors = neighbors(currentJRValues(neighbors) == minJR);
            % Random choose one if there are multiple
            neighborToDisconnect = minJRNeighbors(randi(length(minJRNeighbors)));
            strategyPlan2{i} = ['[2, ', num2str(neighborToDisconnect), ']'];
        end
    end
    
    %% The rest companies are current JR < peerAverage, need to either build new connections or do nothing
    ones_vector = ones(size(idfor0)); % Create a vector of ones with the same size as idfor0
    idfor3 = ones_vector - idfor0 - idfor3 - idfor2;
    needtoAdd = find(idfor3 == 1);
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
            neighbors = find(currentAdjMatrix(:,needtoAdd(i)));
            potentialNeighbors = setdiff(futureNeighborRange, neighbors);
            % Find node J which JR > peer average
            filteredNeighbors = filteredNeighborsGenerate(potentialNeighbors, currentJRPeerJRTable);
            
            if ~isempty(filteredNeighbors)
                % Random choose one potential neighbor
                futureNeighborID = filteredNeighbors(randi(length(filteredNeighbors)));
                strategyPlan2{needtoAdd(i)} = ['[1, ', num2str(futureNeighborID), ']'];
            else
                % No suitable future neighbors, for example, When node has [3,4] neighbor 
                % and all potentialNeighbors already made connections
                % Let this situation be maintain for now
                % strategyPlan{i} = '[NA, NA]';  
                strategyPlan2{needtoAdd(i)} = '[0, NA]';
            end
        end
    end
end