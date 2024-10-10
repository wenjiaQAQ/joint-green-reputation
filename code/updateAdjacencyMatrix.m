function updateAdjacencyMatrix()
    global strategyPlan adjMatrix

    % Get the latest adjMatrix
    currentAdjMatrix = adjMatrix(:, :, end);

    % Create new matrix for update
    newAdjMatrix = currentAdjMatrix;
    
    % Extract the id to connect with
    nodesPlantoConnect = find(strategyPlan(:,1) == 1);
    if ~isempty(nodesPlantoConnect)
        toNodes = strategyPlan(nodesPlantoConnect,2);
        newAdjMatrix = helperMatrixUpdate(newAdjMatrix, nodesPlantoConnect, toNodes, 1);
    end
    
    % Extract the id to disconnect from
    nodesPlantoDisconnect = find(strategyPlan(:,1) == 2);
    if ~isempty(nodesPlantoDisconnect)
        toNodes = strategyPlan(nodesPlantoDisconnect,2);
        newAdjMatrix = helperMatrixUpdate(newAdjMatrix, nodesPlantoDisconnect, toNodes, 0);
    end

    % Add new matrix to 3D matrix
    adjMatrix(:, :, end + 1) = newAdjMatrix;
end

%% Test
% newAdjMatrix = currentAdjMatrix;
% for i = 1:length(toNodes)
%     if (newAdjMatrix(nodesPlantoDisconnect, toNodes) ~= 1)
%         error('fromNodes and toNodes do not have connection');
%     end
% end
% 
% % Extract the id to connect with
% nodesPlantoConnect = find(strategyPlan(:,1) == 1);
% if ~isempty(nodesPlantoConnect)
%     toNodes = strategyPlan(nodesPlantoConnect,2);
%     newAdjMatrix = helperMatrixUpdate(newAdjMatrix, nodesPlantoConnect, toNodes, 1);
% end
% % Extract the id to disconnect from
% nodesPlantoDisconnect = find(strategyPlan(:,1) == 2);
% if ~isempty(nodesPlantoDisconnect)
%     toNodes = strategyPlan(nodesPlantoDisconnect,2);
%     newAdjMatrix = helperMatrixUpdate(newAdjMatrix, nodesPlantoDisconnect, toNodes, 0);
% end
% 
% for i = 1:length(toNodes)
%     if (newAdjMatrix(nodesPlantoDisconnect, toNodes) ~= 0)
%         error('fromNodes and toNodes fail to disconnect');
%     end
% end
% % Pass