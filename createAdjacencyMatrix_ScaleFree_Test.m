% Example Parameters
clear;
global n supplierRange manufacturerRange retailerRange;
n = 300; % Total nodes
numSuppliers = 100; % Suppliers
numManufacturers = 100; % Manufacturers
numRetailers = 100; % Retailers

supplierRange = 1:numSuppliers;
manufacturerRange = numSuppliers + (1:numManufacturers);
retailerRange = numSuppliers + numManufacturers + (1:numRetailers);

% Generate Adjacency Matrix
A = createAdjacencyMatrix_ScaleFree();

% Extract Degrees and Validate
supplierDegreesTest = sum(A(supplierRange, :), 2);
manufacturerDegreesTest = sum(A(manufacturerRange, :), 2);
retailerDegreesTest = sum(A(retailerRange, :), 2);

% Plot and Analyze
figure;
subplot(1, 3, 1);
histogram(supplierDegreesTest, 'Normalization', 'probability');
set(gca, 'YScale', 'log', 'XScale', 'log');
title('Suppliers Degree Distribution');
xlabel('Degree'); ylabel('Probability');

subplot(1, 3, 2);
histogram(manufacturerDegreesTest, 'Normalization', 'probability');
set(gca, 'YScale', 'log', 'XScale', 'log');
title('Manufacturers Degree Distribution');
xlabel('Degree'); ylabel('Probability');

subplot(1, 3, 3);
histogram(retailerDegreesTest, 'Normalization', 'probability');
set(gca, 'YScale', 'log', 'XScale', 'log');
title('Retailers Degree Distribution');
xlabel('Degree'); ylabel('Probability');
