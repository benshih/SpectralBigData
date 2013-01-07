function [] = generateLaplacian(numCluster, degreeVector)
% No function output. The Laplacian is saved directly to memory because the
% file is too big.

    for i = 1:numCluster
        for j = 1:numCluster
            i
            j
            % Imports the current block into the workspace. Matrix is
            % called vTimesMat.
            load(['submatrix_', int2str(i), '_', int2str(j), '_of_big_matrix.mat']);
            block = vTimesMat;
            clear vTimesMat;
            
            % In the process of computing the Laplacian.
            negBlock = -1 * block;
            
            % Initialize L to negBlock because if the block (A) isn't part of a
            % diagonal, the Laplacian entry, L = D-A -> L = 0-A -> L = -A.
            L = negBlock;
            
            % Diagonal blocks require special adjustment for Laplacian.
            if i == j
                diagMat = diag(degreeVector((i-1)*1000+1:i*1000));
                L  = diagMat + L;
            end
            
            % Save Laplacian block.
            save(['laplacian_submatrix_', int2str(i),'_', int2str(j)]);
        end
    end
end