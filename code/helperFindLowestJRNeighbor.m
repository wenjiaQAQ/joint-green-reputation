%% This function is to find the neighbor who has the lowest JR of the focal
% Input:
% Output: id of the selected neighbor
function [idNeighbor, minNeighborJR] = helperFindLowestJRNeighbor(currentJRValues, neighbors)
    minNeighborJR = min(currentJRValues(neighbors));
    minJRNodes = intersect(find(currentJRValues == minNeighborJR), neighbors);
    % If multiple, choose randomly
    idNeighbor = minJRNodes(randi(length(minJRNodes)));
end