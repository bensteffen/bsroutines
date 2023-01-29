classdef PushSignal < View.UiItem
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
    % Date: 2016-03-22 15:27:07
    % Packaged: 2017-04-27 17:58:31
    properties(Access = 'protected')
        model;
        signal_name;
        display_name;
    end
    
    methods
        function obj = PushSignal(id,model,signal_name,display_name)
            if nargin < 4
                display_name = defaultDisplayName(signal_name);
            end
            obj@View.UiItem(id);
            obj.model = model;
            obj.signal_name = signal_name;
            obj.display_name = display_name;
        end
        
        function update(obj)
        end
    end
    
    methods(Access = 'protected')
        function builtUi(obj)
            uicontrol('Parent',obj.h,'Units','normalized','Position',[0 0 1 1],'String',obj.display_name,'Callback',@obj.pushCallback);
        end
        
        function updateUiElements(obj)
        end
        
        function pushCallback(obj,h,evd)
            obj.model.sendSignal(obj.signal_name);
        end
    end
end