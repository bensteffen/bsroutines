function fitted_parameters = fitcurve2data(X,Y,curve_handle,start_parameters,plot_flag)


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
    % Date: 2015-06-01 12:07:59
    % Packaged: 2017-04-27 17:58:09
Inan = isnan(Y);
Y(Inan) = [];
X(Inan) = [];

inargn = length(start_parameters);
inarg_cell = cell(1,inargn);
for i = 1:inargn
    inarg_cell{i} = sprintf('p(%d)',i);
end
eval(sprintf('sserr = @(%s) sum((curve_handle(X,%s) - Y).^2);','p',cell2str(inarg_cell,',')));
fitted_parameters = fminsearch(sserr,start_parameters);

if plot_flag
    for i = 1:inargn
        inarg_cell{i} = sprintf('fitted_parameters(%d)',i);
    end
    dX = X(end) - X(1);
    dx = dX/length(X);
    x = X(1)-dX/20:dx/100:X(end)+dX/20;
    eval(sprintf('y = curve_handle(x,%s);',cell2str(inarg_cell,',')));
    plot(X,Y,'r.',x,y,'k');
end
