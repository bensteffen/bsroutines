classdef KeyCreator < List    
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
    % Date: 2016-01-21 18:44:45
    % Packaged: 2017-04-27 17:57:58
    methods
        function obj = KeyCreator(varargin)
            obj@List(varargin{:});
        end
        
        function db_keys = keys(obj,db)
            key_parts = obj.data';
            keys2combine = {};
            for j = 1:length(key_parts)
                curr_key = key_parts{j};
                curr_key = ifel(iscell(curr_key),curr_key,{curr_key});
                keys2combine = [keys2combine {curr_key}];
                db_keys = allcellcombos(keys2combine);
                key_ok = false(size(db_keys,1),1);
                for k = 1:size(db_keys,1)
                    key_ok(k) = hasfield(db,db_keys(k,:));
                end
                db_keys = db_keys(key_ok,:);
            end
        end
    end
end