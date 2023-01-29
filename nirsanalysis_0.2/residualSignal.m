function subject_data = residualSignal(subject_data,data_name,design_name,res_postfix,regr_object)

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
    % Date: 2014-06-22 19:18:00
    % Packaged: 2017-04-27 17:58:45
cnames = regr_object.getProperty('experiment').getProperty('category').tags(1);
ctoks = regr_object.getProperty('experiment').getProperty('category').extract({':','trigger_token'}).toArray;

[~,si] = sort(ctoks);
cnames = [cnames(si); {'constant'}];

for s = subject_data.subjects()
    betas = [];
    for c = 1:length(cnames)
        betas = [betas; regr_object.get({'betas',data_name,cnames{c},s})];
    end
    X = subject_data.getSubjectData(s,data_name);
    D = [subject_data.getSubjectData(s,design_name) ones(size(X,1),1)];
    Xres = zeros(size(X));
    for j = 1:size(X,2)        
        Xres(:,j) = X(:,j) - D*betas(:,j);
    end
    subject_data = subject_data.addSubjectData(s,[data_name res_postfix],Xres);
end
