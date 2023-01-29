classdef PlotDataBase < View.Plot
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
    % Date: 2017-03-20 17:30:54
    % Packaged: 2017-04-27 17:58:31
    properties(SetAccess = 'protected')
        db;
        index_depth;
        data_indices;
    end
    
    methods
        function obj = PlotDataBase(db,index_depth)
            obj@View.Plot('databaseplot');
            
            if nargin < 2
                index_depth = 0;
            end
            
            obj.db = db;
%             obj.db.setUnset('selected_index');
            obj.models.add(Model.Empty(db.id));
            obj.models.add(Model.Empty('db_selection'));
            obj.index_depth = index_depth;
            obj.data_indices = IdList();
        end
        
        function update(obj)
            if obj.models.entry('db_selection').stateOk('selected_index')
                i = obj.models.entry('db_selection').getState('selected_index');
                if obj.isPlotable(i)
                    pid = obj.index2plotid(i);
                    if ~isempty(pid)
                        obj.data_indices.add(IdItem(pid,i));
                    end
                else
                    for pid = Iter(obj.plot_ids.ids)
                        j = Data.Index(i,pid);
                        if obj.isPlotable(j)
                            obj.data_indices.add(IdItem(pid,j));
%                         elseif ~obj.db.hasData(j)
%                             obj.removePlotElement(pid);
%                             obj.data_indices.remove(pid);
                        end
                    end
                end
            end
            for p = Iter(obj.data_indices)
                obj.addPlot(p.id,obj.db.getData(p.value));
            end
        end
    end
    
    methods(Access = 'protected')
        function pid = index2plotid(obj,i)
            pid = '';
            c = i.asCell();
            if numel(c) > obj.index_depth
                c(1:obj.index_depth) = [];
                pid = Data.Index(c).asString();
            end
        end
        
        function flag = isPlotable(obj,i)
            flag = obj.db.hasData(i) && ~isstruct(obj.db.getData(i));
        end
        
        function removeElementToDo(obj,plot_id)
            obj.data_indices.remove(plot_id);
        end
    end
end