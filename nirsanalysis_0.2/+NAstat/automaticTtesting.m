function obj = automaticTtesting(obj,results,varargin)

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
    % Date: 2013-03-14 17:45:16
    % Packaged: 2017-04-27 17:58:53
allnames = varargin;
allnames = allcellcombos(allnames);


for i = 1:size(allnames,1)
   names = allnames(i,:);
   ttest_name = cell2str(names,'.');
   grouptest = cellfun(@(x) ~isempty(strfind(x,'VS')),names);
   if sum(grouptest) == 0
       [val,flag] = structvalue(results,names);
       if flag
           obj = obj.ttest(ttest_name,val);
       end
   elseif sum(grouptest) == 1
        testname = names{grouptest};
        n = findNumberByKeyword(testname,'VS');
        if isempty(n)
            vs = 'VS';
        elseif n == 2
            vs = 'VS2';
        else
            throw(NirsException('NirsStatistics','automaticTtesting','Invalid VS-syntax, use "VS" or "VS2" for group testing.'));
        end
        testnames = strsplit(testname,vs);
        tindex = find(grouptest);
        names{tindex} = testnames{1};
        [val1,f1] = structvalue(results,names);
        names{tindex} = testnames{2};
        [val2,f2] = structvalue(results,names);
        if f1 && f2
            switch vs
                case 'VS'
                    obj = obj.ttest(ttest_name,val1,val2);
                case 'VS2'
                    obj = obj.ttest2(ttest_name,val1,val2);
            end
        end
   end
end