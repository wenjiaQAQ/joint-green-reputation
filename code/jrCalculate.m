%% This function is for calculate the Joint-green Reputation
% Output: the vector of JR: n*1
function JR = jrCalculate()
    global n alpha dynamicT2GUpdate adjMatrix
    
    T2G = dynamicT2GUpdate(:, end);
    adjM = adjMatrix(:, :, end);

    % Degree matrix D (n x n)
    D = diag(sum(adjM, 2));

    % Identity matrix I (n x n)
    I = eye(n);

    % Calculate the reputation vector R
    JR = (I - alpha * (D \ adjM)) \ ((1 - alpha) * T2G);
end