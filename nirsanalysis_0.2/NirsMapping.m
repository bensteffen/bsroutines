classdef NirsMapping < View.UiComposite 
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
    % Date: 2016-04-18 15:59:31
    % Packaged: 2017-04-27 17:58:44
    properties(SetAccess = 'protected')
        maps;
        brain_views;
        alg;
    end
    
    methods
        function obj = NirsMapping
            obj@View.UiComposite('nirs_mapping');
        end
        
        function addProbe(obj,probe_model)
            obj.subscribeModel(probe_model);
        end
        
        function setProbeNames(obj,probe_name_cell)
            ax_handles = [];
            [obj.maps,obj.brain_views] = deal(cell(size(probe_name_cell)));
            obj.alg = MatrixAlignment();
%             delete(obj.ax_handles);
%             obj.ax_handles = [];
            map_it = Iter(probe_name_cell);
            for pn = map_it
                ij = index2voxel(map_it.i,size(probe_name_cell));
                
                m = BrainMap(sprintf('bmap_%d_%d',ij(1),ij(2)),pn);
                obj.maps{ij(1),ij(2)} = m;
                obj.subscribeModel(m);
                
                v = BrainView(sprintf('bmap_%d_%d',ij(1),ij(2)),m);
                v.show();
                obj.brain_views{ij(1),ij(2)} = v;
                obj.subscribeView(v);
                
                ax_handles(ij(1),ij(2)) = v.h;
            end
            obj.h.addElement('main',ax_handles);
        end
        
        function updateSelf(obj)
            
        end
    end
    
    methods(Access = 'protected')
        function initShow(obj)
            fh = figure;
            obj.h = View.Matrix(fh);
            obj.h.show();
        end
        
        function builtUi(obj)
        end
        
        function updateUiElements(obj)
        end
        
        function composeUi(obj)
        end
    end
end