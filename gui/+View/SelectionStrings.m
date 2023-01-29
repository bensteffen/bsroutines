classdef SelectionStrings < View.UiItem
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
    % Date: 2016-07-04 16:18:32
    % Packaged: 2017-04-27 17:58:32
    properties
%         text_num;
        text_fields;
        alignment;
    end
    
    methods 
        function obj = SelectionStrings(id)
            obj@View.UiItem(id);
            obj.models.add(Model.Empty('selection'));
        end
        
        function update(obj)
            string_list = obj.models.entry('selection').getState('selection_string');
            text_num = numel(string_list);
            if text_num ~= numel(obj.text_fields)
                obj.updateUiElements();
            end
            for i = 1:text_num
                obj.alignment.addElement(i,1,obj.text_fields(i));
                set(obj.text_fields(i),'String',string_list{i});
            end
        end
    end
    
    methods(Access = 'protected')
        function builtUi(obj)
            obj.alignment = MatrixAlignment(obj.h);
            obj.update();
        end
        
        function updateUiElements(obj)
            string_list = obj.models.entry('selection').getState('selection_string');
            n = length(string_list);
            delete(obj.text_fields);
            obj.text_fields = objectmx([n 1],'uicontrol','Style','text','BackgroundColor','w');
            obj.alignment.heights = repmat(20,[n 1]);
            obj.alignment.realign();
        end
    end
end