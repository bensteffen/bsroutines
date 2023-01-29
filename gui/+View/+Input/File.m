classdef File < View.Input.AbstractComposite
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
    % Date: 2017-04-06 16:13:11
    % Packaged: 2017-04-27 17:58:34
    methods
        function obj = File(id,model,input_name,varargin)
            obj@View.Input.AbstractComposite(id,model,input_name);
            
            obj.edit = View.Input.Edit([obj.id '.edit'],obj.model,obj.input_name,'style',0);
            obj.add(obj.edit);
            
            obj.addProperty(Input.StringCell('filter_spec',{'*','Select file'}));
            obj.addProperty(Input.Options('mode',{'file','dir'}));
            obj.setProperties(varargin{:});
        end
    end

    methods(Access = 'protected')
        function valueCallback(obj,varargin)
            switch obj.getProperty('mode')
                case 'file'
                    [fname,pname] = uigetfile(obj.getProperty('filter_spec'));
                    if fname == 0, return; end
                    pname = ifel(strcmp(pname,pwd),'',pname);
                    n = fullfile(pname,fname);
                case 'dir'
                    last_pwd = pwd;
                    if ~isempty(obj.inputValue())
                        cd(obj.inputValue());
                    end
                    n = uigetdir(obj.getProperty('filter_spec'));
                    cd(last_pwd);
                    if n == 0, return; end
            end
            obj.sendCommand(Command.SetInput(obj,obj.models.lastEntry(),obj.input_name,n,true));
        end
        
        function composeUi(obj)
            obj.edit.show();
            push = uicontrol('String','browse','Callback',@obj.valueCallback);
            obj.value_alg.add(push);
            obj.value_alg.add(obj.edit.h);
        end
        
        function updateUiElements(obj)
        end
    end
    
    properties(Access = 'protected')
        edit;
    end
end