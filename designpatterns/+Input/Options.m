classdef Options < Input.ElementItem
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
    % Date: 2016-03-11 17:26:49
    % Packaged: 2017-04-27 17:58:02
    properties(SetAccess = 'protected')
        options = {};
    end
    
    methods
        function obj = Options(name,options,default_index)
            if nargin < 3
                default_index = 1;
            end
            [unset_value,default_value] = deal(options{default_index});
            value_test = Input.Test(@(x) any(cellfun(@(o) isequal(x,o),options)) ...
                                   ,sprintf('%s must be one of these options: %s',strreplace(name,'_',' '),strjoin(nonunicfun(@stringify,options),', ')));
            obj@Input.ElementItem(name,unset_value,default_value,value_test);
            obj.options = options;
        end
    end
end