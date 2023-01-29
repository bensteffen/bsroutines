function [m env] = getEnviroment(v, V)

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
    % Date: 2011-05-18 14:18:35
    % Packaged: 2017-04-27 17:58:40
S = size(V);

m = [];
env = [];

c = 1;
for k = v(3)-1:v(3)+1
    for j = v(2)-1:v(2)+1
        for i = v(1)-1:v(1)+1
            if volumeIndexTest([i j k],S) && sum([i j k] == v) ~= 3
                m(c) = V(i,j,k);
                env(c,1:3) = [i j k];
                c = c + 1;
            end
        end
    end
end