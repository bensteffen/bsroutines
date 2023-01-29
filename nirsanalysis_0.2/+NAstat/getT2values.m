%Disclaimer of Warranty (from http://www.gnu.org/licenses/). 
%THERE IS NO WARRANTY FOR THE PROGRAM, TO THE EXTENT PERMITTED BY APPLICABLE LAW.
%EXCEPT WHEN OTHERWISE STATED IN WRITING THE COPYRIGHT HOLDERS AND/OR OTHER PARTIES 
%PROVIDE THE PROGRAM "AS IS" WITHOUT WARRANTY OF ANY KIND, EITHER EXPRESSED OR IMPLIED,
%INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR
%A PARTICULAR PURPOSE. THE ENTIRE RISK AS TO THE QUALITY AND PERFORMANCE OF THE PROGRAM
%IS WITH YOU. SHOULD THE PROGRAM PROVE DEFECTIVE, YOU ASSUME THE COST OF ALL NECESSARY
%SERVICING, REPAIR OR CORRECTION.

%Author: Florian Haeussinger (florian.haeussinger@med.uni-tuebingen.de)
%Date: 20-Jan-2012 19:40:16


function [tvals,pvals,effect_size] = getT2values(X,Y,eq_var_param)

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
    % Date: 2016-07-06 10:46:05
    % Packaged: 2017-04-27 17:58:53
if nargin < 3
    eq_var_param = 0.05;
end


if isnumeric(eq_var_param) && isscalar(eq_var_param) % Levene test
    levene_alpha = eq_var_param;
    ch_number = size(X,2);
    p_levene = zeros(1,ch_number);

    m = size(X,1);
    n = size(Y,1);

    for j = 1:ch_number
        p_levene(j) = NAstat.levenetest([X(:,j) ones(m,1); Y(:,j) 2*ones(n,1)]);
    end

    equal_var = p_levene >= levene_alpha;
    q_equal = sum(equal_var)/ch_number;
%     fprintf('Two-sample t-test ("%s")...\n\tLevene test results: %.0f %% of the channels has equal variances (levene_alpha = %.2f, equal/unequal threshold = 90 %%)',test_name,100*q_equal,levene_alpha);

    if q_equal >= 0.9
        var_type = 'equal';
    else
        var_type = 'unequal';
    end
%     fprintf('\n\t--> t-test for %s variances will be used.\n',var_type);
elseif ischar(eq_var_param)
    var_type = eq_var_param;
end

[~,pvals,~,stats] = ttest2(X,Y,[],[],var_type);
tvals = stats.tstat;


