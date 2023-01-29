classdef ListScrolling < HandleInterface
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
    % Date: 2017-03-22 11:17:02
    % Packaged: 2017-04-27 17:58:23
    properties(SetAccess = 'protected')
        mxa;
        heights;
        row_ids;
    end
    
    methods
        function obj = ListScrolling(id,gui_figure)
            obj.h = ScrollPanel(id,gui_figure);
            obj.h.setProperty('scroll_size',[-1 0]);
            obj.mxa = MatrixAlignment(obj.h.scroll_panel);
            obj.row_ids = IdList();
        end
        
        function appendElement(obj,row_id,element,height)
            element = ifel(iscell(element),element,{element});
            psize = cellfun(@(x) valueat(getpixelposition(x.h),4),element);
            if nargin < 4
                height = psize;
            end
            scs = obj.h.getProperty('scroll_size');
            obj.h.setProperty('scroll_size',[-1 scs(2)+height]);
            i = obj.mxa.children_size(1)+1;
            element_it = Iter(element);
            for e = element_it
                obj.mxa.addElement(i,element_it.i,e,[height 1]);
            end
            obj.row_ids.add(IdItem(row_id,[]));
            obj.heights = [obj.heights;height];
        end
        
        function deleteElement(obj,row_id)  
            row = find(cellfun(@(x) isequal(x,row_id),obj.row_ids.ids));
            handle2rm = obj.mxa.children(row,:);
            obj.mxa.removeRow(row);
            delete(handle2rm);
            obj.row_ids.remove(row_id);
            obj.heights(row) = [];
            obj.h.setProperty('scroll_size',[-1 sum(obj.heights)]);
        end
        
        function removeElement(obj,row_id)  
            row = cellfun(@(x) isequal(x,row_id),obj.row_ids.ids);
            obj.row_ids.remove(row_id);
            obj.heights(row) = [];
            obj.h.setProperty('scroll_size',[-1 sum(obj.heights)]);
        end
    end
end