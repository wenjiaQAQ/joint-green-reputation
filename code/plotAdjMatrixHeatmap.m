function plotAdjMatrixHeatmap(t)
    global adjMatrix;
    global n;

    % Get initialAdjMatrix and finalAdjMatrix
    initialAdjMatrix = adjMatrix(:, :, 1);
    finalAdjMatrix = adjMatrix(:, :, end);

    % Plot heatmap of initialAdjMatrix
    figure;
    subplot(1, 2, 1);
    heatmap(initialAdjMatrix);
    xlabel('Node');
    ylabel('Node');
    title('Adjacency Matrix at Time Step 0');
    colorbar;

    % Plot heatmap of finalAdjMatrix
    subplot(1, 2, 2);
    heatmap(finalAdjMatrix);
    xlabel('Node');
    ylabel('Node');
    title(['Adjacency Matrix at Time Step ', num2str(t)]);
    colorbar;
end
