close all; clc; tic

% This script will perform the likelihood ratio test for changes in 
% homeolog expression bias reported in our paper, "A likelihood ratio test
% for changes in homeolog expression bias", Smith et al, 2017.
%
% In addition to this script, contained in this directory should be:
%
%   1) LRT_NB_HEBS_v8.m: The function that performs the LRT for
%                        changes in HEB
%
%   2) LRT_NH_HEB_v8.m:  The function that performs the LRT for HEB
%
%   3) get_alf.m:        A function for converting the LRT test statistic
%                        to a significance level 
%
%   4) get_W.m:          A function for converting a significance level to
%                        to a test statistic
%
%   5) get_R.m:          A function for determining aggregation parameters
%                        as described in our paper
%
%   6) FitVarByMean.m:   A function used by get_R.m for the curve fitting
%                        procedure
%  
%   7) proc_ShowResults_HEBS.m: A script to plot the results.
%
%   8) W_Mimulus_LeafPetal_3895.mat: The data that was used in the test.
%
%   9) fdr_bh.m:        A function to perform the Benjamini-Hochberg
%                       correction.  
%                       Source: https://www.mathworks.com/matlabcentral/fileexchange/27418-fdr-bh
%                       date: April 6 2017
%
%
%
% Author: 
%   Ronald D. Smith
%   Graduate Student, Applied Science
%   The College of William & Mary
%   rdsmith@email.wm.edu
%   April 6, 2017

%% Load data
% This data contains the count of mapped reads for 5 replicates from the 
% leaf and flower of Mimulus luteus, as well as the total exon length of 
% each gene, and mean RPKM values.  
% 
% The table F contains the flower data; the table L contains the leaf data.  
% These tables are required to compute the total sequencing depths, and to 
% determine the aggregation parameters.
% 
% The tables F_Pars and L_Pars have been filtered to homeologous gene 
% pairs, and they are sorted in the same order. HEB was computed ahead of
% time and is the last column on each table. These tables contain the
% homeolgous pairs that will be tested.
load('T3_heb.mat')

%% Set desired significance level
sig=0.05;

%% Get r's and sequencing depths
[rF, dF] = get_R(T3{:,2:4},1);


%% Initialize output
N = height(T3_heb);
L1 = nan(N,1);
L0 = nan(N,1);

% Commence testing.  Show a waitbar so we know the computer didn't freeze.
h = waitbar(0, 'Doing LRT...');
for idx=1:N
    % Update the waitbar
    waitbar(idx/N, h)
    
    % Get the data for the current homeolog pair from the data tables
    %
    % condition 1 = T1, condition 2 = T2.  
    % a = M. Gutttaus-like homeolog, b = other homeolog
    
    a = T3_heb.SptReads(idx, :);
    b = T3_heb.SpcReads(idx, :);
    
    
    % Get the total exon length of each gene, in kilobases
    Ka = T3_heb.SptLength(idx)/1e3;
    Kb = T3_heb.SpcLength(idx)/1e3;
    
    if any(a) && any(b)
        [L1(idx), L0(idx)] = ...
            LRT_NB_HEB_v8(a, b, Ka, Kb, rF, rF, dF);
    end
end

close(h)

%% Compute the test statistics
% Results are in the same order as the input data
W = 2*(L1-L0);
HEB = T3_heb.HEB;

%% Make the Benjamini-Hochberg correction for multiple testing
% Exclude un-testable pairs
idx = isfinite(W);
% Convert W's to p-values
p = get_alf(W(idx),1);
% W values greater than Wadj should ensure FDR < [sig]
[~, pcrit]=fdr_bh(p, sig);
Wadj = get_W(pcrit,1);

%% Make the results table 
% Will be sorted in the same order as original input tables
HEB_Results = table;
HEB_Results.L0 = L0;
HEB_Results.L1 = L1;
HEB_Results.W = W;
HEB_Results.HEB = HEB;

% Show histogram and scatter plot of results
proc_ShowResults_HEB

% Print total runtime
toc

% Clean up
%clearvars a b D_F D_L h HEB idx Ka Kb L0 L1 N p pcrit rF sig
%% 
