classdef TimeMarkers < View.Item & Selectable
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
    % Date: 2017-03-06 16:57:23
    % Packaged: 2017-04-27 17:58:32
    properties(SetAccess = 'protected')
        plot_model;
        style_element;
        parent_axes;
        marks;
    end
    
    methods
        function obj = TimeMarkers(id,plot_element,style_element,parent_axes)
            obj@View.Item(id);
            obj@Selectable(id);
            if nargin < 4
                pax = panelaxes;
                parent_axes = pax.axh;
            end
            obj.plot_model = plot_element;
            obj.style_element = style_element;
            obj.models.add(plot_element);
            obj.parent_axes = parent_axes;
        end
        
        function update(obj)
            obj.unshow();
            
            evs = obj.plot_model.getState('ydata');
            nevs = numel(evs.onsets);
            cond = obj.plot_model.getState('token_selection');
            if obj.plot_model.getState('visible') && ~isempty(cond)
                evroi = find(obj.plot_model.getState('event_selection') & ~evs.events_excluded);
                cmap = lines(length(cond));
                colors = repmat([0.9 0.9 0.9],[nevs 1]);
                colors(evroi,:) = getColorList(evs.tokens(evroi),cmap);
                ylims = get(obj.parent_axes,'Ylim');
                for i = 1:nevs
                    p = eventpatch(evs.onsets(i),evs.duration(i),0.9*ylims ...
                                  ,'FaceColor',colors(i,:) ...
                                  ,'EdgeColor','none' ...
                                  ,'LineWidth',2 ...
                                  ,'FaceAlpha',0.5 ...
                                  ,'Parent',obj.parent_axes ...
                                  ,'ButtonDownFcn',@obj.selectionCallback);
                    obj.marks = [obj.marks;patch(p)];
                end
            end
            obj.defineSelectableHandles(obj.marks);
        end
        
        function unshow(obj)
            delete(obj.marks);
            obj.marks = [];
        end
    end
    
    methods(Access = 'protected')
        function highlight(obj,flag,i)
            set(obj.marks(i),'EdgeColor',ifel(flag,'k','none'));
        end
        
        function open(obj)
        end
    end
end