function dat = readNirxData(data_dir,topo_layout_path)


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
    % Date: 2017-04-03 15:53:07
    % Packaged: 2017-04-27 17:58:51
file_names = getNameList(data_dir,'','','');

% file_names{strend(file_names,'.hdr')};
hdr = NAio.nirx.analyzeNirxHdr(file_names{strend(file_names,'.hdr')});

sn = hdr.ImagingParameters.Sources;
dn = hdr.ImagingParameters.Detectors;

sdmask = hdr.DataStructure.SDMask';
mes.index = find(sdmask(:));

mes.fname1 = file_names{strend(file_names,'.wl1')};
fid = fopen(mes.fname1);
    mes.wl1 = textscan(fid,repmat('%f',[1 sn*dn]));
fclose(fid);
mes.wl1 = mes.wl1(mes.index);

mes.fname2 = file_names{strend(file_names,'.wl2')};
fid = fopen(mes.fname2);
    mes.wl2 = textscan(fid,repmat('%f',[1 sn*dn]));
fclose(fid);
mes.wl2 = mes.wl2(mes.index);

[hb.oxy,hb.deoxy] = cellfun(@(wl1,wl2) NAio.nirx.mes2hb([wl1 wl2],[850 760],[1 100]),mes.wl1,mes.wl2,'UniformOutput',false);
% [hb.oxy,hb.deoxy] = cellfun(@(wl1,wl2) NAio.nirx.mes2hb([wl1 wl2],[760 850],[1 100]),mes.wl1,mes.wl2,'UniformOutput',false);
[hb.oxy,hb.deoxy,mes.wl1,mes.wl2] = deal(cell2mat(hb.oxy),cell2mat(hb.deoxy),cell2mat(mes.wl1),cell2mat(mes.wl2));

if nargin > 1
    topo_layout = NAio.nirx.analyzeTopoLayout(topo_layout_path);
    chn = size(topo_layout,1);
    [d,s] = find(hdr.DataStructure.SDMask');
    sdch_id_mes = sortrows([sub2ind([sn dn],s,d) (1:chn)'],1);
    sdch_id_topo = sortrows([sub2ind([sn dn],topo_layout(:,1),topo_layout(:,2)) (1:chn)'],1);
    hb.oxy = hb.oxy(:,sdch_id_mes(:,2));
    hb.oxy = hb.oxy(:,sdch_id_topo(:,2));
    hb.deoxy = hb.deoxy(:,sdch_id_mes(:,2));
    hb.deoxy = hb.deoxy(:,sdch_id_topo(:,2));
end

dat.mes = mes;
dat.hb = hb;

dat.trigger = zeros(size(hb.oxy,1),1);
if size(hdr.Markers.Events,2) > 1
    dat.trigger(hdr.Markers.Events(:,3)) = hdr.Markers.Events(:,2);
end