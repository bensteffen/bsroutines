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


function cmap = getColorMap(slice, type)

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
    % Date: 2012-01-20 19:38:34
    % Packaged: 2017-04-27 17:58:10
if nargin == 1 || strcmp(type, 'color')
    colorCell{1} = [120 120 255]/255;
    colorCell{2} = [255 174 54]/255;
%     colorCell{3} = [200 255 200]/255;
    colorCell{3} = [255 255 255]/255;   %Knochen
    colorCell{4} = [180 120 180]/255;
    colorCell{5} = [100 100 100]/255;
    colorCell{6} = [150 150 150]/255;
    colorCell{7} = [255 0 0]/255;
    colorCell{8} = [0 255 0]/255;
    colorCell{9} = [100 100 255]/255;
elseif strcmp(type, 'gray')
    colorCell{1} = [1 1 1];         %Luft
    colorCell{2} = [0.2 0.2 0.2];   %Haut
    colorCell{3} = [0.6 0.6 0.6];   %Knochen
    colorCell{4} = [0.8 0.8 0.8];   %CSF
    colorCell{5} = [0 0 0];         %grau
    colorCell{6} = [0.4 0.4 0.4];   %weiß
    colorCell{7} = [255 0 0]/255;
    colorCell{8} = [0 255 0]/255;
end    
    

Li = size(slice,1);
Lj = size(slice,2);

cmap = zeros(Li,Lj,3);

for j = 1:Lj
    for i = 1:Li
        if slice(i,j) >= 0
            cmap(i,j,:) = colorCell{slice(i,j) + 1};
        else
            cmap(i,j,:) = colorCell{8};
        end
    end
end