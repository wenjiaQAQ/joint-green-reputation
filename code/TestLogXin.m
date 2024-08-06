%% This script is for testing

%% createAdjacencyMatrix.m
% check the degree range
A = createAdjacencyMatrix(n, supplierRange, manufacturerRange, retailerRange);
degree = sum(A,2);
degree(supplierRange)'              % present the degree of suppliers
degree(manufacturerRange)'           % present the degree of manufactures
degree(retailerRange)'              % present the degree of retailers

% check the connection
sum(degree(supplierRange))+sum(degree(retailerRange)) == sum(degree(manufacturerRange)) % should be true

