function updateJR(alpha)
    global adjMatrix;
    global dynamicT2GUpdate;
    global dynamicJRUpdate;
    global n;

    % Get latest T2G & JR
    currentT2GValues = dynamicT2GUpdate(:, end);
    currentJRValues = dynamicJRUpdate(:, end);

    % Create new empty vector for update
    newJRValues = zeros(n, 1);

    % Calculate new JR
    for i = 1:n
        neighbors = find(adjMatrix(i, :, end));
        % No neighbor JR = T2G
        if isempty(neighbors)
            avgJR = currentJRValues(i);
        else
            % Partner average JR
            avgJR = mean([currentJRValues(i); currentJRValues(neighbors)]);
        end
        % New JR 
        newJRValues(i) = (1 - alpha) * currentT2GValues(i) + alpha * avgJR;
    end

    % Add new column to update JR
    dynamicJRUpdate = [dynamicJRUpdate, newJRValues];
end
