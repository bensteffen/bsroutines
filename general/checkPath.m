%Disclaimer of Warranty (from http://www.gnu.org/licenses/). 
%THERE IS NO WARRANTY FOR THE PROGRAM, TO THE EXTENT PERMITTED BY APPLICABLE LAW.
%EXCEPT WHEN OTHERWISE STATED IN WRITING THE COPYRIGHT HOLDERS AND/OR OTHER PARTIES 
%PROVIDE THE PROGRAM "AS IS" WITHOUT WARRANTY OF ANY KIND, EITHER EXPRESSED OR IMPLIED,
%INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR
%A PARTICULAR PURPOSE. THE ENTIRE RISK AS TO THE QUALITY AND PERFORMANCE OF THE PROGRAM
%IS WITH YOU. SHOULD THE PROGRAM PROVE DEFECTIVE, YOU ASSUME THE COST OF ALL NECESSARY
%SERVICING, REPAIR OR CORRECTION.

%Author: Florian Haeussinger (florian.haeussinger@med.uni-tuebingen.de)
%Date: 20-Jan-2012 19:37:15


function flag = checkPath(name, prefix, postfix, extension)

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
    % Date: 2012-01-20 19:37:15
    % Packaged: 2017-04-27 17:58:05
flag = 0;

[~, currName currExt] = fileparts(name);
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
        flag = 1;
    end
end