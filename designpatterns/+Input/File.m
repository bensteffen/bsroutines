classdef File < Input.ElementItem    
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
    % Date: 2016-09-18 15:32:00
    % Packaged: 2017-04-27 17:58:02
    properties(SetAccess = 'protected')
        filter_spec;
        mode;
    end
    
    methods
        function obj = File(name,default_name,mode,filter_spec)
            if nargin < 3
                mode = 'file';
            end
            if nargin < 4
               filter_spec = {'*',['Select ' mode]};
            end
            value_test = Input.Test(@(x) exist(x,mode),'File not found');
            obj@Input.ElementItem(name,'',default_name,value_test);
            obj.mode = mode;
            obj.filter_spec = filter_spec;
        end
    end
end