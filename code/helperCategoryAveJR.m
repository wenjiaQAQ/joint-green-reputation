function categoryAveJR = helperCategoryAveJR(nodeID, supplierAveJR, manufacturerAveJR, retailerAveJR)
    global supplierRange manufacturerRange 
    
    if ismember(nodeID, supplierRange)
        categoryAveJR = supplierAveJR;
    elseif ismember(i, manufacturerRange)
        categoryAveJR = manufacturerAveJR;
    else
        categoryAveJR = retailerAveJR;
    end
end