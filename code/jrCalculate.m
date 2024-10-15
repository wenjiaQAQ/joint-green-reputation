%% This function is for calculate the Joint-green Reputation
% Output: the vector of JR: n*1
function JR = jrCalculate(currentT2G, currentAdjMatrix)
    global n alpha

    % Degree matrix D (n x n)
    D = diag(sum(currentAdjMatrix, 2));

    % Identity matrix I (n x n)
    I = eye(n);

    % Calculate the reputation vector R
    JR = (I - alpha * (D \ currentAdjMatrix)) \ ((1 - alpha) * currentT2G);
end