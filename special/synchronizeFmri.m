function [epi trigger_epi] = synchronizeFmri(epi,nirs_trigger,fs_nirs,fs_epi)

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
    % Date: 2012-07-09 13:54:56
    % Packaged: 2017-04-27 17:58:38
I = find(nirs_trigger);
Iepi = round(fs_epi*(I - 1)/fs_nirs) + 1;

epi = [repmat(epi(Iepi(1),:), [Iepi(1)+1 1]); epi];

trigger_epi = zeros(size(epi,1),1);
trigger_epi(Iepi) = nirs_trigger(I);