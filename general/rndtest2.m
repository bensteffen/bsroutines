function [h,pval,test_statistic] = rndtest2(X1,X2,alpha_level,perm_runs)

    %
    % Disclaimer of Warranty (from http://www.gnu.org/licenses/):
    %  THERE IS NO WARRANTY FOR THE PROGRAM, TO THE EXTENT PERMITTED BY APPLICABLE LAW.
    %  EXCEPT WHEN OTHERWISE STATED IN WRITING THE COPYRIGHT HOLDERS AND/OR OTHER PARTIES
    %  PROVIDE THE PROGRAM "AS IS" WITHOUT WARRANTY OF ANY KIND, EITHER EXPRESSED OR IMPLIED,
    %  INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR
    %  A PARTICULAR PURPOSE. THE ENTIRE RISK AS TO THE QUALITY AND PERFORMANCE OF THE PROGRAM
    %  IS WITH YOU. SHOULD THE PROGRAM PROVE DEFECTIVE, YOU ASSUME THE COST OF ALL NECESSARY
    %  SERVICING, REPAIR OR CORRECTION.
    %  
    % Author: Florian Haeussinger (florian.haeussinger@med.uni-tuebingen.de)
    % Date: 2013-07-10 11:13:40
    % Packaged: 2017-04-27 17:58:17
X1 = X1(:);
X2 = X2(:);
X = [X1; X2];

n1 = numel(X1);
n2 = numel(X2);
n = n1 + n2;

if nargin < 3
    alpha_level = 0.05;
end
if nargin < 4
    perm_runs = 100*n;
end

origin_mean_diff = abs(mean(X2) - mean(X1));
mean_diff = zeros(perm_runs,1);

for p = 1:perm_runs
    group_perm = randperm(n);
    perm_group1 = group_perm(1:n1);
    perm_group2 = group_perm(n1+1:n1+n2);
    mean_diff(p) = mean(X(perm_group2)) - mean(X(perm_group1));
end

hist(mean_diff,-400:10:400); hold on; ylim = get(gca,'YLim');
lh = line([origin_mean_diff origin_mean_diff],[0 ylim(2)]);
set(lh,'LineWidth',2,'Color','r')

pval = sum(abs(mean_diff) > origin_mean_diff)/perm_runs;
h = pval < alpha_level;
test_statistic = (origin_mean_diff - mean(mean_diff))/std(mean_diff);