classdef TimeMarkers < Model.Item
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
    % Date: 2017-03-06 16:57:07
    % Packaged: 2017-04-27 17:58:29
    methods
        function obj = TimeMarkers(id,varargin)
            obj@Model.Item(id);

            obj.addInput(Input.ElementItem('xdata',[],[],Input.Test(@(x) isnumeric(x),'YData must be numeric')));
            obj.addInput(Input.ElementItem('ydata',[],EventOnsets(1),Input.Test(@(x) isa(x,'EventOnsets'),'Mark data must be of type EventOnsets')));
            
            isStringOrNum = @(x) ischar(x) || iscellstr(x) || isnumeric(x);
            
            obj.addInput(Input.ElementItem('conditions',[],'all',Input.Test(isStringOrNum,'Conditions must be numeric, a string or a cell of strings')));
            obj.addInput(Input.ElementItem('exclude_conditions',[],[],Input.Test(isStringOrNum,'Conditions must be numeric, a string or a cell of strings')));
            obj.addInput(Input.ElementItem('events',[],'all',Input.Test(@(x) strcmp(x,'all') || isnumeric(x) ,'events must be numeric or ''all''')));
            obj.addInput(Input.ElementItem('exclude_events',[],[],Input.Test(@(x) isnumeric(x) ,'exclude events must be numeric')));
            obj.addInput(Input.Boolean('visible',true));
            obj.setDefault();
            
            obj.addOutput(Output.ElementItem('event_selection',[]));
            obj.addOutput(Output.ElementItem('token_selection',[]));
        end
    end
    
    methods(Access = 'protected')
        function createOutput(obj)            
            y = obj.getState('ydata');
            n = numel(y.onsets);
            
            conds = obj.getState('conditions');
            if ischar(conds)
                if strcmp(conds,'all')
                    conds = unique(y.tokens)';
                else
                    conds = y.name2token(conds);
                end
            else
                conds = unique(conds(:))';
            end
            obj.setOutput('token_selection',conds);
            c = mxor(repmat(conds,[n 1]) == repmat(y.tokens,[1 numel(conds)]),2);
            
            events = obj.getState('events');
            if strcmp(events,'all')
                events = (1:n)';
            end
            s = false(n,1);
            s(exclude(events,obj.getState('exclude_events'))) = true;
            obj.setOutput('event_selection',s & c);
        end
    end
end