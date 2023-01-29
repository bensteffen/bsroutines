classdef Table < Model.Item
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
    % Date: 2014-10-07 16:44:52
    % Packaged: 2017-04-27 17:58:29
    methods
        function obj = Table(id)
            obj@Model.Item(id);
            
            t = Input.ElementItem('table_data',{},{} ...
                                  ,Input.Test(@iscell ...
                                  ,'Table data must be a cell') ...
                                  );
            fc = Input.ElementItem('filter_column',[],1 ...
                                  ,Input.Test(@(x) isscalar(x) && x > 0 ...
                                  ,'Filter column must be a scalar > 0') ...
                                  );
            f = Input.ElementItem('filter',@(x) true,@(x) true ...
                                  ,Input.Test(@isfunction ...
                                  ,'Filter must be a function handle') ...
                                  );
            sc = Input.ElementItem('sort_column',[],1 ...
                                  ,Input.Test(@(x) isscalar(x) && x > 0 ...
                                  ,'Sort column must be a scalar > 0') ...
                                  );
            s = Input.ElementItem('sorter',@sortall,@sortall ...
                                  ,Input.Test(@isfunction ...
                                  ,'Sorter must be a function handle') ...
                                  );
            t.addInput(fc,Input.Test(@(x,y) x <= size(obj.getState('table_data'),2),'Filter column must be <= column number'),obj);
            t.addInput(sc,Input.Test(@(x,y) x <= size(obj.getState('table_data'),2),'Sort column must be <= column number'),obj);
            obj.addInput(t);
            obj.addInput(fc);
            obj.addInput(f);
            obj.addInput(s);
            obj.addInput(sc);
            
            obj.addOutput(Output.ElementItem('display_data',{}));
            obj.setDefault('sorter');
        end
    end
    
    methods(Access = 'protected')
        function createOutput(obj)
            if obj.stateOk('table_data')
                tab = obj.getState('table_data');
                if obj.stateOk('filter_column') && obj.stateOk('filter')
                    filter_ok = cellfun(obj.getState('filter'),tab(:,obj.getState('filter_column')));
                    vtab = tab(filter_ok,:);
                else
                    vtab = tab;
                end
                if obj.stateOk('sort_column')
                    sorter = obj.getState('sorter');
                    sort_i = sorter(vtab(:,obj.getState('sort_column')));
                    vtab = vtab(sort_i,:);
                end
                obj.setOutput('display_data',vtab);
            end
        end
    end
end