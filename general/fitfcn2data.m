function [param_fit,ssd_fit] = fitfcn2data(x,y,fcn_handle,params,plot_flag)

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
    % Date: 2012-12-20 11:16:36
    % Packaged: 2017-04-27 17:58:09
if nargin < 5
    plot_flag = true;
end

ssd = @(p) sum((fcn_handle(x,p) - y).^2);
param_fit = fminsearch(ssd,params);

if plot_flag
    figure;
    plot(x,y,'+');
    hold on;
    dx = min(diff(x))/10;
    s = std(x)/10;
    fcnx = min(x)-s:dx:max(x)+s;
    plot(fcnx,fcn_handle(fcnx,param_fit),'r-');
end

ssd_fit = sum((fcn_handle(x,param_fit) - y).^2);