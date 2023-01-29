classdef SetStateCommand < Command
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
    % Date: 2014-09-26 17:44:08
    % Packaged: 2017-04-27 17:58:25
    properties(Access = 'protected')
        name;
        value;
    end
    
    methods 
        function obj = SetStateCommand(invoker,reciever,name,value)
            obj@Command(invoker,reciever)
            obj.name = name;
            obj.value = value;
        end
        
        function execute(obj)
            try
                obj.origin_state = obj.reciever.getState(obj.name);
                obj.reciever.setState(obj.name,obj.value);
            catch exc
                obj.execute_exc = exc;
                obj.error_occured = true;
            end
        end
        
        function undo(obj)
            obj.value = obj.origin_state;
            obj.execute();
        end
    end
end