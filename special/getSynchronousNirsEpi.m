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


function [nirsData epiData] = getSynchronousNirsEpi(vp,exp_name,nirs_type)

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
    % Date: 2012-06-05 13:16:45
    % Packaged: 2017-04-27 17:58:36
nirsData = loadNirsTimeSeries(vp, exp_name, nirs_type);
trigger = loadNirsTimeSeries(vp, exp_name, 'trigger');
epiData = loadEpiTimeSeries(vp, exp_name);

I = find(trigger);
nirsData(1:I(1)-1,:) = [];

nirsFs = 10;
epiFs = 0.5;

nirsT = size(nirsData,1)/nirsFs;
epiT = size(epiData,1)/epiFs;

if nirsT > epiT
    nirsData = nirsData(1:floor(epiT*nirsFs),:);
elseif epiT > nirsT
    epiData = epiData(1:floor(nirsT*epiFs),:);
end

nirsData = nirsDownSample(nirsData,size(epiData,1));