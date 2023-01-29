classdef UiComposite < Ui & View.Composite
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
    % Date: 2017-03-08 13:49:58
    % Packaged: 2017-04-27 17:58:32
    methods
        function updateSelf(obj)
        end
    end
    
    methods(Access = 'protected')
        function obj = UiComposite(id)
            obj@View.Composite(id);
            obj.appendDeleteToDo(@(x) x.unsubscribe());
%             obj.appendDeleteToDo(@(x) x.deleteChildren());
        end
        
        function updateUi(obj)
            for v = Iter(obj)
                if isa(v,'Ui')
                    v.update();
                    v.updateUiElements();
                end
            end
        end
        
        function builtUi(obj)
        end
        
        function updateUiElements(obj)
        end
        
        function composeUi(obj)
        end
    end
end