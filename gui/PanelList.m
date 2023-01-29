classdef PanelList < hgsetget
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
    % Date: 2013-03-08 15:08:29
    % Packaged: 2017-04-27 17:58:23
    properties
        parent = [];
    end
    
    properties(Access = 'protected')
        hdl_;
        param_;
    end
    
    methods
        function obj = PanelList(parent)
            if nargin < 1
                obj.parent = figure('MenuBar','none','ToolBar','none');
            else
                obj.parent = parent;
            end
            obj.hdl_.sub_panel = [];
            obj.param_.panel_height = [];
        end
        
        function obj = addPanel(obj,list_position,height)
            obj.hdl_.sub_panel = insert(obj.hdl_.sub_panel,list_position,uipanel('Parent',obj.parent,'Visible','off','Units','pixels'));
            obj.param_.panel_height = insert(obj.param_.panel_height,list_position,height);
            obj.updatePanel('add');
        end
        
        function hdls = panels(obj,index)
            if nargin < 2
                hdls = obj.hdl_.sub_panel;
            else
                hdls = obj.hdl_.sub_panel(index);
            end
        end
        
        function obj = set.parent(obj,val)
            if ishandle(val) || isa(val,'hgsetget')
                obj.parent = val;
                set(obj.parent,'ResizeFcn',@ppresize);
            else
                throw(NirsException('Gui','PanelList','Parent handle must be a valid handle.'));
            end
            
            function ppresize(dummy1,dummy2)
                obj.updatePanel('resize');
            end
        end
    end
    
    methods(Access = 'protected')
        function obj = updatePanel(obj,flag)
            panel_number = length(obj.hdl_.sub_panel);
            parent_pixpos = getpixelposition(obj.parent);
            sum_height = sum(obj.param_.panel_height);
            if ~strcmp(flag,'resize') && sum_height > parent_pixpos(4)
                parent_pixpos(2) = parent_pixpos(2) - (sum_height - parent_pixpos(4));
                parent_pixpos(4) = sum_height;
                set(obj.parent,'Position',parent_pixpos);
            end
            x0 = 0;
            dx = parent_pixpos(3);
            for i = 1:panel_number
                y0 = parent_pixpos(4) - sum(obj.param_.panel_height(1:i));
                dy = obj.param_.panel_height(i);
                set(obj.hdl_.sub_panel(i),'Position',[x0 y0 dx dy],'Visible','On');
            end
        end
    end
end