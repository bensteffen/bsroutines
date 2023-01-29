classdef EndnoteReference
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
    % Date: 2013-06-05 20:26:20
    % Packaged: 2017-04-27 17:58:34
    properties
        tags_;
    end
    
    methods
        function obj = EndnoteReference
            obj.tags_ = TagMatrix({'tag_name'});
        end
        
        function obj = setTag(obj,tag_name,tag_value)
            switch tag_name
                case 'author'
                    tag_value2 = strreplace(tag_value,' and',',');
                    tag_value2 = strsplit(tag_value2,',');
                    l = length(tag_value2);
                    if mod(l,2) == 0
                        tag_value = cell(1,l/2);
                        i2 = 1:2:l;
                        for i = 1:l/2
                            tag_value{1,i} = cell2str(tag_value2(i2(i):i2(i)+1),',');
                        end
                        tag_value = cell2str(tag_value,' and ');
                    else
                        tag_value = '';
                    end
                otherwise
                    
            end
            obj.tags_ = obj.tags_.add({tag_name},tag_value);
        end
        
        function bibtex_str = bibtexString(obj,tags)
            bibtex_str = {};
            for t = 1:length(tags)
                curr_tag = tags{t};
                if ~isempty(obj.tags_.getId({curr_tag}))
                    tag_value = obj.tags_.get({curr_tag});
                    bibtex_str = [bibtex_str sprintf('%s = {%s}',curr_tag,tag_value)];
                end
            end
            bibtex_str = cell2str(bibtex_str,',\n');
        end
        
        function key_str = createKey(obj)
            author_str = obj.tags_.get({'author'});
            author_str = strsplit(author_str,' and ');
            author_str = strsplit(author_str{1},',');
            first_author = author_str{1};
            year_str = obj.tags_.get({'year'});
            key_str = [first_author year_str];
        end
    end
end