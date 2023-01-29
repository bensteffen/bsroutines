classdef ReferenceList
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
    % Date: 2013-06-05 19:55:27
    % Packaged: 2017-04-27 17:58:34
    properties
        ref_list_;
        ref_number_;
    end
    
    methods
        function obj = ReferenceList()
            obj.ref_list_ = {};
            obj.ref_number_ = 0;
        end
        
        function obj = add(obj,ref)
            obj.ref_number_ = obj.ref_number_ + 1;
            obj.ref_list_{obj.ref_number_} = ref;
        end
        
        function createBib(obj,bib_name,tags)
            keys = cell(obj.ref_number_,1);
            for i = 1:length(keys)
                keys{i} = obj.ref_list_{i}.createKey();
            end
            keys_unique = unique(keys);
            for i = 1:length(keys_unique)
                hits = strcmp(keys_unique{i},keys);
                n_hits = sum(hits);
                if n_hits > 1
                    i_hits = find(hits);
                    for h = 1:n_hits
                        keys{i_hits(h)} = [keys{i_hits(h)} char(96 + h)];
                    end
                end
            end
            bib_str = {};
            for i = 1:obj.ref_number_
                bib_str = [bib_str sprintf('@ARTICLE{%s,\n%s\n}',keys{i},obj.ref_list_{i}.bibtexString(tags))];
            end
            bib_str = cell2str(bib_str,'\n\n');
            fid = fopen([fulldir(bib_name) bib_name],'w+');
                fprintf(fid,'%s',bib_str);
            fclose(fid);
        end
    end
end