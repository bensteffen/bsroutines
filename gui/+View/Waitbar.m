classdef Waitbar < Ui & View.Status
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
    % Date: 2017-03-20 11:52:28
    % Packaged: 2017-04-27 17:58:32
    properties(Access = 'protected')
        labelh;
        backh;
        progrh;
%         next_progress;
    end
    
    methods
        function obj = Waitbar(id)
            obj@View.Status(id)
%             obj.next_progress = true;
        end
        
        function update(obj)
            status = obj.models.lastEntry();
            if status.stateOk('progress')
                if status.getState('progress_done')
                    set(obj.progrh,'FaceColor','g');
%                     obj.next_progress = true;
                else
%                     if obj.next_progress
%                         obj.next_progress = false;
%                         pause(0.25);
%                     end
                    set(obj.progrh,'FaceColor','r');
%                     obj.progrh.Vertices(2:3,1) = status.getState('progress');
                end
                obj.progrh.Vertices(2:3,1) = status.getState('progress');
                set(obj.labelh,'String',status.getState('progress_string'));
                drawnow;
            end
        end
    end
    
    methods(Access = 'protected')
        function builtUi(obj)
            axs = axes('Parent',obj.h,'Visible','off','XLim',[0 1],'YLim',[-1 1],'Position',[0 0 1 1]);
            obj.progrh = patch(eventpatch(0,0,[-1 1],'Parent',axs,'FaceColor','r','EdgeColor','none'));
            obj.labelh = text(0.5,0,'','Parent',axs,'HorizontalAlignment','center');
        end
        
        function updateUi(obj)
            obj.update();
            obj.updateUiElements();
        end
        
        function updateUiElements(obj)
        end
    end
end