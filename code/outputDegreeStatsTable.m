function outputDegreeStatsTable()
    global adjMatrix;
    global dynamicJRUpdate;

    % 获取初始和最终时间步的邻接矩阵
    initialAdjMatrix = adjMatrix(:, :, 1);
    finalAdjMatrix = adjMatrix(:, :, end);

    % 计算初始和最终时间步的度数
    initialDegrees = sum(initialAdjMatrix, 2);
    finalDegrees = sum(finalAdjMatrix, 2);

    % 计算初始和最终时间步的平均度数和方差度数
    initialAvgDegree = mean(initialDegrees);
    initialVarDegree = var(initialDegrees);
    finalAvgDegree = mean(finalDegrees);
    finalVarDegree = var(finalDegrees);

    % 获取初始和最终时间步的 JR 值
    initialJRValues = dynamicJRUpdate(:, 1);
    finalJRValues = dynamicJRUpdate(:, end);

    % 计算初始和最终时间步的平均 JR 和方差 JR
    initialAvgJR = mean(initialJRValues);
    initialVarJR = var(initialJRValues);
    finalAvgJR = mean(finalJRValues);
    finalVarJR = var(finalJRValues);

    % 创建数据表
    data = {
        'Variable', 't_0', 'T';
        'Average Degree', initialAvgDegree, finalAvgDegree;
        'Variance Degree', initialVarDegree, finalVarDegree;
        'Average JR', initialAvgJR, finalAvgJR;
        'Variance JR', initialVarJR, finalVarJR
    };

    % 创建图形窗口并设置大小
    figure('Position', [100, 100, 500, 200], 'Color', 'w');

    % 创建表格
    uit = uitable('Data', data(2:end, :), ...
                  'ColumnName', data(1, :), ...
                  'ColumnWidth', {150, 150, 150}, ...
                  'RowName', [], ...
                  'Position', [20, 20, 660, 150]);

    % 保存图形为图片
    saveas(gcf, 'DegreeAndJRStatsTable.png');
end
