classdef ChannelWithNeighbours < IdList
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
    % Date: 2014-06-21 11:27:24
    % Packaged: 2017-04-27 17:58:52
    methods
        function obj = ChannelWithNeighbours(probeset,only_existing)
            if nargin < 2
                only_existing = true;
            end
            chmx = probeset.channelMatrix();
            chs = chmx(~isnan(chmx(:)));
            for ch = chs'
                nbgs = NAps.channelNeighbours(chmx,ch,only_existing)';
                obj.add(IdItem(ch,nbgs));
            end
        end
    end
end