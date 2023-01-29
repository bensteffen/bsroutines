classdef CompositeGuiElement < IdList & Showable
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
    % Date: 2014-03-21 17:11:35
    % Packaged: 2017-04-27 17:58:49
    methods        
        function addGuiElement(obj,gui_element)
            gui_element.setEventHandler(obj.event_handler);
            obj.add(gui_element);
        end
        
        function show(obj)
            i = IdIterator(obj,AllIdsCollector());
            while ~i.done()
                i.current().show();
                i.next();
            end
        end
    end
    
    methods(Access = 'protected')
        function obj = CompositeGuiElement(gui_handle,gui_element_id)
            obj@Showable(gui_handle);
            obj@IdList(gui_element_id);
            obj.setParent(IdItem(gui_handle));
        end
    end
end