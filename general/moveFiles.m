%Disclaimer of Warranty (from http://www.gnu.org/licenses/). 
%THERE IS NO WARRANTY FOR THE PROGRAM, TO THE EXTENT PERMITTED BY APPLICABLE LAW.
%EXCEPT WHEN OTHERWISE STATED IN WRITING THE COPYRIGHT HOLDERS AND/OR OTHER PARTIES 
%PROVIDE THE PROGRAM "AS IS" WITHOUT WARRANTY OF ANY KIND, EITHER EXPRESSED OR IMPLIED,
%INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR
%A PARTICULAR PURPOSE. THE ENTIRE RISK AS TO THE QUALITY AND PERFORMANCE OF THE PROGRAM
%IS WITH YOU. SHOULD THE PROGRAM PROVE DEFECTIVE, YOU ASSUME THE COST OF ALL NECESSARY
%SERVICING, REPAIR OR CORRECTION.

%Author: Florian Haeussinger (florian.haeussinger@med.uni-tuebingen.de)
%Date: 20-Jan-2012 19:38:34


function moveFiles(fname_list, copy_flag, dest_dir)

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
    % Date: 2016-03-18 11:21:42
    % Packaged: 2017-04-27 17:58:13
makeDir(dest_dir);

if ischar(fname_list)
    fname_list = {fname_list};
end

% fprintf('Moving files... ');
% ps = ProgressStatus(length(fname_list));
for f = Iter(fname_list)
    [p,n,e] = fileparts(f);
    if ~isempty(p)
        if strstart(p,'.') || strstart(p,'..')
            [~,p] = fileparts(p);
        end
        makeDir(fullfile(dest_dir,p));
    end
    target_f = fullfile(dest_dir,p,[n e]);
    if strcmp('copy',copy_flag)
%         cmdstr = sprintf('xcopy %s %s',strreplace(f,'\','\\'),dest_dir);
        fprintf('copy "%s"\n  to "%s"\n',f,target_f);
%         copyfile(f,target_f);
    elseif strcmp('cut',copy_flag)
%         cmdstr = sprintf('move %s %s',strreplace(f,'\','\\'),dest_dir);
        movefile(f,target_f);
    else
        error('Copy flag must be "copy" or "cut"');
    end
%     system(cmdstr);
%     ps.update(i);
end
% ps.finish('Done!\n');