function updateDisclaimer(mFileName)

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
    % Date: 2012-01-20 19:37:03
    % Packaged: 2017-04-27 17:58:20
if ischar(mFileName)
    mFileName = {mFileName};
end


for i = 1:length(mFileName)
    cname = mFileName{i};
    fileContent = fileread(cname);

    dis_pos = strfind(fileContent,'Disclaimer of Warranty (from http://www.gnu.org/licenses/)');
    date_pos = strfind(fileContent,'%Date: ');
    date_pos = date_pos(1);
    date_pos = date_pos + length('%Date: ');

    if isempty(dis_pos)
        addDisclaimer(cname);
    else
        cdate = datestr(now);
        fileContent(date_pos:date_pos + length(cdate) - 1) = cdate;
    end

    fh = fopen(cname,'w+'); 
        fprintf(fh,'%s',fileContent);
    fclose(fh);
end