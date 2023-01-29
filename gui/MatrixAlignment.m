classdef MatrixAlignment < HandleInterface
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
    % Date: 2017-03-08 17:21:49
    % Packaged: 2017-04-27 17:58:23
    properties(SetAccess = 'protected')
        children;
        children_size;
        is_uielement;
    end
    
    properties
        widths;
        heights;
    end
    
    methods
        function obj = MatrixAlignment(parent)
            if nargin < 1
                parent = figure;
            end
            obj.h = uipanel('Units','normalized','BorderType','none','BackgroundColor','w'...
                           ,'Parent',parent,'Visible','on'...
                           ,'SizeChangedFcn',@obj.realign ...
                           ,'DeleteFcn',@obj.deleteAlignment ...
                           );
            obj.children = gobjects(0);
            obj.children_size = [0 0];
%             obj.is_uielement = boolean(0);
        end
        
        function addElement(obj,i,j,element,element_size)
            if nargin < 5
                element_size = [1 1];
            end
            if isfigure(element)
                p = uipanel('Units','normalized','BorderType','none','BackgroundColor','w');
                set(get(element,'children'),'Parent',p);
                close(element);
                element = p;
            end
            if isa(element,'Ui')
                obj.is_uielement(i,j) = true;
            end
            childh = guih(element);
            set(childh,'Parent',obj.h,'Units','normalized');
            if isa(element,'Ui')
                element.appendDeleteToDo(@(x) obj.childDeletion(x.h))
            else
                set(childh,'DeleteFcn',@obj.childDeletion);
            end
            obj.children(i,j) = childh;
            obj.widths(j) = element_size(2);
            obj.heights(i) = element_size(1);
            obj.realign();
        end
        
        function removeRow(obj,i)
%             row = obj.children(i,:);
%             delete(row);
            obj.children(i,:) = [];
            obj.heights(i) = [];
            obj.realign();
        end
        
        function removeElement(obj,h)
            k = obj.children == h;
            if any(k)
                [i,j] = find(obj.children == h);
                if isscalar(obj.children)
                    [obj.widths,obj.heights] = deal(0);
                    obj.children = gobjects(0);
                elseif isvector(obj.children)
                    if obj.children_size(2) == 1 % row vector
                        obj.heights(i) = [];
                        obj.children(i) = [];
                    else                         % col vector
                        obj.widths(j) = [];
                        obj.children(j) = [];
                    end
                end
                obj.realign();
            end
        end
        
        function clearChildren(obj)
            delete(obj.children);
            [obj.widths,obj.heights] = deal([]);
        end
        
        function realign(obj,varargin)
            [w,w0] = obj.getSize('widths',obj.widths);
            [h,h0] = obj.getSize('heights',obj.heights);
            
            obj.children_size = size(obj.children); 
            for i = 1:obj.children_size(1)
                for j = 1:obj.children_size(2)
                    child = obj.children(i,j);
                    if ishandle(child)
                        p = [w0(j) h0(i) w(j) h(i)];
                        set(obj.children(i,j),'Position',max(ones(1,4)*0.001,p));
                    end
                end
            end
        end
        
%         function
            
%         end
        
        function transpose(obj)
            h = obj.heights;
            w = obj.widths;
            obj.heights = w;
            obj.widths = h;
            obj.children = obj.children';
            obj.realign;
        end
    end
    
    methods(Access = 'protected')
        function childDeletion(obj,h,evd)
            if ishandle(h)
                obj.removeElement(h);
            end
%             if is_uielement
%             end
        end
        
        function deleteAlignment(obj,varargin)
            for child = Iter(obj.children)
                if isa(child,'Ui')
                    child.deleteUi();
                end
            end
        end
        
        function [values,offset] = getSize(obj,name,values)
            values = values(:);
            switch name
                case 'widths'
                    siz_i = 2;
                    pos_i = 3;
                case 'heights'
                    siz_i = 1;
                    pos_i = 4;
            end

            values(values <= 0) = 1;
            
            pxi = values > 1;
            rsize = getpixelposition(obj.h);
            values(pxi) = values(pxi)/rsize(pos_i);
            l_pix = sum(values(pxi));
            l_npix = 1-l_pix;
            
            n_npix = max(sum(~pxi),1);
            values(values == 1) = 1/n_npix;
            values(~pxi) = l_npix*values(~pxi)/sum(values(~pxi));
            
            switch name
                case 'widths'
                    offset = [0; cumsum(values)];
                    offset = offset(1:end-1);
                case 'heights'
                    offset = 1 - cumsum(values);
            end
            
            values(isinf(values)) = 0;
        end
    end
end