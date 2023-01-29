classdef ChannelPath < IdList
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
    % Date: 2014-03-13 09:57:57
    % Packaged: 2017-04-27 17:58:52
    properties(SetAccess = 'immutable')
        channel_matrix;
        path_length;
        paths;
    end
    
    methods
        function obj = ChannelPath(seed_channel,channel_matrix,path_length)
            obj@IdList(seed_channel);
            obj.channel_matrix = channel_matrix;
            obj.path_length = path_length;
            obj.addChannels(obj);
            i = IdIterator(obj,AllTreeIdsCollector());
            p = [];
            while ~i.done()
                curr_path = i.current().ids2root();
                if length(curr_path) == obj.path_length;
                    p = [p; curr_path];
                end
                i.next();
            end
            obj.paths = unique(p,'rows');
        end
    end
    
    methods(Access = 'protected')
        function addChannels(obj,current_channel)
            root_channels = current_channel.ids2root();
            if length(root_channels) < obj.path_length
                channel_nbghood = obj.channelNeighbourhood(current_channel.id);
                next_channels = exclude(channel_nbghood,root_channels);
                for ch = next_channels
                    curr_nbg = IdList(ch);
                    current_channel.add(curr_nbg);
                    obj.addChannels(curr_nbg);
                end
            end
        end
        
        function nbg = channelNeighbourhood(obj,chid)
            nbg = NAps.channelNeighbours(obj.channel_matrix,chid)';
        end
    end
end