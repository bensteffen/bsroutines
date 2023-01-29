function rmfromstruct(s)

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
    % Date: 2016-02-18 14:17:19
    % Packaged: 2017-04-27 17:58:17
if ischar(names)
    names = {names};
end
names = strsplit(names,'.');

snames = {};
for n = 1:length(names)
    for sn = 1:length(names{n})
        sub_name = names{n}{sn};
        if isvarname(sub_name)
            snames = [snames sub_name];
        else
            error('asgnstruct: All field names must be valid variable names (''%s'' <- invalid).',sub_name);
        end
    end
end

eval(sprintf('strc.(''%s'') = value;',cell2str(snames,''').(''')));