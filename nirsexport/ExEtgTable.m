classdef ExEtgTable < Model.Tab & View.Abstract
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
    % Date: 2016-04-11 11:00:48
    % Packaged: 2017-04-27 17:58:53
    methods
        function obj = ExEtgTable()
            obj@Model.Tab('etgtable');
            obj.models.add(Model.Empty('etgdir'));
            obj.addSignal(StateSignal('start_export'));
            obj.setInput('id_selection_column',1);
        end
        
        function update(obj)
            if obj.models.entry('etgdir').stateOk('table')
                tab = obj.models.lastEntry().getState('table');
                obj.setInput('table_data',tab);
                obj.setInput('column_names',{'TBL-ID','ID','Comment','Comment1','Comment2','Date/Time','Duration'});
                obj.setInput('column_format',{'char','char','char','char','char','char','char'});
                obj.setOutput('display_data',tab);
                obj.updateOutput();
            end
        end
    end
end