function xyz = getEntryCoordsFromNeuroNavigator(xmlfname)

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
    % Date: 2014-05-15 19:20:13
    % Packaged: 2017-04-27 17:58:35
X = parseXML(xmlfname);

xyz = [];
for i = 1:length(X.Children)
    if strcmp(X.Children(i).Name,'Entry')
        entry_data = X.Children(i).Children(2).Children(2);
        x = str2double(entry_data.Attributes(1).Value);
        y = str2double(entry_data.Attributes(2).Value);
        z = str2double(entry_data.Attributes(3).Value);
        xyz = [xyz; x y z];
    end
end