function tab = createStatTable(stat_data,varargin)

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
    % Date: 2016-03-30 15:53:20
    % Packaged: 2017-04-27 17:58:07
param_defaults.stat_precision = 2;
param_defaults.p_levels = [0.05 0.01 0.001];
[prop_names,prop_values] = parsePropertyCell(varargin);
assignPropertyValues(prop_names,prop_values,param_defaults);

pbins = [[p_levels(:);0] [1;p_levels(:)]];
nstarlets = @(n) repmat('*',[1 n]);
fstr = sprintf('%%.%df%%s',stat_precision);

tab = cell(size(stat_data,1),1);
for i = 1:size(stat_data,1)
    [v,p] = deal(stat_data(i,1),stat_data(i,2));
    plev = binfind(p,pbins)-1;
    if plev == 0
        pstr = sprintf('p = %.2f',p);
    else
        plev_val = p_levels(plev);
        [~,ndig] = countdigits(plev_val);
        s = sprintf(['%.' num2str(ndig+1) 'f'],plev_val);
        s = s(1:end-1);
        pstr = ['p < ' s];
    end
    tab{i} = [sprintf(fstr,v,nstarlets(plev)) ', ' pstr];
end