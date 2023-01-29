classdef Item < View.Abstract & IdItem
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
    % Date: 2017-03-08 13:46:23
    % Packaged: 2017-04-27 17:58:30
    methods(Access = 'protected')
        function obj = Item(id)
            obj@IdItem(id);
        end
        
        function subscribeToDo(obj)
            obj.connectToModels();
        end
        
        function unsubscribeToDo(obj)
            obj.disconnectFromModels();
        end
    end
    
    methods(Abstract = true)
        update(obj);
    end
end