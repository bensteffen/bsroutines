function renameFiles(fnames0,fnames1)

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
    % Date: 2015-03-31 16:06:14
    % Packaged: 2017-04-27 17:58:16
fnames0 = ifel(iscell(fnames0),fnames0,{fnames0});
fnames1 = ifel(iscell(fnames1),fnames1,{fnames1});

fprintf('Renaming files... ');
ps = ProgressStatus(numel(fnames0));
for i = 1:numel(fnames0)
    java.io.File(fnames0{i}).renameTo(java.io.File(fnames1{i}));
    ps.update(i);
end
ps.finish('Done!\n');

