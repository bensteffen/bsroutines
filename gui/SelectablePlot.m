classdef SelectablePlot < View
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
    % Date: 2014-09-26 13:59:18
    % Packaged: 2017-04-27 17:58:25
    methods
        function obj = SelectablePlot(xaxis,ydata,line_color,line_style,name)
            model = Model();
            controller = Controller(model);
            obj@View(controller,model,gcf);
            obj.model.setState('select_id','');
            
            obj.h = axes();
            if nargin > 3
                obj.add(xaxis,ydata,line_color,line_style,name);
            end
        end
        
        function add(obj,xaxis,ydata,line_color,line_style,name)
            for j = 1:size(ydata,2)
                lh = LineView(obj.controller,obj.model,obj.h,sprintf(name,j),[xaxis ydata(:,j)]);
                lh.set('Color',line_color,'LineStyle',line_style);
                obj.model.addObserver(lh);
            end
        end
        
        function addMark(obj,xaxis,trigger,duration,name)
            if strcmp(duration,'pairs')
                ev_i = find(trigger);
                n = length(ev_i);
                if mod(n,2) == 1
                    ev_i = [ev_i; length(trigger)];
                    n = n + 1;
                end
                x = [xaxis(ev_i(1:2:n)) xaxis(ev_i(2:2:n))];
                mark_id = trigger(ev_i(1:2:n));
            end
            
            mcolor = lines(length(unique(mark_id)));
            for i = 1:size(x,2)
                mh = PlotMarkView(obj.controller,obj.model,obj.h,x(i,:),sprintf(name,x(i,:)),mark_id(i));
                mh.set('FaceColor',mcolor(i,:));
                obj.model.addObserver(mh);
            end
        end
        
        function update(obj)
        end
    end
end