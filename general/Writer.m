%Disclaimer of Warranty (from http://www.gnu.org/licenses/). 
%THERE IS NO WARRANTY FOR THE PROGRAM, TO THE EXTENT PERMITTED BY APPLICABLE LAW.
%EXCEPT WHEN OTHERWISE STATED IN WRITING THE COPYRIGHT HOLDERS AND/OR OTHER PARTIES 
%PROVIDE THE PROGRAM "AS IS" WITHOUT WARRANTY OF ANY KIND, EITHER EXPRESSED OR IMPLIED,
%INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR
%A PARTICULAR PURPOSE. THE ENTIRE RISK AS TO THE QUALITY AND PERFORMANCE OF THE PROGRAM
%IS WITH YOU. SHOULD THE PROGRAM PROVE DEFECTIVE, YOU ASSUME THE COST OF ALL NECESSARY
%SERVICING, REPAIR OR CORRECTION.

%Author: Florian Haeussinger (florian.haeussinger@med.uni-tuebingen.de)
%Date: 20-Jan-2012 19:40:16


classdef Writer
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
    % Date: 2014-01-14 14:30:34
    % Packaged: 2017-04-27 17:58:03
    properties
        properties_;
    end
    
    methods
        function obj = Writer()
            obj.properties_ = TagMatrix({'porperty'});
            obj.properties_ = obj.properties_.add({'file_name'}, 'data.txt');
            obj.properties_ = obj.properties_.add({'data'}, []);
            obj.properties_ = obj.properties_.add({'header'}, '');
            obj.properties_ = obj.properties_.add({'precision'}, 4);
            obj.properties_ = obj.properties_.add({'separator'}, '\t');
            obj.properties_ = obj.properties_.add({'write_type'}, 'w');
        end
        
        function obj = write(obj)
            data = obj.properties_.get({'data'});
            fname = obj.properties_.get({'file_name'});
            precision = obj.properties_.get({'precision'});
            separator = obj.properties_.get({'separator'});
            header = obj.properties_.get({'header'});
            write_type = obj.properties_.get({'write_type'});
            matrix2file(data, fname, precision, separator, header, write_type);
        end
        
        function obj = setProperty(obj, name, value)
            if ischar(name)
                name = lower(name);
                if any(strcmp(name,obj.properties_.tags(1)))
                    ok_flag = 0;
                    switch name
                        case 'file_name'
                            if ischar(value)
                                ok_flag = 1;
                            end
                        case 'data'
                            if isnumeric(value) || ischar(value) || iscellstr(value)
                                ok_flag = 1;
                            end
                        case 'header'
                            if ischar(value)
                                ok_flag = 1;
                            end
                        case 'precision'
                            if isscalar(value) && value >= 0
                                ok_flag = 1;
                            end
                        case 'separator'
                            if ischar(value)
                                ok_flag = 1;
                            end
                        case 'write_type'
                            if ischar(value)
                                if strcmp(value,'overwrite')
                                    value = 'w';
                                    ok_flag = 1;
                                elseif strcmp(value,'append')
                                    value = 'a';
                                    ok_flag = 1;
                                else
                                    error(['NirsWriter.setProperty: Unknown write type "' value '"'])
                                end
                            end
                    end
                    if ok_flag
                        obj.properties_ = obj.properties_.add({name}, value);
                    else
                        error(['NirsWriter.setProperty: Bad value type for option "' name '"!']);
                    end
                else
                    error(['NirsWriter.setProperty: Unknown option "' name '"']);
                end
            else
                error('NirsWriter.setProperty: Option name must be a string!');
            end
        end
    end
end