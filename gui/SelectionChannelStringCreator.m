classdef SelectionChannelStringCreator < SelectionStringCreator
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
    % Date: 2017-02-06 18:19:57
    % Packaged: 2017-04-27 17:58:25
    methods
        function obj = SelectionChannelStringCreator(varargin)
            obj@SelectionStringCreator(varargin{:});
        end
    end
    
    methods(Access = 'protected')
        function s = compileString(obj)
            switch numel(obj.selected_strcell)
                case 0
                    prefix = '';
                case 1
                    prefix = '%s CH%s';
                otherwise
                    prefix = '%s CH[%s]';
            end
            s = sprintf(prefix,obj.selectable.id,strjoin(obj.selected_strcell,','));
        end
    end
end