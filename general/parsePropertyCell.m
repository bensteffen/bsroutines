%Disclaimer of Warranty (from http://www.gnu.org/licenses/). 
%THERE IS NO WARRANTY FOR THE PROGRAM, TO THE EXTENT PERMITTED BY APPLICABLE LAW.
%EXCEPT WHEN OTHERWISE STATED IN WRITING THE COPYRIGHT HOLDERS AND/OR OTHER PARTIES 
%PROVIDE THE PROGRAM "AS IS" WITHOUT WARRANTY OF ANY KIND, EITHER EXPRESSED OR IMPLIED,
%INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR
%A PARTICULAR PURPOSE. THE ENTIRE RISK AS TO THE QUALITY AND PERFORMANCE OF THE PROGRAM
%IS WITH YOU. SHOULD THE PROGRAM PROVE DEFECTIVE, YOU ASSUME THE COST OF ALL NECESSARY
%SERVICING, REPAIR OR CORRECTION.

%Author: Florian Haeussinger (florian.haeussinger@med.uni-tuebingen.de)
%Date: 23-Apr-2012 18:12:48


function [prop_names,prop_values,error_str,prop_flags] = parsePropertyCell(c,prop_names_needed,prop_test_info)


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
    % Date: 2016-02-22 10:26:56
    % Packaged: 2017-04-27 17:58:14
if nargin > 1
    n = length(prop_names_needed);
else
    n = 0;
end

if nargin < 3
    prop_test_info = [];
end

error_str = '';
prop_names = {};
prop_values = {};
prop_flags = {};

if iscell(c)
    l = length(c);
    if ~mod(l,2)
        prop_names = c(logical(mod(1:l,2)));
        if iscellstr(prop_names)
            prop_names = strsplit(prop_names,'.');
        else
            error_str = 'Property names must be strings.';
            return;
        end
        prop_flags = cell(size(prop_names));
        for i = 1:length(prop_names)
            if length(prop_names{i}) > 1
                prop_flags{i} = prop_names{i}{2};
            else
                prop_flags{i} = '';
            end
            prop_names{i} = prop_names{i}{1};
        end
        if n > 0
            if n == l/2
                if any(sum(strcmp(repmat(prop_names,[factorial(n) 1]),perms(prop_names_needed)),2) == n)
                    prop_values = c(logical(mod(0:l-1,2)));
                    sort_index = zeros(1,n);
                    for i = 1:n
                        sort_index(i) = find(strcmp(prop_names_needed{i},prop_names));
                    end
                    prop_names = prop_names(sort_index);
                    prop_values = prop_values(sort_index);
                    prop_flags = prop_flags(sort_index);
                    if ~isempty(prop_test_info)
                        for i = 1:n
                            if ~prop_test_info(i).test_fcn_handle(prop_values{i})
                                error_str = sprintf(prop_test_info(i).error_str,prop_values{i});
                                break;
                            end
                        end
                    end
                else
                    error_str = ['Only the properties "' cell2str(prop_names_needed,'", "') '" may be defined.'];
                    return;
                end
            else
                error_str = ['Only the properties "' cell2str(prop_names_needed,'", "') '" may be defined.'];
                return;
            end
        else
            if iscellstr(prop_names)
                prop_values = c(logical(mod(0:l-1,2)));
            else
                error_str = 'Property names must be strings.';
            end
        end
    else
        error_str = 'Length of property cell must be even.';
    end
else
    error_str = 'Property cell must be a cell.';
end
