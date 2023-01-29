%Disclaimer of Warranty (from http://www.gnu.org/licenses/). 
%THERE IS NO WARRANTY FOR THE PROGRAM, TO THE EXTENT PERMITTED BY APPLICABLE LAW.
%EXCEPT WHEN OTHERWISE STATED IN WRITING THE COPYRIGHT HOLDERS AND/OR OTHER PARTIES 
%PROVIDE THE PROGRAM "AS IS" WITHOUT WARRANTY OF ANY KIND, EITHER EXPRESSED OR IMPLIED,
%INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR
%A PARTICULAR PURPOSE. THE ENTIRE RISK AS TO THE QUALITY AND PERFORMANCE OF THE PROGRAM
%IS WITH YOU. SHOULD THE PROGRAM PROVE DEFECTIVE, YOU ASSUME THE COST OF ALL NECESSARY
%SERVICING, REPAIR OR CORRECTION.

%Author: Florian Haeussinger (florian.haeussinger@med.uni-tuebingen.de)
%Date: 31-Jan-2012 18:30:57


function array = cell2num(C,dim_flag)

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
    % Date: 2012-10-24 14:26:16
    % Packaged: 2017-04-27 17:58:05
if nargin < 2
    S = size(C);
    dim_flag = 'row_wise';
    if S(1) == 1 && S(2) > 1
        dim_flag = 'column_wise';
    end
end

array = [];

switch dim_flag
    case 'row_wise'
        sdim = 2;
    case 'column_wise'
        sdim = 1;
    otherwise
        error('cell2num: dim_flag must be "row_wise" or "column_wise"');
end            

C(cellfun(@(x) ~isnumeric(x),C,'UniformOutput',true)) = [];

for i = 1:length(C)
    data = C{i};
    if ~isnumeric(data)
        error('cell2num: Cell entries must be numeric!');
    end
    if i == 1
        L1 = size(data,sdim);
        array = data;
    else
        if L1 == size(data,sdim) || isempty(data)
            switch sdim
                case 2
                    array = [array; data];
                case 1
                    array = [array data];
            end
        else
            data
            error('TagMatrix.toArray: Data sizes must fit!');
        end
    end
end