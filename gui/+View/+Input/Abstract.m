classdef Abstract < handle
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
    % Date: 2017-03-02 16:53:55
    % Packaged: 2017-04-27 17:58:32
    properties(SetAccess = 'protected')
        model;
        input_name;
        valueh;
        labelh;
        alg;
    end

    methods(Access = 'protected')
        function obj = Abstract(model,input_name)
            obj.model = model;
            obj.input_name = input_name;
        end
        
        function v = inputValue(obj)
            v = obj.model.getState(obj.input_name);
        end
    end
    
    methods(Access = 'protected',Abstract = true)
        resetCallback(obj,h,evdata);
        valueCallback(obj,h,evdata);
        createAlginment(obj);
    end
end