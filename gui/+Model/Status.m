classdef Status < Model.Item
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
    % Date: 2017-03-15 12:52:12
    % Packaged: 2017-04-27 17:58:29
    properties(Access = 'protected')
        step_counter = 0;
    end
    
    methods
        function obj = Status(id)
            obj@Model.Item(id);
            
            n = Input.ElementItem('progress_name','','' ...
                                  ,Input.Test(@ischar ...
                                  ,'Progress name must be a string') ...
                                  );
            s = Input.ElementItem('progress_template','%d %%','%d %%' ...
                                  ,Input.Test(@ischar ...
                                  ,'Progress tamplete must be a string') ...
                                  );
            l = Input.ElementItem('progress_length',[],1 ...
                                  ,Input.Test(@isnumeric ...
                                  ,'Progress length must be a scalar') ...
                                  );
            obj.addInput(n);
            obj.addInput(s);
            obj.addInput(l);
            
            obj.addOutput(Output.ElementItem('progress',0.0));
            obj.addOutput(Output.ElementItem('progress_done',false));
            obj.addOutput(Output.ElementItem('percent',0));
            obj.addOutput(Output.ElementItem('progress_string',''));
            
            obj.setDefault('progress_template');
        end
    end
    
    methods(Access = 'protected')
        function createOutput(obj)
            if obj.stateOk('progress_length')
                obj.step_counter = obj.step_counter + 1;
                p = obj.step_counter/prod(obj.getState('progress_length'));
                obj.setOutput('progress',p);
                obj.setOutput('progress_done',false);
                if p >= 1
                    obj.setState('unset','progress_length');
                    obj.step_counter = 0;
                    obj.setOutput('progress',1.0);
                    obj.setOutput('progress_done',true);
                end
                percent = round(min([round(100*p) 100]));
                obj.setOutput('percent',percent);
                obj.setOutput('progress_string',[obj.getState('progress_name') sprintf(obj.getState('progress_template'),percent)]);
            elseif obj.stateChanged('progress_name')
                obj.setOutput('progress_string',[obj.getState('progress_name') sprintf(obj.getState('progress_template'),0)]);
            end
        end
    end
end