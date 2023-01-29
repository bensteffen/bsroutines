function pl = mcsPathlength(tracespath)

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
    % Date: 2014-02-24 15:15:12
    % Packaged: 2017-04-27 17:58:37
trace_name = dircontent(tracespath,'trace*.dat','files');

pl.gray = 0;
pl.skin = 0;

fprintf('Extracting pathlengths... ')
n = length(trace_name);
ps = ProgressStatus(n,'%d%%%%');
[pl.skin.single,pl.gray.single] = deal(zeros(n,1));
for t = 1:n
    trace = readTrace(fullfile(tracespath,trace_name{t}),7,'new');
    pl.skin.single(t) = sum(voxelnorm(diff(trace(trace(:,4) == 1,1:3))));
    pl.gray.single(t) = sum(voxelnorm(diff(trace(trace(:,4) == 4,1:3))));
    ps.update(t);
end
pl.skin.mean = mean(pl.skin.single(t));
pl.gray.mean = mean(pl.gray.single(t));
pl.total.single = pl.skin.single + pl.gray.single;
pl.total.mean = mean(pl.total.single);
ps.finish('Done!\n')