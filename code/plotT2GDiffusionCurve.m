function plotT2GDiffusionCurve(t)

    global dynamicT2GUpdate;
    global n;
    global supplierRange;
    global manufacturerRange;
    global retailerRange;

    % Pre-allocate an array to store the percentage of T2G=1 at each time step
    allGreenPercentage = zeros(t+1, 1);
    supplierGreenPercentage = zeros(t+1, 1);
    manufacturerGreenPercentage = zeros(t+1, 1);
    retailerGreenPercentage = zeros(t+1, 1);

    % Calculate the percentage of T2G=1 at the current time step
    for step = 1:t+1
        % All nodes
        allGreenPercentage(step) = sum(dynamicT2GUpdate(:, step) == 1) / n * 100;
        % Suppliers
        supplierGreenPercentage(step) = sum(dynamicT2GUpdate(supplierRange, step) == 1) / length(supplierRange) * 100;
        % Manufacturers
        manufacturerGreenPercentage(step) = sum(dynamicT2GUpdate(manufacturerRange, step) == 1) / length(manufacturerRange) * 100;
        % Retailers
        retailerGreenPercentage(step) = sum(dynamicT2GUpdate(retailerRange, step) == 1) / length(retailerRange) * 100;
    end

    % Plot the T2G diffusion curve
    figure;
    hold on;
    plot(0:t, allGreenPercentage, '-o', 'DisplayName', 'All Nodes');
    plot(0:t, supplierGreenPercentage, '-x', 'DisplayName', 'Suppliers');
    plot(0:t, manufacturerGreenPercentage, '-s', 'DisplayName', 'Manufacturers');
    plot(0:t, retailerGreenPercentage, '-d', 'DisplayName', 'Retailers');
    xlabel('Time Step');
    ylabel('Percentage of T2G=1');
    title('S-shaped Diffusion Curve of T2G Transition');
    legend show;
    grid on;
    hold off;
end

