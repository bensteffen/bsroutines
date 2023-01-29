classdef StateSignal < IdItem
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
    % Date: 2016-03-22 16:43:09
    % Packaged: 2017-04-27 17:57:59
    properties(SetAccess = 'protected')
        active = false;
    end
    
    methods
        function obj = StateSignal(name,data)
            if nargin < 2
                data = [];
            end
            obj@IdItem(name,data);
        end
        
        function activate(obj)
            obj.active = true;
        end
        
        function deactivate(obj)
            obj.active = false;
        end
        
        function flag = isActive(obj)
            flag = obj.active;
        end
        
        function setData(obj,data)
            obj.value = data;
        end
    end
end