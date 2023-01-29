function hours = timestr2hour(tstr)

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
    % Date: 2013-08-19 16:27:18
    % Packaged: 2017-04-27 17:58:20
tstr = ifel(iscell(tstr),tstr,{tstr});
hours = zeros(size(tstr));
for i = 1:numel(tstr)
    curr_tstr = strsplit(tstr{i},':');
    h = cellfun(@str2num,curr_tstr,'UniformOutput',false);
    if all(cellfun(@isscalar,h))
        h = cell2mat(h);
        switch length(h)
            case 1
                units = 1/60/60;
            case 2
                units = [1/60 1/60/60];
            case 3
                units = [1 1/60 1/60/60];
            otherwise
                h = NaN;
        end
        h = sum(h .* units);
    else
        h = NaN;
    end
    hours(i) = h;
end