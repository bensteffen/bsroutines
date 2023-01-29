classdef ListItemUiElementFactory
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
    % Date: 2016-08-18 11:50:10
    % Packaged: 2017-04-27 17:58:30
    methods
        function hdls = makeListItemUiElement(item,column_names)
            for n = Iter(column_names)
                switch n
                    case 'ID'
                        h = obj.makeIDField(item.id);
                    case 'SELECTION'
                        h = obj.makeSELECTIONField(item.id);
                    otherwise
                        s = obj.column2fieldstr(item,n);
                        h = obj.makeStringField(s);
                end
                hdls = cat(2,hdls,h);
            end
        end
    end
    
    methods(Access = 'protected')
        function h = makeStringField(str)
            h = uicontrol('Style','text','String',str);
        end
        
        function fstr = column2fieldstr(item,col_name)
            fstr = stringify(item.getState(col_name));
        end
    end
end