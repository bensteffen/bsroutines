classdef BrainMap < Model.ViewingItem
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
    % Date: 2016-04-18 15:30:19
    % Packaged: 2017-04-27 17:57:53
    properties(SetAccess = 'protected')
        brain_handle;
        head_handle;
        probe_model_name;
        light_on = false;
    end
    
    methods
        function obj = BrainMap(id,probe_model_name)
            obj@Model.ViewingItem(id);
            obj.probe_model_name = probe_model_name;
            obj.models.add(Model.Empty(probe_model_name));
            obj.addInput(Input.ElementItem('values2map',{},{},Input.Test(@iscell,'Values must be a cell array')));
            obj.addInput(Input.ElementItem('color_map',[],braincmap(64),Input.Test(@(x) isnumeric(x) && size(x,2) == 3,'Color map not valid')),true);
            obj.addInput(Input.ElementItem('color_limit',[],[],Input.Test(@(x) isnumeric(x) && (isempty(x) || isrange(x)),'Color limit must be empty or a valid range')));
            obj.addInput(Input.Options('map_type',{'brain','head'}));
            
            obj.addOutput(Output.ElementItem('patch',[]));
        end
        
        function map(obj,type,values)
            probe_model = obj.models.entry(obj.probe_model_name);
            switch type
                case 'brain'
                    patch_data = obj.updateMap(values,probe_model.template.brain_patch,probe_model.brain_mapper);
                case 'head'
                    patch_data = obj.updateMap(values,probe_model.template.head_patch,probe_model.head_mapper);
            end
            obj.setOutput('patch',patch_data);
        end
        
        function update(obj)
%             obj.createOutput();
        end
    end

    methods(Access = 'protected')
        function createOutput(obj)
            if obj.stateChanged('values2map') || obj.stateChanged('color_map') || obj.stateChanged('color_limit') || obj.stateChanged('map_type')
                obj.map(obj.getState('map_type'),obj.getState('values2map'));
            end
        end
        
        function patch_data = updateMap(obj,y,patch_data,mapper)
            if iscell(y)
                y = obj.handleCellInput(y);
            end
            mapper.setInput('color_map'  ,obj.getState('color_map'));
            mapper.setInput('color_limit',obj.getState('color_limit'));
            mapper.setInput('y',y);
            mapper.updateOutput();

            patch_data.FaceColor = 'interp';
            patch_data.FaceVertexCData = mapper.getState('cdata');
        end
        
        function y_ = handleCellInput(obj,y_)
            chids = obj.models.entry(obj.probe_model_name).getState('chids');
            if numel(y_) == numel(chids)
                y_ = y_(:);
                y_ = cellfun(@(x,ids) x(ids),y_,chids,'UniformOutput',false);
                y_ = nonunicfun(@(x) x(:),y_);
                y_ = cell2mat(y_);
            else
                error('BrainMap.updateMap: value cell does not fit probe set number');
            end
        end
    end
end