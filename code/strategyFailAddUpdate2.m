%% This function is to update the plan for nodes who failed to build new connection
% !!!
% If adding neighbors fail, then need to either cutoff with the neighbor
% who has the lowest JR, or trans
% Alg: Already trans? (if the focal already trans, but add fail, then there must be neighbors with low JR)
%        Y: Cutoff with lowest neighbor
%        N: Has neighbor? (first consider to cutting off, unless the focal is the loest)
%               N: trans (I have no neighbors, I haven't trans)
%               Y: is the JR of the focal lower than all neighbors?
%                        Y: trans
%                        N: cut off with the lowest neighbor
function strategyFailAddUpdate2(currentJRValues, currentAdjMatrix, currentT2GValues)
    global strategyPlan

    % Find all nodes that failed add [1,-1]
    failedNodes = find(strategyPlan(:,1) == 1 & strategyPlan(:,2) == -1);
    numFailedNodes = length(failedNodes);
    
    % currentNumNeighborTable(failedNodes(i), 4) == 1 if #neighbors <=2;
    % ==0, otherwise

    if numFailedNodes > 0
        for i = 1:numFailedNodes
            node = failedNodes(i);
            neighbors = find(currentAdjMatrix(node, :) == 1);
            [idminNeighbor, minNeighborJR] = helperFindLowestJRNeighbor(currentJRValues, neighbors);
            hasNeighbors = ~isempty(neighbors);
            alreadyTransferred = currentT2GValues(node);

            if alreadyTransferred
                % Already transferred, but still JR < AVEpeer, cut off with the lowest neighbor
                strategyPlan = helperPlanUpdate(strategyPlan, node, [2, idminNeighbor]);
            elseif ~hasNeighbors
                % No neighbors, transfer
                % Note that, for manufactures, no neighbors means they have
                % no upper or lower partners. If they have only on stream
                % partners, that also means there might be potential
                % partner with low JR can be cut off
                strategyPlan = helperPlanUpdate(strategyPlan, node, [3, NaN]);
            else
                % Has neighbors
                if currentJRValues(node) < minNeighborJR
                    % I have the lowest JR, transfer
                    strategyPlan = helperPlanUpdate(strategyPlan, node, [3, NaN]);
                else
                    % Cut off with the lowest neighbor
                    strategyPlan = helperPlanUpdate(strategyPlan, node, [2, idminNeighbor]);
                end
            end
        end
    end
end