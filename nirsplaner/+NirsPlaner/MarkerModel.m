classdef MarkerModel < Model.Item
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
    % Date: 2016-09-18 14:15:26
    % Packaged: 2017-04-27 17:58:55
    methods
        function obj = MarkerModel(name)
            obj@Model.Item(name);
            
            load(fullfile(fileparts(mfilename('fullpath')),'..','..','brainprobeset','textpatches.mat'),'tpO');
            m = Input.ElementList('marker_3d_shape' ... 
                                  ,Input.ElementItem('dummy',tpO,struct('vertices',zeros(0,3),'faces',[]) ...
                                  ,Input.Test(@(x) isstruct(x) && isfield(x,'vertices') && isfield(x,'faces') && size(x.vertices,2) == 3 ...
                                  ,'Marker 3D shape must be a valid 3D patch structure') ...
                                 ) ...
                );
            
            obj.addInput(m);
        end
    end
    
    methods(Access = 'protected')
        function createOutput(obj)
            
        end
    end
end