function [X,column_names,subject_cell] = subjectmx(X,dim_names,subject_ids)

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
    % Date: 2014-05-28 15:54:30
    % Packaged: 2017-04-27 17:58:20
subject_number = size(X,1);
nd = ndims(X);
n = numel(X);
column_number = n/subject_number;

X = permute(X,[2:nd 1]);
X = X(:);
X = reshape(X,[column_number subject_number])';

if nargin < 2
    column_names = {};
else
    c = allcellcombos(dim_names);
    column_names = cell(1,column_number);
    for i = 1:size(c,1)
        column_names{i} = cell2str(c(i,:),'.');
    end
end

    
if nargin > 2
    subject_cell = [[{'SID'} column_names]; num2cell([subject_ids(:) X])];
else
    subject_cell = {};
end