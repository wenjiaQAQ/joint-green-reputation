function plotAdjMatrixStructure()
    global adjMatrix;
    global dynamicT2GUpdate;
    global n;
    global supplierRange;
    global manufacturerRange;
    global retailerRange;

    % Get the adjacency matrix for the first and last time steps
    initialAdjMatrix = adjMatrix(:, :, 1);
    finalAdjMatrix = adjMatrix(:, :, end);

    % Get the T2G values for the first and last time step
    initialT2G = dynamicT2GUpdate(:, 1);
    finalT2G = dynamicT2GUpdate(:, end);

    % Generate Node position
    theta = linspace(0, 2*pi, n+1)';
    x = cos(theta(1:end-1));
    y = sin(theta(1:end-1));
    positions = [x, y];

    % Create a graphics window and set the size
    figure('Position', [100, 100, 1200, 600]);
    nodeSize = 300;

    % Draw the initial adjacency matrix structure diagram
    subplot('Position', [0.05, 0.1, 0.4, 0.8]);
    hold on;
    % Draw connecting line
    gplot(initialAdjMatrix, positions, '-k'); 
    % Draw supplier node
    % Green circle
    h1 = scatter(x(supplierRange(initialT2G(supplierRange) == 1)), y(supplierRange(initialT2G(supplierRange) == 1)), nodeSize, 'g', 'o', 'filled');
    % Red circle
    h2 = scatter(x(supplierRange(initialT2G(supplierRange) == 0)), y(supplierRange(initialT2G(supplierRange) == 0)), nodeSize, 'r', 'o', 'filled');
    % Draw manufacturer node
    % Green triangle
    h3 = scatter(x(manufacturerRange(initialT2G(manufacturerRange) == 1)), y(manufacturerRange(initialT2G(manufacturerRange) == 1)), nodeSize, 'g', '^', 'filled'); 
    % Red triangle
    h4 = scatter(x(manufacturerRange(initialT2G(manufacturerRange) == 0)), y(manufacturerRange(initialT2G(manufacturerRange) == 0)), nodeSize, 'r', '^', 'filled'); 
    % Draw retailer node
    % Green square
    h5 = scatter(x(retailerRange(initialT2G(retailerRange) == 1)), y(retailerRange(initialT2G(retailerRange) == 1)), nodeSize, 'g', 's', 'filled'); 
    % Red square
    h6 = scatter(x(retailerRange(initialT2G(retailerRange) == 0)), y(retailerRange(initialT2G(retailerRange) == 0)), nodeSize, 'r', 's', 'filled'); 
    title('Initial Adjacency Matrix');
    axis equal;
    % Remove the scale of the axes
    set(gca, 'XTick', [], 'YTick', []); 
    for i = 1:n
        text(x(i), y(i), num2str(i), 'HorizontalAlignment', 'center', 'VerticalAlignment', 'middle', 'FontSize', 12, 'FontWeight', 'bold');
    end
    xlim([-1.5 1.5]);
    ylim([-1.5 1.5]);
    legend([h1, h2, h3, h4, h5, h6], {'Supplier T2G=1', 'Supplier T2G=0', 'Manufacturer T2G=1', 'Manufacturer T2G=0', 'Retailer T2G=1', 'Retailer T2G=0'}, 'Location', 'bestoutside');
    hold off;

    % Draw the adjacency matrix structure for the last time step
    subplot('Position', [0.55, 0.1, 0.4, 0.8]);
    hold on;
    % Draw connecting line
    gplot(finalAdjMatrix, positions, '-k');
    % Draw supplier node
    h1 = scatter(x(supplierRange(finalT2G(supplierRange) == 1)), y(supplierRange(finalT2G(supplierRange) == 1)), nodeSize, 'g', 'o', 'filled'); 
    h2 = scatter(x(supplierRange(finalT2G(supplierRange) == 0)), y(supplierRange(finalT2G(supplierRange) == 0)), nodeSize, 'r', 'o', 'filled'); 
    % Draw manufacturer node
    h3 = scatter(x(manufacturerRange(finalT2G(manufacturerRange) == 1)), y(manufacturerRange(finalT2G(manufacturerRange) == 1)), nodeSize, 'g', '^', 'filled'); 
    h4 = scatter(x(manufacturerRange(finalT2G(manufacturerRange) == 0)), y(manufacturerRange(finalT2G(manufacturerRange) == 0)), nodeSize, 'r', '^', 'filled'); 
    % Draw retailer node
    h5 = scatter(x(retailerRange(finalT2G(retailerRange) == 1)), y(retailerRange(finalT2G(retailerRange) == 1)), nodeSize, 'g', 's', 'filled'); 
    h6 = scatter(x(retailerRange(finalT2G(retailerRange) == 0)), y(retailerRange(finalT2G(retailerRange) == 0)), nodeSize, 'r', 's', 'filled');
    title(['Final Adjacency Matrix at Time Step ', num2str(size(dynamicT2GUpdate, 2) - 2)]);
    axis equal;
    set(gca, 'XTick', [], 'YTick', []); 
    for i = 1:n
        text(x(i), y(i), num2str(i), 'HorizontalAlignment', 'center', 'VerticalAlignment', 'middle', 'FontSize', 12, 'FontWeight', 'bold');
    end
    xlim([-1.5 1.5]);
    ylim([-1.5 1.5]);
    legend([h1, h2, h3, h4, h5, h6], {'Supplier T2G=1', 'Supplier T2G=0', 'Manufacturer T2G=1', 'Manufacturer T2G=0', 'Retailer T2G=1', 'Retailer T2G=0'}, 'Location', 'bestoutside');
    hold off;
end
