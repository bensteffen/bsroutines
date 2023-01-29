classdef Processor < View.UiComposite
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
    % Date: 2017-03-15 18:10:51
    % Packaged: 2017-04-27 17:58:31
    methods
        function obj = Processor(id,processor,varargin)
            obj@View.UiComposite(id);
            obj.processor = processor;
            obj.models.add(processor);
            obj.addProperty(Input.StringCell('input_selection',{}));
            obj.setProperty('show_close_button',true);
            obj.setProperties(varargin{:});
        end
        
        function update(obj)
        end
    end
    
    methods(Access = 'protected')
        function builtUi(obj)
            title = obj.processor.id;
            input_selection = obj.getProperty('input_selection');
            obj.init_state = obj.processor.copyState('input');
            
            alg = MatrixAlignment(obj.h);
            vi = View.ModelInputs([obj.processor.id '_input'],obj.processor,'input_selection',input_selection,'title',title);
            vi.show();
            for v = Iter(vi)
                v.setProperty('instant_update',false);
            end
            obj.add(vi);
            alg.addElement(1,1,vi,[vi.getProperty('height') 1]);
            obj.title_alg = vi.title_alg;
            
            push_alg = MatrixAlignment(gcf);
            alg.addElement(2,1,push_alg,[40 1]);
            
            push_alg.addElement(1,1,uicontrol('String','Run Process','Callback',@obj.runProcess));
            push_alg.addElement(1,2,uicontrol('String','Discard','Callback',@obj.discardInput));
            if obj.processor.is_reversible
                push_alg.addElement(1,3,uicontrol('String','Undo','Callback',@obj.undoProcess));
                push_alg.widths = [0.5 0.25 0.25];
                push_alg.realign();
            end
            obj.setProperty('height',vi.getProperty('height') + 40);
        end
        
        function runProcess(obj,varargin)
            obj.processor.updateOutput();
        end
        
        function undoProcess(obj,varargin)
            obj.processor.undo();
        end
        
        function discardInput(obj,varargin)
            for in = Iter(obj.init_state)
                obj.processor.setInput(in.id,in.getValue());
            end
            obj.processor.notifyObservers();
        end
        
        function showCloseButton(obj)
            obj.title_alg.addElement(1,2,obj.close_button,[1 20]);
        end
    end
    
    properties(Access = 'protected')
        processor;
        init_state;
        title_alg;
    end
end