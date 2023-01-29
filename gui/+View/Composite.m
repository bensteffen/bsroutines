classdef Composite < View.Abstract & IdList 
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
    % Date: 2017-03-08 13:54:19
    % Packaged: 2017-04-27 17:58:29
    methods(Access = 'protected')
        function obj = Composite(id)
            obj@IdList(id);
        end
        
        function subscribeToDo(obj)
            obj.connectToModels();
            for v = Iter(obj)
                v.subscribe(obj.controller);
            end
        end
        
        function unsubscribeToDo(obj)
            for v = Iter(obj)
                v.unsubscribe();
            end
            obj.disconnectFromModels();
        end
    end
    
    methods
        function update(obj)
            for v = Iter(obj)
                v.update();
            end
            obj.updateSelf();
        end
    end
    
    methods(Abstract = true)
        updateSelf(obj);
    end
end