function b = blocks(x,block_offset,block_interval,varargin)

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
    % Date: 2016-03-09 18:24:52
    % Packaged: 2017-04-27 17:58:04
param_defaults.baseline_interval = [];
param_defaults.baseline_dim = 1;
param_defaults.baseline_method = @(x_,bl_) x_-bl_;
[prop_names,prop_values] = parsePropertyCell(varargin);
assignPropertyValues(prop_names,prop_values,param_defaults);

[rown,coln] = size(x);

i = blockindices(block_offset,block_interval(1),block_interval(2));

add_start = abs(min([0; i(:)-1]));
add_end = max([rown; i(:)]) - rown;

x = cat(1,NaN(add_start,coln),x,NaN(add_end,coln));
i = i + add_start;
b = x(i,:);

block_length = diff(block_interval) + 1;
block_number = numel(block_offset);

b = permute(reshape(b,[block_length block_number coln]),[1 3 2]);

if ~isempty(baseline_interval)
    bl = blocks(x,block_offset,baseline_interval);
    rv = ones(1,3);
    rv(baseline_dim) = size(b,baseline_dim);
    bl = repmat(mean(bl,baseline_dim),rv);
    b = baseline_method(b,bl);
end