classdef Vector < Input.ElementItem     
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
    % Date: 2017-03-06 17:23:19
    % Packaged: 2017-04-27 17:58:02
    methods
        function obj = Vector(name,default_value,le)
            if nargin < 3
                value_test = Input.Test(@(x) isnumeric(x) && (isempty(x) || isvector(x)),'%s must be a numeric vector');
            else
                value_test = Input.Test(@(x) isnumeric(x) && isvector(x) && numel(x) == le,sprintf('%s must be a numeric vector with %d elements',le));
            end
            obj@Input.ElementItem(name,[],default_value,value_test);
        end
    end
end