classdef IdItemSubject < handle
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
    % Date: 2017-03-16 17:53:05
    % Packaged: 2017-04-27 17:57:58
    methods
        function addObserver(obj,observer)
            obj.observers.add(observer);
        end
        
        function removeObserver(obj,id)
            try
                obj.observers.remove(id);
            catch exc
               if ~strcmp(exc.identifier,'MATLAB:class:InvalidHandle')
                   throw(exc);
               end
            end
        end
        
        function notifyObservers(obj)
            for id = Iter(obj.observers.ids)
                try
                    obj.observers.entry(id).update();
                catch exc
                    if strcmp(exc.identifier,'MATLAB:class:InvalidHandle')
                        obj.removeObserver(id);
                    end
                end
            end
        end
    end
    
    methods(Access = 'protected')
        function obj = IdItemSubject()
            obj.observers = IdList();
        end
    end
    
    properties(SetAccess = 'protected')
        observers;
    end
end