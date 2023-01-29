classdef NirsProbesetAxes
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
    % Date: 2016-06-29 15:50:41
    % Packaged: 2017-04-27 17:58:23
    properties
        param_;
        hdl_;
    end
    
    methods
        function obj = NirsProbesetAxes(channel_matrix,parent)
            if nargin < 2
                parent = figure();
            end
            obj.hdl_.main = parent;
            obj.param_.probeset.channel_matrix = channel_matrix;
            obj.param_.probeset.dim = ceil(size(channel_matrix));
            obj.param_.probeset.channels = channel_matrix(~isnan(channel_matrix));
            obj.param_.axes.width = 1/(obj.param_.probeset.dim(2) + 1);
            obj.param_.axes.height = 1/obj.param_.probeset.dim(1);
            obj.param_.margin.textx = 15;
            obj.param_.margin.texty = 10;
        end
        
        function hdls = handles(obj)
            hdls = obj.hdl_.axes;
        end
        
        function obj = show(obj)
            for j = obj.param_.probeset.channels(:)'
                obj.hdl_.axes(j,1) = axes('Parent',obj.hdl_.main,'Units','pixels','Clipping','off');
                obj.hdl_.text(j,1) = text(1-0.3,0.05,sprintf('%d',j),'Units','normalized',...
                                   'FontWeight','bold','FontSize',12,'Color',[1 1 1]*0.7,...
                                   'VerticalAlignment','bottom','HorizontalAlignment','left',...
                                   'Parent',obj.hdl_.axes(j));
            end
            set(obj.hdl_.main,'ResizeFcn',@obj.figresize);
            obj.figresize();
        end
    end
    
    methods(Access = 'protected')
        function figresize(obj,varargin)
            main_pos = getpixelposition(obj.hdl_.main);
            margin = 10;
            [m,n] = deal((obj.param_.probeset.dim(2) + 1),obj.param_.probeset.dim(1));
            [w,h] = deal(main_pos(3)/m,main_pos(4)/n);
            for j = obj.param_.probeset.channels(:)'
                [ci,cj] = find(obj.param_.probeset.channel_matrix == j);
                [ci,cj] = deal(ci-1,cj-1);
                x0 = cj*w - cj*2*margin/m;
                y0 = main_pos(4) - (ci + 1)*h + (ci + 1)*2*margin/n;
                axw = 2*w-2*margin/m;
                axh = h-2*margin/n;
                ax_pos = [x0+margin y0-margin  axw axh];
%                 ax_pos = ax_pos + [mx my 0 0];
                set(obj.hdl_.axes(j,1),'Position',ax_pos);
            end
        end
    end
end