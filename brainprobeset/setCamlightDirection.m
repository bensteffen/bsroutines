function setCamlightDirection(chcoord_data)

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
    % Date: 2012-11-19 14:23:26
    % Packaged: 2017-04-27 17:57:56
camlight_direction = zeros(numel(chcoord_data),3);

for n = 1:numel(chcoord_data)
    camlight_direction(n,:) = mean(chcoord_data{n}.ch_normal);
    camlight_direction(n,:) = camlight_direction(n,:)/norm(camlight_direction(n,:));
end

camlight_direction = mean(camlight_direction,1);
camlight_direction = camlight_direction/norm(camlight_direction);
[az,el] = cart2sph(camlight_direction(1),camlight_direction(2),camlight_direction(3));
camlight(rad2deg(az),rad2deg(el));
% view(rad2deg(el),rad2deg(az));