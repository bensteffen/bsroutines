classdef PlotView < CompositeView
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
    % Date: 2014-10-02 18:09:25
    % Packaged: 2017-04-27 17:58:23
    properties(Access = 'protected')
        xdata_name;
        ydata_name;
        model;
        submodel;
    end
    
    methods
        function obj = PlotView(id,controller,model_name,xdata_name,ydata_name)
            obj@CompositeView(id,controller);
            
            obj.model = controller.models.entry(model_name);
            obj.xdata_name = xdata_name;
            obj.ydata_name = ydata_name;

            obj.subcontroller.addModel(PlotModel());
            obj.submodel = obj.subcontroller.models.entry('plotmodel');
            
            obj.h = uipanel('Units','normalized','BorderType','none');
            
            av = AxesView('axes',obj.subcontroller);
            ev1 = EditPropertyView('edit_xlim',obj.subcontroller,'plotmodel','x-limit',@str2num,@stringify);
            ev2 = EditPropertyView('edit_ylim',obj.subcontroller,'plotmodel','y-limit',@str2num,@stringify);
            
            obj.add(av);
            obj.add(ev1);
            obj.add(ev2);
            
            a = GuiAlignment(2,obj.h);
            a.add(av);
            b = GuiAlignment(1,a.h);
            a.add(b);
            b.add(ev1);
            b.add(ev2);
            a.realign([9 1]);
            
            obj.update();
        end
        
        function updateSelf(obj)
            x = obj.model.getState(obj.xdata_name);
            y = obj.model.getState(obj.ydata_name);
            obj.submodel.setInput('x',x);
            obj.submodel.setInput('y',y);
            obj.submodel.setDefault('x-limit',ifel(isempty(x),[0 1],minmax(x(:))));
            obj.submodel.setDefault('y-limit',ifel(isempty(y),[0 1],minmax(y(:))));
            obj.submodel.updateOutput();
        end
    end
end