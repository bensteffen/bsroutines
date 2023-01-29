classdef BetweenChannels
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
    % Date: 2015-04-22 15:58:14
    % Packaged: 2017-04-27 17:58:52
    properties(SetAccess = 'protected')
        probeset;
        probeset_neighbours;
        optode_distance = 30;
        edges = [];
        coordlist2d = IdList();
        coordlist3d = IdList();
    end
    
    methods
        function obj = BetweenChannels(probeset)
            obj.probeset = probeset;
            obj.probeset_neighbours = NAps.ChannelWithNeighbours(probeset,false);
            
            chxy = NAps.probesetxy(obj.probeset.channelMatrix(),obj.optode_distance);
            [~,chxyz] = NAps.extractChmxChpos(obj.probeset,'head');
            
            obj.edges = DataBase();
            
            load('brainprobeset\templates\head_patch.mat');
            for ch = 1:length(obj.probeset.channels())
                nbs = obj.probeset_neighbours.entry(ch).value;
                existing = ~isnan(nbs);
                nbsex = nbs(existing);
                edgepos = NaN(8,2);
                edgepos(existing,:) = voxelbetween(chxy(nbsex,:),chxy(ch,:));
                for i = find(existing)
                    p = stringify(edgepos(i,:));
                    if ~obj.edges.hasData(p)
                        obj.edges.setData(p,'channels',[ch nbs(i)]);
                        obj.edges.setData(p,'nbgid',i);
                    else
                        obj.edges.setData(p,'channels',[obj.edges.getItem(p,'channels').value; [ch nbs(i)]]);
                        obj.edges.setData(p,'nbgid',[obj.edges.getItem(p,'nbgid').value; i]);
                    end
                end
            end

            i = IdIterator(obj.edges,AllIdsCollector());
            while ~i.done()
                edgeid = i.current().id;
                chs = obj.edges.getItem(edgeid,'channels').value;
                p3 = mean(voxelbetween(chxyz(chs(:,1),:),chxyz(chs(:,2),:)));
                p3 = findNearestPointOnPatch(head_patch.vertices,p3);
                obj.edges.setData(edgeid,'xyz',p3);
                i.next();
            end
        end
    end
end