function [ degreeVector ] = generateDegreeMatrixAsVector(numVertex, numCluster)
    degreeVector = zeros(1, numVertex);

    % Iterate by column.
    for i = 1:numCluster
        % Assumes fixed clusters sizes of 1000 each, which may NOT always be
 
        diag = zeros(1, 1000); 
        
        % Iterate by row.
        for j = 1:numCluster 
            % Imports the current block into the workspace. Matrix is
            % called vTimesMat.
            load(['submatrix_',int2str(i),'_', int2str(j),'_of_big_matrix.mat']);
            block = vTimesMat;
            clear vTimesMat;
            
            % Accumulator for matrix sums, computed by column.
            diag = diag + sum(block);
        end
        degreeVector(((i-1)*1000 + 1):(i*1000)) = diag;
    end
end