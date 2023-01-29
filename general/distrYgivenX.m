function [joint_ydistr,joint_bins] = distrYgivenX(sampled_x,sampled_y,given_x)

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
    % Date: 2015-11-27 17:30:05
    % Packaged: 2017-04-27 17:58:07
[xdistr,xbins] = distribution(sampled_x);
[~,ybins] = distribution(sampled_y);

xevents = binfind(sampled_x,xbins);
given_xevent = binfind(given_x,xbins);

yevents = binfind(sampled_y,ybins);

joint_yevents = yevents(xevents == given_xevent);

[joint_ydistr,joint_bins] = distribution(sampled_y(joint_yevents));

joint_ydistr = joint_ydistr/probof(given_x,xdistr,xbins);
