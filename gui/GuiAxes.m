classdef GuiAxes < View.UiItem
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
    % Date: 2017-02-21 16:23:26
    % Packaged: 2017-04-27 17:58:22
    properties(SetAccess = 'protected')
        axes_handle;
        axes_panel;
        parent;
    end
    
    methods
        function obj = GuiAxes(id,parent)
            if nargin < 2
                parent = [];
            end
            obj@View.UiItem(id);
            obj.parent = parent;
        end
        
        function update(obj)
        end
    end
    
    properties(Access = 'protected')
        total_alg;
        tool_alg;
        slider;
        zoom_active;
    end
    
    methods(Access = 'protected')
        function builtUi(obj)
            obj.h = plainpanel();
            obj.axes_panel = plainpanel();
            obj.axes_handle = axes('Parent',obj.axes_panel,'LineWidth',2,'Box','on');
            obj.total_alg = MatrixAlignment(obj.h);
            obj.total_alg.addElement(1,1,obj.axes_panel);

            obj.tool_alg = MatrixAlignment(obj.h);
            obj.total_alg.addElement(2,1,obj.tool_alg);
            
%             slider_props = {'Parent',obj.h...
%                            ,'Style','slider' ...
%                            ,'Units','pixels' ...
%                            ,'Min',0 ...
%                            ,'Max',1 ...
%                            ,'SliderStep',[1/100 1/10] ...
%                            ,'Callback',@obj.xScrolling...
%                            };
                       
%             obj.slider = uicontrol(slider_props{:},'Value',0);
%             obj.total_alg.addElement(3,1,obj.slider);
            
            obj.total_alg.heights = [1 40];
%             obj.total_alg.heights = [1 40 20];
            obj.total_alg.realign();
            
            push_zin = uicontrol('String','zoom in','Callback',@obj.zoomin);
            push_zout = uicontrol('String','reset zoom','Callback',@obj.zoomreset);
            push_pan = uicontrol('String','pan','Callback',@obj.pan);
            push_cursor = uicontrol('String','data cursor','Callback',@obj.datacursor);
            obj.tool_alg.addElement(1,1,push_zin);
            obj.tool_alg.addElement(1,2,push_zout);
            obj.tool_alg.addElement(1,3,push_pan);
            obj.tool_alg.addElement(1,4,push_cursor);
            
            obj.zoom_active = false;
        end
        
        function zoomin(obj,varargin)
            if obj.zoom_active
                zoom off;
                obj.zoom_active = false;
            else
                zoom on;
                obj.zoom_active = true;
            end
        end
        
        function zoomreset(obj,varargin)
            zoom out;
            zoom off;
            obj.zoom_active = false;
        end
        
        function pan(varargin)
            pan;
            obj.zoom_active = false;
        end
        
        function datacursor(varargin)
            datacursormode;
            obj.zoom_active = false;
        end
    end
end