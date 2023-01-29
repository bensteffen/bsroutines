classdef Pipeline < Model.List
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
    % Date: 2017-03-15 19:01:22
    % Packaged: 2017-04-27 17:58:01
    methods
        function obj = Pipeline(data_base,id)
            if nargin < 2
                id = 'process_pipeline';
            end
            obj@Model.List(id);
            obj.data_base = data_base;
        end
        
        function addProcess(obj,p)
            if isa(p,'Data.Processor')
                obj.appendModel(p);
            else
                error('Data.Process.Pipeline.addProcess(): input must be a Data.Processor');
            end
        end
    end
    
    methods(Access = 'protected')
        function appendToDo(obj,p)
            p.setInput('data_base',obj.data_base);
        end
    end

    properties(Access = 'protected')
        data_base;
    end
end