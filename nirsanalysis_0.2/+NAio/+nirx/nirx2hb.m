function nirx2hb(data_folder,topo_layout_path)

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
    % Date: 2013-11-27 15:11:38
    % Packaged: 2017-04-27 17:58:51
data_names = dircontent(data_folder,'*','dirs');

for n = 1:length(data_names)
    nirxdat = readNirxData(fullfile(data_folder,data_names{n}),topo_layout_path);
    oxy = nirxdat.hb.oxy;
    save([data_folder filesep data_names{n} '_Oxy.mat'],'oxy');
    deoxy = nirxdat.hb.deoxy;
    save([data_folder filesep data_names{n} '_Deoxy.mat'],'deoxy');
    trigger = nirxdat.trigger;
    save([data_folder filesep data_names{n} '_Trigger.mat'],'trigger');
end