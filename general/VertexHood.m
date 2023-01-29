classdef VertexHood
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
    % Date: 2016-12-13 17:46:48
    % Packaged: 2017-04-27 17:58:03
    properties(SetAccess = 'protected')
        patch_struct;
        vertex_id;
        vertex_x;
        neighbor_ids;
        neighbor_face_ids;
        hood_size;
    end
    
    methods 
        function obj = VertexHood(patch_struct,vertex_id)
            obj.patch_struct = patch_struct;
            if nargin > 1
               obj = obj.setVertexId(vertex_id);
            end
        end
        
        function obj = setVertexId(obj,vertex_id)
            if withinrange(vertex_id,[1 size(obj.patch_struct.vertices,1)])
                obj.vertex_id = vertex_id;
                obj.vertex_x = obj.patch_struct.vertices(obj.vertex_id,:);
                obj.neighbor_ids = obj.neighborIds();
                obj.neighbor_face_ids = obj.neighborFaceIds();
                obj.hood_size = length(obj.neighbor_ids);
            end
        end
        
        function n = neighborIds(obj)
            n = obj.patch_struct.faces(obj.neighborFaceIds(),:);
            n = unique(n(:));
            n = exclude(n,obj.vertex_id);
        end
        
        function v = neighborVertices(obj)
            v = obj.patch_struct.vertices(obj.neighbor_ids,:);
        end
        
        function f = neighborFaceIds(obj)
            f = find(any(obj.patch_struct.faces == obj.vertex_id,2));
        end
        
        function [n,x] = faceNormals(obj)
            [n,x] = facenormals(obj.patch_struct,obj.neighbor_face_ids);
        end
        
        function n = vertexNormal(obj)
            a = facearea(obj.patch_struct,obj.neighbor_face_ids);
            a = a/sum(a);
            n = sum(obj.faceNormals.*repmat(a,[1 3]));
        end
        
        function id = nearestNeighbor(obj)
            v = obj.neighborVertices();
            [~,i] = min(voxelnorm(v - repmat(obj.vertex_x,[obj.hood_size 1])));
            id = obj.neighbor_ids(i);
        end
        
        function id = nextNeighbor(obj,direction)
            direction = normvec(direction);
            v = obj.neighborVertices();
            v = normvec(v - repmat(obj.vertex_x,[obj.hood_size 1]));
            d = dot(repmat(direction,[obj.hood_size 1])',v')';
            [~,i] = min(abs(d - 1));
            id = obj.neighbor_ids(i);
        end
        
        function nextFace(obj,direction)
            direction = normvec(direction);
            v = obj.neighborVertices();
            v0 = v - repmat(obj.vertex_x,[obj.hood_size 1]);
            vn = normvec(v0);
            d = dot(repmat(direction,[obj.hood_size 1])',vn')';
            [~,i] = sort(abs(d-1));
            i = i(1:2);
            j = obj.neighbor_ids(i);
            
            faces = obj.patch_struct.faces;
            f_ids = (1:size(faces,1))';
            f = any(faces == j(1),2) & any(faces == j(2),2);
            [faces,f_ids] = deal(faces(f,:),f_ids(f));
            
            f_id = f_ids(~any(faces == obj.vertex_id,2))
            
            [a,b] = deal(v0(i(1),:),v0(i(2),:));
            
            g = normvec(b - a);
            phi_a = acos(dot(direction,-g));
            phi_s = acos(dot(-a,g));
%             rad2deg(phi_s)
            s = norm(a)*sin(phi_s)/sin(phi_a)
        end
    end
end