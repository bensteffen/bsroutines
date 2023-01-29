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


function [betas,R2] = getBetas(Y,X,varargin)

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
    % Date: 2017-04-11 15:52:51
    % Packaged: 2017-04-27 17:58:53
if size(Y,1) == size(X,1)
    channel_number = size(Y,2);
    regressor_number = size(X,2);
    [betas,R2] = deal(zeros(regressor_number + length(varargin) + 1,channel_number));
    
    X_chwise = cell(1,channel_number);
    for i = 1:length(varargin)
        for j = 1:channel_number
            X_chwise{j} = [X_chwise{j} varargin{i}(:,j)];
        end
    end
    
    zero_reg = [];
    for r = 1:regressor_number
        if ~any(X(:,r))
            zero_reg = [zero_reg r];
        end
    end
    
    if any(isnan(Y(:))) || any(isconstant(Y))
        ch_str = stringify(find(any(isnan(Y),1) | isconstant(Y)));
        NAlog.INIT;
        LOG.log('Bad data (NaNs and/or no variance) for subject $s and channel %s',ch_str);
    end
    
    for j = 1:channel_number
        if isempty(zero_reg)
            betas(:,j) = NAstat.rg_plichta(Y(:,j),[X X_chwise{j}]);
        else
            Xtmp = X;
            Xtmp(:,zero_reg) = [];
            
            beta_tmp = NAstat.rg_plichta(Y(:,j),[Xtmp X_chwise{j}]);

            non_zero_reg = 1:regressor_number;
            non_zero_reg(zero_reg) = [];
            
            non_zero_reg = non_zero_reg + 1;
            zero_reg = zero_reg + 1;
            
            betas(1,j) = beta_tmp(1);
            betas(non_zero_reg,j) = beta_tmp(2:end);
            betas(zero_reg) = 0;
            zero_reg = zero_reg - 1;
        end
        betas(:,j) = [betas(2:end,j); betas(1,j)];
        r = corr(Y(:,j),[X X_chwise{j}])';
        regn = size(betas,1);
        R2(1:regn-1,j) = betas(1:regn-1,j).*r ./ var(Y(:,j));
%         for c = 1:size(betas,1);
%             residues(c,j) = sum((Y(:,j) - X_total(:,c)*betas(c,j)).^2);
%             R2(c,j) = 1 - residues(c,j)./((n-1)*var(Y(:,j)));
%         end
    end
else
    ME = MException('NANA:function:badInput', 'Y and X must have the same number of rows');
    throw(ME);
end