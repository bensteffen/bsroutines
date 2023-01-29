classdef NirsFigure < NAgui.CompositeGuiElement
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
    % Date: 2014-03-21 17:03:22
    % Packaged: 2017-04-27 17:58:50
    properties(SetAccess = 'protected')
        figure_axes;
    end
    
    methods
        function obj = NirsFigure(gui_handle,plot_id)
            obj@NAgui.CompositeGuiElement(gui_handle,plot_id);
            obj.figure_axes = axes('Parent',gui_handle);
            set(obj.figure_axes,'ButtonDownFcn',@obj.buttonDown);
        end
        
        function show(obj)
            i = IdIterator(obj,AllIdsCollector());
            while ~i.done()
                i.current().show();
                i.next();
            end
        end
        
        function update(obj)
        end
    end
end