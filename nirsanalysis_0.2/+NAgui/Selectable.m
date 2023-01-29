classdef Selectable < handle   
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
    % Date: 2014-05-30 19:02:23
    % Packaged: 2017-04-27 17:58:50
    properties(SetAccess = 'protected')
        is_selected;
    end
    
    methods(Abstract = true)
        highlight(obj,flag);
        open(obj);
    end
    
    methods(Access = 'protected')
        function checkSelection(obj,event)
            was_selected = isequal(event.child_id,obj.id);
            switch event.selection_type
                case 'normal'
                    if obj.is_selected
                        obj.setSelection(false);
                    else
                        obj.setSelection(was_selected);
                    end
                case {'alt','extend'}
                    if obj.is_selected
                        obj.setSelection(~was_selected);
                    else
                        obj.setSelection(was_selected);
                    end
                case 'open'
                    if was_selected
                        obj.open;
                    end
            end
        end
    end
    
    methods(Access = 'private')
        function setSelection(obj,flag)
            obj.is_selected = flag;
            obj.highlight(flag);
        end
    end
end