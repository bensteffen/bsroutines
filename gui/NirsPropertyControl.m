classdef NirsPropertyControl < handle
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
    % Date: 2013-03-08 18:45:16
    % Packaged: 2017-04-27 17:58:23
    properties(Access = 'protected')
        hdl_;
        prop_info_;
        edit_str_;
    end
    
    methods
        function obj = NirsPropertyControl(prop_name,prop_info,parent)
            obj.prop_info_ = prop_info;
            obj.hdl_.name = uicontrol('Style','text',...
                                      'String',prop_name,...
                                      'Units','normalized',...
                                      'Position',[0 .5 1 .5],...
                                      'Parent',parent...
                                      );
            obj.hdl_.edit = uicontrol('Style','edit',...
                                      'String',stringify(prop_info.default),...
                                      'Units','normalized',...
                                      'Position',[0 0 .5 .5],...
                                      'Parent',parent,...
                                      'Callback',@userAction...
                                      );
            obj.hdl_.dflt = uicontrol('Style','PushButton',...
                                      'String','Default',...
                                      'Units','normalized',...
                                      'Position',[.5 0 .5 .5],...
                                      'Parent',parent,...
                                      'Callback',@userAction...
                                      );
            obj.edit_str_ = get(obj.hdl_.edit,'String');
            function userAction(h,evd)
                switch h
                    case obj.hdl_.edit
                        str = get(h,'String');
                        try
                            val = eval(str);
                            if obj.prop_info_.test_fcn_handle(val);
                                obj.edit_str_ = get(obj.hdl_.edit,'String');
                            else
                                errordlg(obj.prop_info_.error_str);
                                set(h,'String',obj.edit_str_);
                            end
                        catch err
                            errordlg(sprintf('Invalid syntax: %s',str))
                        end
                    case obj.hdl_.dflt
                        set(obj.hdl_.edit,'String',stringify(obj.prop_info_.default));
                end
            end
        end
    end
end