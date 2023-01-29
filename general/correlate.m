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


function [rho p] = correlate(X,Y,trigger_X,fsX,fsY,type)

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
    % Date: 2012-07-10 15:35:51
    % Packaged: 2017-04-27 17:58:05
if nargin < 6
    type = 'pearson';
end

if ischar(type) && ~(strcmp(type,'pearson') || strcmp(type,'spearman'))
    ME = MException('TOOLSGENERAL:function:badInput', 'Type must be a string (''pearson'' or ''spearman'')!');
    throw(ME);
end

if size(X,2) ~= size(Y,2)
    ME = MException('TOOLSGENERAL:function:badInput', 'X and Y must have the same number of columns!');
    throw(ME);
end

I = find(trigger_X);
tX = ((-I(1):size(X,1)-I(1)-1)/fsX)';

t_start = tX(I(1));
t_end = tX(I(end));

tX_cut = tX > t_start & tX <= t_end;
tX = tX(tX_cut);
X = X(tX_cut,:);

i_start = round(fsY*(I(1) - 1)/fsX) + 1;
tY = ((-i_start:size(Y,1)-i_start-1)/fsY)';

tY_cut = tY > t_start & tY <= t_end;
tY = tY(tY_cut);
Y = Y(tY_cut,:);

TX = tX(end);
TY = tY(end);

if TY < TX
    X = X(tX <= TY,:);
elseif TX < TY
    Y = Y(tY <= TX,:);
end

NX = size(X,1);
NY = size(Y,1);

if NX > NY
    X = ndownsample(X,NY);
elseif NY > NX
    Y = ndownsample(Y,NX);
end

rho = zeros(1,size(X,2));
p = zeros(1,size(X,2));
for j = 1:length(rho)
    [rho(j) p(j)] = corr(X(:,j),Y(:,j),'type',type);
end
