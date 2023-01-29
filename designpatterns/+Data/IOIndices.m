classdef IOIndices < IndexIterator
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
    % Date: 2017-03-13 19:04:49
    % Packaged: 2017-04-27 17:58:01
    properties(SetAccess = 'protected')
        ninargs;
        noutargs;
        nindices;
        in_indices;
        out_indices;
        curr_in_indices;
        curr_out_indices;
    end
    
    methods
        function obj = IOIndices()
        end
        
        function setIndices(obj,in_indices,out_indices)
            in_indices = ifel(iscell(in_indices),in_indices,{in_indices});
            if isempty(out_indices)
                out_indices = in_indices{1};
            else
                out_indices = ifel(iscell(out_indices),out_indices,{out_indices});
            end
            obj.in_indices  = List();
            obj.out_indices = List();
            [obj.ninargs,obj.noutargs] = deal(numel(in_indices),numel(out_indices));
            obj.in_indices.append(in_indices{:})
            obj.in_indices.append(out_indices{:});
            
            obj.nindices = obj.in_indices.at(1).count;
            obj.setIterationData(obj.in_indices.at(1));
        end
        
        function obj = createIndices(obj,indices,in_names,out_names)
            obj.in_indices  = List();
            obj.out_indices = List();
            in_names = obj.prepareNames(in_names);
            out_names = obj.prepareNames(out_names);
            [obj.ninargs,obj.noutargs] = deal(size(in_names,1),size(out_names,1));
            for i = 1:obj.ninargs
                obj.in_indices.append(indices.select(in_names{i,:}));
            end
            obj.nindices = obj.in_indices.at(1).count;
            obj.setIterationData(obj.in_indices.at(1));
            tab = obj.in_indices.at(1).asTable();
            for i = 1:obj.noutargs
                otab = tab;
                for j = 1:size(out_names,2)
                    if ~isempty(out_names{i,j})
                        otab(:,j) = repmat(out_names(i,j),[obj.nindices 1]);
                    end
                end
                obj.out_indices.append(Data.Indices(otab));
            end
        end
        
        function current(obj)
            obj.curr_in_indices  = Data.Indices();
            obj.curr_out_indices = Data.Indices();
            for i = 1:obj.ninargs
                obj.curr_in_indices.append(obj.in_indices.at(i).at(obj.current_index));
            end
            for i = 1:obj.noutargs
                obj.curr_out_indices.append(obj.out_indices.at(i).at(obj.current_index));
            end

%             obj.in = onj.in_indices.at(obj.current_index);
%             obj.out = onj.out_indices.at(obj.current_index);
        end
    end
    
    methods
        function arg_cell = prepareNames(obj,names)
            nargs = cellfun(@(x) numel(x),names);
            if ~all(nargs == 1 | nargs == max(nargs))
                error('Invalid input selection');
            end
            nargs = max(nargs);

            arg_cell = nonunicfun(@(x) repmat(x,[-numel(x)+nargs+1 1]),names);
            arg_cell = cat(2,arg_cell{:});
        end
    end
end