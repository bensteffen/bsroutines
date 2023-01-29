classdef Gui < hgsetget  
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
    % Date: 2012-11-27 14:00:34
    % Packaged: 2017-04-27 17:58:22
    properties(Access = 'protected')
        flg; % flags
        prm; % parameters
        hdl; % handles
        mrg; % margins
        uid;
    end
    
    methods
        function uid_handle = guiDataHandle(obj)
            uid_handle = obj.uid;
        end
    end
    
    methods(Access = 'protected')
        function obj = Gui()
            obj.flg.done = false;
            obj.mrg.left = 0.05;
            obj.mrg.right = 0.05;
            obj.mrg.bottom = 0.05;
            obj.mrg.top = 0.05;
            obj.mrg.between = 0.01;
            obj.mrg.screen_size = getScreenSize();
            obj.uid = GuiData();
        end
    end
    
    methods(Abstract = true)
        gui_data = show(obj);
    end
end