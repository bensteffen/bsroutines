function x1 = mergesmoothly(merge_dim,merge_width,varargin)


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
    % Date: 2015-11-12 17:27:47
    % Packaged: 2017-04-27 17:58:13
switch merge_dim
    case 1
        coln = size(varargin{1},2);
        if ~all(cellfun(@(x) size(x,2) == coln,varargin))
            error('mergesmoothly: Input must have the same number of channels');
        end

        x1 = varargin{1};
        for i = 2:length(varargin)
            x2 = varargin{i};
            [n1,n2] = deal(size(x1,1),size(x2,1));
            n = n1 + n2;

            [bl1,bl2] = deal(mean(x1(end-merge_width+1:end,:)),mean(x2(1:merge_width,:)));
            bl = mean([bl1; bl2]);
            bl = repmat(bl,[n 1]);

            x1 = [x1; zeros(n2,coln)];
            x2 = [zeros(n1,coln); x2];

            env = repmat(abs(tanh(((1:n) - n1)/(0.5*merge_width)))',[1 coln]);
            x1 = env.*(x1+x2-bl)+bl;
        end
    case 2
        varargin = cellfun(@(x) x',varargin,'UniformOutput',false);
        x1 = mergesmoothly(1,merge_width,varargin{:})';
end