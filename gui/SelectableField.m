classdef SelectableField < View.UiItem & Selectable
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
    % Date: 2016-08-18 11:41:43
    % Packaged: 2017-04-27 17:58:24
    methods
        function obj = SelectableField(id)
            obj@View.UiItem(id);
            obj@Selectable(id);
        end
        
        function update(obj)
        end
    end
    
    methods(Access = 'protected')
        function highlight(obj,flag,i)
            c = ifel(flag,'g','w');
            set(obj.h,'BackgroundColor',c)
        end
        
        function open(obj)
        end
        function builtUi(obj)
            set(obj.h,'BackgroundColor','w','ButtonDownFcn',@obj.selectionCallback);
            obj.defineSelectableHandles(obj.h);
        end
        function updateUiElements(obj)
        end
    end
end