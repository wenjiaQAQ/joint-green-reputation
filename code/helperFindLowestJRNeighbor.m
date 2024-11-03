%% This function is to find the neighbor who has the lowest JR of the focal
% Input:
% Output: id of the selected neighbor
function [idNeighbor, minNeighborJR] = helperFindLowestJRNeighbor(currentJRValues, neighbors)
    global threashold
    
    minNeighborJR = min(currentJRValues(neighbors));
    if abs(minNeighborJR - currentJRValues) > threashold
        minJRNodes = intersect(find(currentJRValues == minNeighborJR), neighbors);
        % If multiple, choose randomly
        idNeighbor = minJRNodes(randi(length(minJRNodes)));
    else
        idNeighbor = [];
    end
end