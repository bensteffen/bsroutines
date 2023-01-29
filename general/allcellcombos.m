function combos = allcellcombos(c,shape)

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
    % Date: 2016-08-23 17:13:29
    % Packaged: 2017-04-27 17:58:04
if nargin < 2
    shape = 'table';
end

dim = cellfun(@numel,c);
it = dim2voxel(dim);

if length(dim) == 1
    it = (1:dim)';
end

if length(dim) == 2
    if dim(1) == 1 && dim(2) == 1
        it = [1 1];
    elseif dim(2) == 1
        it = [it ones(size(it,1),1)];
    end
end

switch shape
    case 'table'
        combos = cell(size(it));
        for j = 1:vxd(it)
            combos(:,j) = c{j}(it(:,j));
        end
    case 'cell'
        tmp = cell(size(it));
        for j = 1:vxd(it)
            tmp(:,j) = c{j}(it(:,j));
        end
        combos = cell(size(tmp,1),1);
        for i = 1:size(combos,1)
            combos{i} = tmp(i,:);
        end
end