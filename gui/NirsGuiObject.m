classdef NirsGuiObject < hgsetget
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
    % Date: 2013-03-06 16:38:05
    % Packaged: 2017-04-27 17:58:23
    properties
        nirs_object_name = 'NirsExperiment';
    end
    
    properties(Access = 'protected')
        hdl_;
    end
    
    methods
        function obj = NirsGuiObject()
        end
        
        function obj = show(obj)
            obj.hdl_.main = figure('MenuBar','none','ToolBar','none');
            eval(sprintf('nirs_object = %s();',obj.nirs_object_name));
            prop_info = nirs_object.getPropertyInfos();
        end
        
        function obj = set.nirs_object_name(obj,object_name)
            if any(strcmp(object_name,NAnaT_CLASSNAMES))
                obj.nirs_object_name = object_name;
            else
                error('NirsGuiObject.set.nirs_object_name: Object name must be a NAnaT object name.');
            end
        end
    end
end