classdef Subject < handle
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
    % Date: 2016-09-06 17:01:04
    % Packaged: 2017-04-27 17:57:59
    methods
        function addObserver(obj,observer)
            obj.observers.append(observer);
        end
        
%         function removeObserver(obj,observer)
%             obj.observers.remove(observer);
%         end
        
        function notifyObservers(obj)
            for observer = Iter(obj.observers)
                observer.update();
            end
        end
    end
    
    methods(Access = 'protected')
        function obj = Subject()
            obj.observers = List();
        end
    end
    
    properties
        observers;
    end
end