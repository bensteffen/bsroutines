classdef Processor < Model.Item
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
    % Date: 2017-04-19 11:39:05
    % Packaged: 2017-04-27 17:58:01
    methods
        function obj = Processor(id,varargin)
            if nargin < 1
                id = 'process';
            end
            obj@Model.Item(id)
            obj.is_reversible = false;
            obj.history = List();
            db = Input.ElementItem('data_base',[],Data.Base ...
                                          ,Input.Test(@(x) isa(x,'Data.Base') ...
                                          ,'Data base must be a Data.Base object') ...
                                          );
            fh = Input.ElementItem('function_handle',[],@(data) data ...
                                          ,Input.Test(@isfunction ...
                                          ,'Function handle must be a valid function handle') ...
                                          );
            pn = Input.ElementItem('process_names',[],'' ...
                                          ,Input.Test(@(x) ischar(x) || iscellstr(x) ...
                                          ,'Process names must be a string or a string cell') ...
                                          );
            
            in = Input.ElementItem('input_indices',[],Data.Indices ...
                                          ,Input.Test(@(x) isa(x,'Data.Indices') || (iscell(x) && all(cellfun(@(el) isa(el,'Data.Indices'),x))) ...
                                          ,'Input indices must be a data index list = Data.Indices') ...
                                          );
                                      
            out = Input.ElementItem('output_indices',[],Data.Indices ...
                                          ,Input.Test(@(x) isa(x,'Data.Indices') || (iscell(x) && all(cellfun(@(el) isa(el,'Data.Indices'),x))) ...
                                          ,'Output indices must be a data index list = Data.Indices') ...
                                          );
            
            obj.addInput(db);
            obj.addInput(fh);
            obj.addInput(pn);
            obj.addInput(in);
            obj.addInput(out);
            obj.setDefault();
            
            viewh = @(x) View.Processor(x,obj,'input_selection',{'process_names','function_handle'});
            obj.view_factory.setDefaultView(viewh);
            
            obj.setInput(varargin{:});
        end
        
        function undo(obj)
            if obj.is_reversible
                obj.status.setInput('progress_name',sprintf('Undoing "%s"... ',obj.id));
                obj.status.setInput('progress_length',obj.history.count());
                for undo_data = Iter(obj.history)
                    obj.undoTodo(undo_data);
                    obj.status.updateOutput();
                end
                undo_data.getData('data_base').updateOutput();
                obj.status.updateOutput();
            end
        end
    end
    
    methods(Access = 'protected')
        function createOutput(obj)
            obj.prepareProcess();
            
            fcn = obj.getState('function_handle');
            db = obj.getState('data_base');
                                        
            ioi = obj.ioIndices();
            obj.clearHistory();
            
            obj.initStatus(sprintf('Processing "%s"... ',obj.id),ioi.nindices);
            while ~ioi.done()
                ioi.current();

                i = ioi.curr_in_indices;
                o = ioi.curr_out_indices;

                idat = db.getData(i);
                odat = cell(o.count(),1);
                odat = obj.process(fcn,idat,odat);
                db.addData(o,odat);
                
                if obj.is_reversible
                    undo_data = Data.Base('undo_data');
                    undo_data.addData('data_base',db);
                    obj.collectUndoData(undo_data,i,idat,o,odat);
                    obj.history.append(undo_data);
                end
                
                fprintf('\n%s -> %s',strjoin(i.asStringList(),','),strjoin(o.asStringList(),','));

                obj.updateStatus();
                ioi.next();
            end
            obj.updateStatus();
            db.updateOutput();
        end
        
        function out = process(obj,function_handle,in,out)
            [out{:}] = function_handle(in{:});
        end
        
        function prepareProcess(obj)
        end
        
        function undo_data = collectUndoData(obj,undo_data,in_indices,in_data,out_indices,out_data)
            undo_data.addData('in.indices' ,in_indices);
            undo_data.addData('in.data'    ,in_data);
            undo_data.addData('out.indices',out_indices);
            undo_data.addData('out.data'   ,out_data);
        end
        
        function undoTodo(obj,undo_data)
            db = undo_data.getData('data_base');
            
            o = undo_data.getData('out.indices');
            db.removeData(o);
            
            X0 = undo_data.getData('in.data');
            i0 = undo_data.getData('in.indices');
            db.addData(i0,X0);
        end
        
        function clearHistory(obj)
            for i = 1:obj.history.count()
                delete(obj.history.at(i));
            end
            obj.history = List();
        end
        
        function memento_state = modifyMementoState(obj,memento_state)
            memento_state.entry('input').entry('data_base').setValue(Data.Base);
        end
                
        function ioi = ioIndices(obj)
            ioi = Data.IOIndices();
            process_names = obj.getState('process_names');
            if isempty(process_names)
                i_idx = obj.getState('input_indices');
                o_idx = obj.getState('output_indices');
                ioi.setIndices(i_idx,o_idx);
            else
                db = obj.getState('data_base');
                indices = db.indices;
                if ischar(process_names)
                    process_names = strsplit(process_names,'.');
                    indices.setProperty('selection_type','wildcard');
                end
                iosplit = objectcell([1 numel(process_names)],'Data.SplitInOut');
                argsplit = objectcell([1 numel(process_names)],'Data.SplitArguments');
                str_it = Iter(process_names);
                for start_str = str_it
                    etree = Interpreter.EvaluationTree(start_str);
                    etree.evaluate(iosplit{str_it.i});
                    etree.evaluate(argsplit{str_it.i});
                end

                ioi.createIndices(indices ...
                                 ,nonunicfun(@(x) x.inputNames,argsplit) ...
                                 ,nonunicfun(@(x) x.outputNames,argsplit));
            end
        end
    end
    
    properties(SetAccess = 'protected')
        is_reversible;
    end
    
    properties(Access = 'protected')
        history;
    end
end
    