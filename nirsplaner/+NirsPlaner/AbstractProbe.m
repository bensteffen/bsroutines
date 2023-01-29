classdef AbstractProbe < Model.ViewingItem
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
    % Date: 2017-04-25 13:02:44
    % Packaged: 2017-04-27 17:58:54
    properties(SetAccess = 'protected')
        head_model_name;
    end
    
    methods(Access = 'protected')
        function obj = AbstractProbe(name,head_model_name)
            obj@Model.ViewingItem(name);
            fname2d = Input.File('2d_coordinate_file','ETG4000-3x5probe1.txt');
            %fname3d = Input.File('3d_coordinate_file','');
            tr2 = Input.ElementItem('2d_coordinate_transformation',{},{} ...
                ,Input.Test(@iscellstr ...
                ,'Transformation list must be string cell.') ...
                );
            
            

            obj.addInput(fname2d);
            %obj.addInput(fname3d);
            obj.addInput(tr2);
            
            obj.addOutput(Output.ElementItem('probe_data',struct));
            obj.addOutput(Output.ElementItem('template_name',''));
            
            obj.head_model_name = head_model_name;
            obj.models.add(Model.Empty(head_model_name));
            
            obj.constructor_input = {head_model_name};
        end

        function createOutput(obj)
            if obj.stateOk('2d_coordinate_file')
                obj.readCoordinateFile(obj.getState('2d_coordinate_file'),'xy');
            end
%             if obj.stateOk('3d_coordinate_file')
%                 obj.readCoordinateFile(obj.getState('3d_coordinate_file'),'xyz');
%             end
            if obj.stateOk('2d_coordinate_transformation')
                pd = obj.getState('probe_data');
                xy = cell2mat(cellfun(@(x) x.xy,struct2cell(pd),'UniformOutput',false));
                for trans = Iter(obj.getState('2d_coordinate_transformation'))
                    for n = Iter(fieldnames(pd))
                        switch trans
                            case 'flipx'
                                [a,b] = deal(min(xy(:,1)),max(xy(:,1)));
                                pd.(n).xy(1) = -(pd.(n).xy(1) - b) + a;
                            case 'flipy'
                                [a,b] = deal(min(xy(:,2)),max(xy(:,2)));
                                pd.(n).xy(2) = -(pd.(n).xy(2) - b) + a;
                        end
                    end
                end
                obj.setOutput('probe_data',pd);
            end
            if isstruct(obj.getState('probe_data'))
                obj.updateCoordinates();
                template_name = obj.models.entry(obj.head_model_name).getState('template_name');
                obj.setOutput('template_name',template_name);
            end
        end
    end
    
    methods(Abstract = true)
        readCoordinateFile(obj,fname,dim_str);
        updateCoordinates(obj);
    end
    
    methods 
        function expd = extractProbeData(obj,val_name)
            expd = containers.Map();
            pd = obj.getState('probe_data');
            for n = Iter(fieldnames(pd))
                expd(n) = pd.(n).(val_name);
            end
        end
        
        function update(obj)
            obj.updateOutput();
        end
    end
end