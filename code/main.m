% main function: this is the only function that we need to run
% main function call JGRRun(N, T, Alpha, k, numIter)
function main
    % Pilot experiments setting
    n = 20;
    alpha = [0.25, 0.5, 0.75];
    K = [0.25, 0.5, 0.75];
    T = 30;
    numIter = 10;
    thre = 0.05;
    maxNei = 5;
    
    for i = 1:3
        namePara = helperNameGenerator(n, alpha(i), K(i));
        JGRRun(n, T, alpha(i), K(i), numIter, namePara, thre, maxNei);
    end
    
end

% 
% %% Basic elements & init
% %% This function run the model numIterations times, and each time is terminated at t
% % The input of this function include: N, T, Alpha, k, numIter
% % Output of this function contains two xlsx files: T2GHistory, dynamicJRUpdate, adjMatrix
% function JGRRun(N, T, Alpha, k, numIter)