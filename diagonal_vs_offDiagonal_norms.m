% Benjamin Shih
% 6/11/12 SU2012
% Comparison of Diagonal and Off-Diagonal Norms

% Assumptions.
%%% Assumes that direct_sumN.m has just run, where N denotes the latest
%%% version of the direct sum MATLAB code. This code assumes that there are
%%% MAXCLUSTER^2 blocks, denoting each pair of cluster labels, saved in
%%% .mat files in the submatrix_i_j_of_big_submatrix.mat format. 

% Dependencies.
%%% n/a

% Constants.
MAXCLUSTER = 10;
NUMVERTEX = 10000;

% Compute the norm approximations, both with and without the diagonal. 
p1 = 0;
for i = 1:MAXCLUSTER
   load(['submatrix_',int2str(i),'_', int2str(i),'_of_big_matrix.mat']);
   B = vTimesMat;
   clear vTimesMat;
   p1 = p1 + norm(diag(B), 'fro')^2;
   i
end

nnzs = 0;
nnz10 = 0;
nnz7 = 0;
nnz5 = 0;
p2 = 0;
for i = 1:MAXCLUSTER
    for j = 1:MAXCLUSTER
        i
        j
        load(['submatrix_',int2str(i),'_', int2str(j),'_of_big_matrix.mat']);
        B = vTimesMat;
        clear vTimesMat;
        
        % Error bound checking comparing norm of the difference matrix.
        
        
        
        % Thresholding to check the sparsity 
        oneEMinus10 = im2bw(B, 1e-10);
        oneEMinus7 = im2bw(B, 1e-7);
        oneEMinus5 = im2bw(B, 1e-5);
        
        % Count the number of nonzero elements.
        nnzs = nnzs + nnz(B);
        nnz10 = nnz10 + nnz(oneEMinus10);
        nnz7 = nnz7 + nnz(oneEMinus7);
        nnz5 = nnz5 + nnz(oneEMinus5);
        
        % Calculate the Frobenius norm. If we are at an i,i block, remove
        % the diagonal so that we can compute the norm of the
        % off-diagonals.
        if i == j
            p2 = p2 + norm(B - diag(diag(B)), 'fro')^2;
        else
            p2 = p2 + norm(B, 'fro')^2;
        end
    end
end

p1
p2
% Percent of norm values that lies on the diagonal.
elementWeight = p1 / (p1 + p2)
% Percent of number of elements that are 0.
sparsity = 1 - nnzs / NUMVERTEX^2
sparsity10 = 1 - nnz10 / NUMVERTEX^2
sparsity7 = 1 - nnz7 / NUMVERTEX^2
sparsity5 = 1 - nnz5 / NUMVERTEX^2

% Play a pure tone sound to indicate completion.
cf = 2000;                  % carrier frequency (Hz)
sf = 22050;                 % sample frequency (Hz)
d = 1.0;                    % duration (s)
n = sf * d;                 % number of samples
s = (1:n) / sf;             % sound data preparation
s = sin(2 * pi * cf * s);   % sinusoidal modulation
sound(s, sf);               % sound presentation
pause(d + 0.5);             % waiting for sound end