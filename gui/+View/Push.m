classdef Push < View.Item
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
    % Date: 2014-10-06 14:39:14
    % Packaged: 2017-04-27 17:58:31
    properties(Access = 'protected')
        push_command;
    end
    
    methods
        function obj = Push(id,model_name,push_command,display_name)
            obj@View.Item(id);
            obj.models.add(Model.Empty(model_name));
            obj.push_command = push_command;
            obj.push_command.setInvoker(obj);
            
            obj.h = uicontrol('String',display_name,'Callback',@pushCallback);
            
            function pushCallback(h,evd)
                obj.push_command.setReciever(obj.models.lastEntry());
                obj.sendCommand(push_command);
            end
        end
        
        function update(obj)
        end
    end
end