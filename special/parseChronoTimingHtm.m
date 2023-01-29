function results = parseChronoTimingHtm(fname)

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
    % Date: 2013-08-19 16:40:01
    % Packaged: 2017-04-27 17:58:37
html = fileread(fname);
txt = regexprep(html,'<script.*?/script>','');
txt = regexprep(txt,'<style.*?/style>','');
txt = regexprep(txt,'<.*?>','');

txt = strsplit(txt,sprintf('\r\n'))';
txt(cellfun(@isempty,txt)) = [];
txt = strreplace(txt,',','.');

results = zeros(0,7);
curr_line = 1;
curr_id = 0;
while curr_line < length(txt)
    
    if length(txt{curr_line}) < 63 && ~isempty(str2num(txt{curr_line}))
        curr_id = str2num(txt{curr_line});
        time_lines = curr_line + 3 : curr_line + 8;
        results = [results; curr_id timestr2hour(txt(time_lines)')];
        curr_line = time_lines(end) + 1;
    else
        curr_line = curr_line + 1;
    end
end

results(any(isnan(results),2),:) = [];