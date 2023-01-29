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


 function [B,T,SE,rho] = rg_plichta(Y, X)
    % PURPOSE: Two-stage least square estimation procedure
    %--------------------------------------------------------------------------
    % USAGE: [B,R] = rg(Y,X)
    % where: Y = dependent variable of observations (m x 1)
    %        X = independent variable matrix (m x p)
    %--------------------------------------------------------------------------
    % RETURNS:
    %       B = inv(X'*X)*X'*Y  MSE of beta (p x 1 vector)
    %       T = t-stats
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
    % Date: 2017-04-11 15:30:54
    % Packaged: 2017-04-27 17:58:53

if any(isnan(Y)) || isconstant(Y)
    B = NaN(size(X,2)+1,1);
    return;
end

% Step 1:
%--------------------------------------------------------------------------
% Find the least squares estimation
%[B,R] = ols(Y,X);
[B,R] = ols(X,Y);
% Step 2:
%--------------------------------------------------------------------------
% Calculate rho from residuals
RLAG = lagmatrix(R,1);  % shift back in time by one, first obs is NaN
RLAG = RLAG(2:end,1);   % truncate
R    = R(2:end,1);      % truncate
rho  = ols(RLAG,R);
% Step 3:
%--------------------------------------------------------------------------
% Re-Estimation OLS
Y = Y - rho(2,1) * lagmatrix(Y,1) + rho(1,1);
X = X - rho(2,1) * lagmatrix(X,1) + rho(1,1);
Y = Y(2:end,1);     % truncate
X = X(2:end,:);     % truncate


%betahat and t-stats calculating
[nobs, nvar] = size(X);

%[B,R,xpxi] = ols(Y,X);
[B,R,xpxi] = ols(X,Y);

sigu = R'*R;
sige = sigu / (nobs-nvar);
tmp = sige * diag(xpxi);
SE=sqrt(tmp);
T = B ./ sqrt(tmp);

% Subfunction for OLS
%--------------------------------------------------------------------------
function [B,R,xpxi] = ols(X,Y)
X = [ones(size(X,1),1) X];
[q,r] = qr(X,0);    % OLS through QR-Decomposition
% rank(r)
B = r \ (q' * Y);   % Betahat
R = Y - X*B;        % Residuals
xpxi = (r'*r)\eye(size(X,2)); % eye(nvar)