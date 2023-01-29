function D = NirsSubjectData2DataBase(S,settings)

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
    % Date: 2017-03-21 13:13:45
    % Packaged: 2017-04-27 17:58:44
D = Data.Base('nirs_data_base');
subj_key = S.getProperty('subject_keyword');
subjects = S.subjects();
ndig = floor(log10(max(subjects))) + 1;

for s = subjects
    for tscell = Iter(settings.experiment.time_series)
        tsprops = containers.Map(tscell(1:2:end),tscell(2:2:end));
        
        fs = tsprops('sample_rate');
        tr = S.getSubjectData(s,tsprops('trigger_name'));
        
        ts = TimeSeries(S.getSubjectData(s,tsprops('name')),fs,(find(tr,1) - 1)/fs);
        
        i = find(tr);
        onsets1 = i(1:2:end);
        onsets2 = i(2:2:end);
        ev = EventOnsets((onsets1-onsets1(1))/fs,tr(onsets1),(onsets2-onsets1)/fs);
        
        sid = int2digitstr(s,ndig);
        D.addData('subjects',sprintf('%s%s',subj_key,sid),tsprops('name'),ts);
        D.addData('subjects',sprintf('%s%s',subj_key,sid),tsprops('trigger_name'),ev);
    end
end

for probecell = Iter(settings.plot_tool.probesets)
    probeprops = containers.Map(probecell(1:2:end),probecell(2:2:end));
    probe = probeprops('probeset');
    pdata = probe.coordData();
    if ~isempty(pdata) && numel(pdata.chs) > 0 && isfield(pdata.chs(1),'head_coords')
        x = NAps.probesetxyz(probe,'head');
    else
        probeset_matrix = probe.channelMatrix();
        od = probe.getProperty('optode_distance');
        chn = sum(~isnan(probeset_matrix(:)));
        x = zeros(chn,2);
        for ch = 1:chn
            [i,j] = find(probeset_matrix == ch);
            ij = [j,i]-1;
            x(ch,:) = od*ij;
        end
    end
    c = Coordinates();
    c.addCoordinates('head','CH',x);
    D.addData(probeprops('name'),c);
end

