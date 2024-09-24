function updateT2G()

    global strategyPlan dynamicT2GUpdate

    % Get the current T2G -> last column of dynamicT2GUpdate
    currentT2GValues = dynamicT2GUpdate(:, end);

    transferNodes = intersect(find(strategyPlan(:,1) == 3), find(isnan(strategyPlan(:,2))));
    if ~isempty(transferNodes)
        currentT2GValues(transferNodes) = 1;
    end
    
    % Add new column to update T2G
    dynamicT2GUpdate = [dynamicT2GUpdate, currentT2GValues];
end