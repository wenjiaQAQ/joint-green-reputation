%% This function generate plans for agents
% Each company compares their current JR with peers of the same catogory
% if current JR > peerAverage: do nothing ~ [0, NA]
% if current JR < peerAverage:
%   if numNeighbors <= 2 : transfrom ~ [3, NA]
%   if numNeighbors < 5:
%       build connection with one whose JR (idAim) > peerAverage ~ [1, idAim]
%       if there is not such idAim ~ [0, NA]
%   if numNeighbor > 5
%       cut off the connection wiht one whose JR is the lowest
function strategyFirstPlan()

    global strategyPlan;
    global dynamicJRUpdate;
    global adjMatrix;
    
    global supplierRange manufacturerRange retailerRange n;        % id of retailers; dimension: 1*numRetailers

    currentJRValues = dynamicJRUpdate(:, end);
    % disp('currentJRValues');
    % disp(currentJRValues);
    currentAdjMatrix = adjMatrix(:, :, end);

    % Calculate peer average JR for each category
    supplierAverageJR = mean(currentJRValues(supplierRange));
    manufacturerAverageJR = mean(currentJRValues(manufacturerRange));
    retailerAverageJR = mean(currentJRValues(retailerRange));
    
    % disp('supplierAverageJR:');
    % disp(supplierAverageJR);
    % disp('manufacturerAverageJR:');
    % disp(manufacturerAverageJR);
    % disp('retailerAverageJR:');
    % disp(retailerAverageJR);

    % Each node's JR, neighbors, #neighbors
    % Degree matrix D (n x n)
    D = diag(sum(currentAdjMatrix, 2));
    
    for i = 1:n
        currentJR = currentJRValues(i);
        %disp('CurrentJR');
        %disp(currentJR);
        neighbors = find(currentAdjMatrix(i, :) == 1);
        %disp('CurrentJR neighbors');
        %disp(neighbors);
%         numNeighbors = length(neighbors);
        numNeighbors = D(i, i);
        %disp('CurrentJR neighbors length');
        %disp(numNeighbors);

        % Determine the category of the current node and future Neighbor
        if ismember(i, supplierRange)
            categoryAverageJR = supplierAverageJR;
            futureNeighborRange = manufacturerRange;
        elseif ismember(i, manufacturerRange)
            categoryAverageJR = manufacturerAverageJR;
            futureNeighborRange = [supplierRange, retailerRange];
        else
            categoryAverageJR = retailerAverageJR;
            futureNeighborRange = manufacturerRange;
        end

        % Maintain
        if currentJR > categoryAverageJR
            strategyPlan{i} = '[0, NA]';
        elseif currentJR <= categoryAverageJR
            % Transition to green
            if numNeighbors <= 2
                strategyPlan{i} = '[3, NA]';
                % Add neighbor
            elseif numNeighbors < 5
                % Find the future neighbor category and remove the existing
                % connections
                potentialNeighbors = setdiff(futureNeighborRange, neighbors);
                % Find node J which JR > peer average
                filteredNeighbors = [];
                for j = 1:length(potentialNeighbors)
                    neighbor = potentialNeighbors(j);
                    if ismember(neighbor, supplierRange) && currentJRValues(neighbor) > supplierAverageJR
                        filteredNeighbors = [filteredNeighbors, neighbor];
                    elseif ismember(neighbor, manufacturerRange) && currentJRValues(neighbor) > manufacturerAverageJR
                        filteredNeighbors = [filteredNeighbors, neighbor];
                    elseif ismember(neighbor, retailerRange) && currentJRValues(neighbor) > retailerAverageJR
                        filteredNeighbors = [filteredNeighbors, neighbor];
                    end
                end
                if ~isempty(filteredNeighbors)
                    % Random choose one potential neighbor
                    futureNeighborID = filteredNeighbors(randi(length(filteredNeighbors)));
                    strategyPlan{i} = ['[1, ', num2str(futureNeighborID), ']'];
                else
                    % No suitable future neighbors, for example, When node has [3,4] neighbor 
                    % and all potentialNeighbors already made connections
                    % Let this situation be maintain for now
                    % strategyPlan{i} = '[NA, NA]';  
                    strategyPlan{i} = '[0, NA]';
                end
                % Cut neighbor
            elseif numNeighbors >= 5
                % Find the lowest JR
                minJR = min(currentJRValues(neighbors));
                minJRNeighbors = neighbors(currentJRValues(neighbors) == minJR);
                % Random choose one if there are multiple
                neighborToDisconnect = minJRNeighbors(randi(length(minJRNeighbors)));
                strategyPlan{i} = ['[2, ', num2str(neighborToDisconnect), ']'];
            end
        end
    end
    % showTable(n, strategyPlan);
end