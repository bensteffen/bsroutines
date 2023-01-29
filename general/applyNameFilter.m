%Disclaimer of Warranty (from http://www.gnu.org/licenses/). 
%THERE IS NO WARRANTY FOR THE PROGRAM, TO THE EXTENT PERMITTED BY APPLICABLE LAW.
%EXCEPT WHEN OTHERWISE STATED IN WRITING THE COPYRIGHT HOLDERS AND/OR OTHER PARTIES 
%PROVIDE THE PROGRAM "AS IS" WITHOUT WARRANTY OF ANY KIND, EITHER EXPRESSED OR IMPLIED,
%INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR
%A PARTICULAR PURPOSE. THE ENTIRE RISK AS TO THE QUALITY AND PERFORMANCE OF THE PROGRAM
%IS WITH YOU. SHOULD THE PROGRAM PROVE DEFECTIVE, YOU ASSUME THE COST OF ALL NECESSARY
%SERVICING, REPAIR OR CORRECTION.

%Author: Florian Haeussinger (florian.haeussinger@med.uni-tuebingen.de)
%Date: 01-Jun-2012 16:58:44


function name_list = applyNameFilter(name_list,prefix,postfix,extension)

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
    % Date: 2012-06-01 16:58:44
    % Packaged: 2017-04-27 17:58:04
if ischar(name_list)
    name_list = {name_list};
end

if iscellstr(name_list)
    flag = false(size(name_list));
    
    for i = 1:numel(name_list)
        [~, currName currExt] = fileparts(name_list{i});
        l = length(currName);
        if l >= length(prefix)
            if strcmp(extension,'')
                extFlag = 1;
            else
                extFlag = strcmp(currExt, extension);
            end

            if strcmp(prefix,'')
                preFlag = 1;
            else
                lPre = length(prefix);
                if lPre <= l
                    preFlag = strcmp(currName(1:lPre),prefix);
                else
                    preFlag = 0;
                end
            end

            if strcmp(postfix,'')
                postFlag = 1;
            else
                lPost = length(postfix);
                if lPost <= l
                    postFlag = strcmp(currName(l - lPost + 1:l),postfix);
                else
                    postFlag = 0;
                end
            end


            if preFlag && postFlag && extFlag
                flag(i) = true;
            end
        end
    end
    name_list = name_list(flag);
else
    error('applyNameFilter: First input must be a string or a list of strings.');
end