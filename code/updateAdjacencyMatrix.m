function updateAdjacencyMatrix()
    global strategyPlan;
    global adjMatrix;
    global n;

    % Get the latest adjMatrix
    currentAdjMatrix = adjMatrix(:, :, end);

    % Create new matrix for update
    newAdjMatrix = currentAdjMatrix;

    for i = 1:n
        strategy = strategyPlan{i};
        strategy = char(strategy); % Convert to character array (string)
        if startsWith(strategy, '[1,')
            % Extract the id to connect with
            id = str2double(extractBetween(strategy, '[1, ', ']'));
            newAdjMatrix(i, id) = 1;
            newAdjMatrix(id, i) = 1; 
        elseif startsWith(strategy, '[2,')
            % Extract the id to disconnect from
            id = str2double(extractBetween(strategy, '[2, ', ']'));
            newAdjMatrix(i, id) = 0;
            newAdjMatrix(id, i) = 0; 
        end
    end

    % Add new matrix to 3D matrix
    adjMatrix(:, :, end + 1) = newAdjMatrix;

    % % Display updated adjacency matrix
    % disp('Updated adjacency matrix:');
    % disp(adjMatrix(:, :, end));
    % for i = 1:n
    %     neighbors = find(adjMatrix(i, :, end)); 
    %     fprintf('Node %d has neighbors at iteration %d: %s\n', i, numel(adjMatrix(1, 1, :)), mat2str(neighbors)); 
    % end
end
