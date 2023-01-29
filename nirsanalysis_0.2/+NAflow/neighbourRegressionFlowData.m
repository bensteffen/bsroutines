function [Yflow,flow_data] = neighbourRegressionFlowData(Y,chs,probeset,flow_velocities,fs)

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
    % Date: 2014-07-04 16:35:24
    % Packaged: 2017-04-27 17:58:49
chn = size(Y,2);
flow_data = zeros(chn,16);
flow_velocities = flow_velocities(:)';
vn = length(flow_velocities);

[Yflow1,Yflow2] = deal(zeros(size(Y)));
for ch0 = chs(:)'
    [Yflow1(:,ch0),flow_data(ch0,1:8)] = NAflow.shiftedNeighbourRegression(Y,ch0,flow_velocities,fs,probeset);
    [Yflow2(:,ch0),flow_data(ch0,9:16)] = NAflow.shiftedNeighbourRegression(Y,ch0,-flow_velocities,fs,probeset);
end
Yflow1(isnan(Yflow1)) = 0;
Yflow2(isnan(Yflow2)) = 0;
Yflow = Yflow1 + Yflow2;