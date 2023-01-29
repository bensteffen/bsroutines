classdef TimeMarkersLegend < View.UiItem
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
    % Date: 2017-02-24 16:46:54
    % Packaged: 2017-04-27 17:58:32
    methods
        function obj = TimeMarkersLegend(id,marker_model)
            obj@View.UiItem(id);
            obj.marker_model = marker_model;
            obj.models.add(marker_model);
        end
        
        function update(obj)
            tokens = obj.marker_model.getState('token_selection');
            n = numel(tokens);
            if n > 0
                imagesc(1:n,'Parent',obj.axs(1));
                colormap(obj.axs(1),lines(n));

                set(obj.axs(2),'XLim',[0 n],'YLim',[-0.1 0.1]);
                delete(obj.txt);
                obj.txt = text((1:n)-0.5,zeros(n,1),createNames('%d',tokens),'Parent',obj.axs(2));
            end
            set(obj.axs,'Visible','off','XTick',[],'YTick',[]);
        end
    end
    
    properties(Access = 'protected')
        marker_model;
        alg;
        axs;
        txt;
    end
    
    methods(Access = 'protected')
        function builtUi(obj)
            obj.alg = MatrixAlignment(obj.h);
            obj.axs = objectmx([2 1],'axes','Visible','off','XTick',[],'YTick',[]);
            obj.alg.addElement(1,1,obj.axs(1));
            obj.alg.addElement(2,1,obj.axs(2));
            obj.alg.heights = [1 20];
            obj.alg.realign();
        end
    end
end