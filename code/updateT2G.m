function updateT2G()

    global strategyPlan;
    global dynamicT2GUpdate;
    global n;

    % Get the current T2G -> last column of dynamicT2GUpdate
    currentT2GValues = dynamicT2GUpdate(:, end);

    for i = 1:n
        if strcmp(strategyPlan{i}, '[3, NA]')
            currentT2GValues(i) = 1;
        end
    end

    % Add new column to update T2G
    dynamicT2GUpdate = [dynamicT2GUpdate, currentT2GValues];
end