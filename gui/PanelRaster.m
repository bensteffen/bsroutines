classdef PanelRaster < hgsetget
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
    % Date: 2014-03-21 18:06:04
    % Packaged: 2017-04-27 17:58:23
    properties
        dimension;
        panels;
        panel_number;
        panel_posratio;
        parent;
        current_border;
        mouse_down;
    end
    
    methods
        function obj = PanelRaster(parent,dim)
            if nargin < 1
                obj.parent = gcf;
            else
                obj.parent = parent;
            end
            if nargin < 2
                obj.dimension = [1 2];
            else
                obj.dimension = dim;
            end
            obj.panel_number = prod(obj.dimension);
            obj.panels = zeros(obj.panel_number,1);
            obj.panel_posratio = {ones(obj.dimension(1),1)*1/obj.dimension(1), ones(obj.dimension(2),1)*1/obj.dimension(2)};
            for i = 1:obj.panel_number
                obj.panels(i) = uipanel('Parent',obj.parent,'Units','pixel','BorderType','line');
            end
            set(obj.parent,'ResizeFcn',@parentResize);
            set(obj.parent,'WindowButtonMotionFcn',@mouseMove);
            set(obj.parent,'WindowButtonDownFcn',@mouseDown);
            set(obj.parent,'WindowButtonUpFcn',@mouseUp);
            obj.mouse_down = false;
            
            function parentResize(a,b)
                obj.setPanelPositions();
            end
            
            function mouseMove(a,b)
                [parent_size,pointer_pos] = getMouseAndParentPosition();
                if ~obj.mouse_down
                    obj.current_border = [findNearestBorder(obj.panel_posratio{1},pointer_pos(1),parent_size(1)),...
                                          findNearestBorder(obj.panel_posratio{2},pointer_pos(2),parent_size(2))];
                end
            end
            
            function mi = findNearestBorder(ratios,pointerpos,parentlength)
                csr = cumsum(ratios);
                d = abs(csr - pointerpos/parentlength);
                mi = find(d == min(d));
                if abs(parentlength*csr(mi) - pointerpos) > 2
                    mi = -1;
                end
            end
            
            function mouseDown(a,b)
                obj.mouse_down = true;
            end
            
            function mouseUp(a,b)
                obj.mouse_down = false;
                [parent_size,pointer_pos] = getMouseAndParentPosition();
                cbis = find(obj.current_border > 0);
                if ~isempty(cbis)
                    for bi = cbis
                        cb = obj.current_border(bi);
                        pos_change = (pointer_pos(bi)/parent_size(bi) - sum(obj.panel_posratio{bi}(1:cb)));
                        newpos = [obj.panel_posratio{bi}(cb) obj.panel_posratio{bi}(cb + 1)] + [1 -1]*pos_change;
                        child_size = obj.getChildSize(cb+1) ./ parent_size;
                        if all(newpos - 2*child_size > 0)
                            obj.panel_posratio{bi}(cb) = newpos(1);
                            obj.panel_posratio{bi}(cb + 1) = newpos(2);
                            obj.setPanelPositions();
                        end
                    end
                end
            end
            
            function [parsiz,poipos] = getMouseAndParentPosition()
                parsiz = getpixelposition(obj.parent);
                parsiz = parsiz([4 3]);
                poipos = fliplr(get(obj.parent,'CurrentPoint'));
                poipos(1) = parsiz(1) - poipos(1);
            end
        end
    end
    
    methods(Access = 'protected')
        function setPanelPositions(obj)
            for i = 1:obj.panel_number
                [b,l] = ind2sub(obj.dimension,i);
                parent_size = getpixelposition(obj.parent);
                left = sum(obj.panel_posratio{2}(1:l-1)*parent_size(3));
                bottom = parent_size(4) - sum(obj.panel_posratio{1}(1:b)*parent_size(4));
                width = obj.panel_posratio{2}(l)*parent_size(3);
                height = obj.panel_posratio{1}(b)*parent_size(4);
                set(obj.panels(i),'Position',[left bottom width height]);
            end
        end
        
        function chn_size = getChildSize(obj,panel_i)
            chn = get(obj.panels(panel_i),'Children');
            chn = chn(strcmpi(get(chn,'Units'),'pixels'));
            if ~isempty(chn)
                chn_size = get(chn,'Position');
                chn_size = [chn_size(:,1)+chn_size(:,3) chn_size(:,2)+chn_size(:,4)];
                chn_size = sum(chn_size,1);
            else
                chn_size = [0 0];
            end
        end
    end
end