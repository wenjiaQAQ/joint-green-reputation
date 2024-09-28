%% Create a table | type | #upperStreamNei | #lowerStreamNei | <=2 neighbor | <2 neighbor |
function table = helperCurrentNumNeighborTable(currentAdjMatrix)
    global n supplierRange manufacturerRange retailerRange;
    
    table = zeros(n, 5);
    for i = 1:n
        
        allNodes = 1:1:n;
        isSupplier = ismember(i, supplierRange);
        isManufacture = ismember(i, manufacturerRange);
        isRetailer = ismember(i, retailerRange);
        
        neighbors = allNodes(currentAdjMatrix(i,:) == 1);
        
        if isSupplier
            table(i, 1) = 1;
            table(i, 2) = -1; % no upperNeighbors
            table(i, 3) = length(neighbors); % #lowerNeighbors
            % Cannot cut neighbors when JR is lower than peerAve, has to
            % transform
            table(i, 4) = table(i, 3) <= 2;
            % Need to create more connection (if transformed), or transform
            table(i, 5) = table(i, 3) < 2;
        end
        
        if isManufacture
            table(i, 1) = 2;
            table(i, 2) = length(neighbors(neighbors < manufacturerRange(1))); % #upperNeighbors
            table(i, 3) = length(neighbors(neighbors > manufacturerRange(end))); % #lowerNeighbors
            table(i, 4) = table(i, 2) <= 2 || table(i, 3) <= 2;
            table(i, 5) = table(i, 2) < 2 || table(i, 3) < 2;
        end
        
        if isRetailer
            table(i, 1) = 3;
            table(i, 2) = length(neighbors); % #upperNeighbors
            table(i, 3) = -1; % no lowerNeighbors
            table(i, 4) = table(i, 2) <= 2;
            table(i, 5) = table(i, 2) < 2;
        end
    end
end