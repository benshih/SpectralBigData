% Benjamin Shih
% 5/17/12 SU2012
% Direct Sum Attempt #4

% Assumptions.
%%% The cluster labels (and consequently, the vertices) are sorted. We can
%%% easily check this using plot(clusters) and looking for a monotonically
%%% increasing step function.

% Dependencies.
%%% findRange.m

% Clear workspace.
clc
clear all
close all

% Constants.
MAXCLUSTER = 10;
NUMVERTEX = 10000;

% Load mat file. 
load('Graph2.mat');

% Rename variables.
sparseMat = A;
clusters = labels;
clear labels;
clear A;
 
% Iterate through each of the cluster labels.
for j = 1:MAXCLUSTER
    % Find the vertices that correspond to a cluster label and extract the
    % adjacency matrix of the subgraph. 
    [firstj, lastj] = findRange(j, clusters);
    subMatj = sparseMat(firstj:lastj, firstj:lastj);
    
    % Extract the eigenvalues(D) and eigenvectors(V) of the subgraph.
    [Vj, Dj] = eig(full(subMatj));
    
    % Generate the A*V matrix by column. We will iterate by cluster down
    % this column.
    matTimesVj = sparseMat(:, firstj:lastj) * Vj;
    
    % Occasionally print out the cluster index to show that the code is
    % still running. 
    j
    for i = 1:MAXCLUSTER
        % Find the vertices that correspond to a cluster label and extract the
        % adjacency matrix of the subgraph. 
        % NOTE: Could optimize this part by saving the Vi matrices ahead of
        % time. This optimization is for the vT matrix only. 
        [firsti, lasti] = findRange(i, clusters);
        subMati = sparseMat(firsti:lasti, firsti:lasti);

        % Extract the eigenvalues(D) and eigenvectors(V) of the subgraph.
        % Allows us to obtain the transpose of V.
        [Vi, Di] = eig(full(subMati));
        
        % Equations have been pre-computed for A_symm*v_i by breaking down the
        % direct sum matrix into separate v_i matrices, then distributing the
        % multiplication of the A matrix, and lasty concatenating all i of the v_i
        % matrices together in sequential order (left to right).
        vTimesMat = Vi' * matTimesVj(firsti:lasti, :);
        
        % Save block. There are a total of MAXCLUSTER * MAXCLUSTER blocks. 
        save(['submatrix_',int2str(i),'_', int2str(j),'_of_big_matrix.mat'], 'vTimesMat');
    end
end

% Play a pure tone sound to indicate completion.
cf = 2000;                  % carrier frequency (Hz)
sf = 22050;                 % sample frequency (Hz)
d = 1.0;                    % duration (s)
n = sf * d;                 % number of samples
s = (1:n) / sf;             % sound data preparation
s = sin(2 * pi * cf * s);   % sinusoidal modulation
sound(s, sf);               % sound presentation
pause(d + 0.5);             % waiting for sound end