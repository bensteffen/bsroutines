function editMri(img_path)

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
    % Date: 2012-09-05 14:04:57
    % Packaged: 2017-04-27 17:58:26
mr.hdr0 = spm_vol(img_path);
mr.hdr1 = mr.hdr0;
mr.img0 = spm_read_vols(mr.hdr0);
mr.img1 = mr.img0;

zdim = mr.hdr1.dim(3);
select_types = {'Points','Rectangle','Polygon'};
slice.index = 1;
slice.curr = squeeze(mr.img0(:,:,slice.index));
slice.edited = [];
cts.save = 0;

fh = figure;
hdl.axh = axes('Parent',fh,'Position',[.05 .2 .9 .75],'XTick',[],'YTick',[]);
hdl.slh = uicontrol('Parent',fh,'Units','normalized','Style','slider','Position',[.05 .01 .8 .05],...
                'Value',slice.index,'Min',1,'Max',zdim,'SliderStep',[1/zdim 10/zdim],...
                'Callback',@sliderCallback);
hdl.text.slice = uicontrol('Parent',fh,'Units','normalized','Style','text','Position',[.85 .01 .1 .05],...
                     'String',num2str(slice.index));
hdl.msepopup = uicontrol('Parent',fh,'Units','normalized','Style','popupmenu','Position',[.25 .1 .1 .05],...
                     'String',select_types);
hdl.bts.edit = uicontrol('Parent',fh,'Units','normalized','Style','pushbutton','Position',[.05 .1 .1 .05],...
                     'String','Edit',...
                     'Callback',@editCallback);
hdl.bts.undo = uicontrol('Parent',fh,'Units','normalized','Style','pushbutton','Position',[.5 .1 .1 .05],...
                     'String','Undo',...
                     'Callback',@undoCallback);
hdl.bts.save = uicontrol('Parent',fh,'Units','normalized','Style','pushbutton','Position',[.75 .1 .1 .05],...
                     'String','Save',...
                     'Callback',@saveCallback);
                 

sliderCallback(hdl.slh,[]);


    function sliderCallback(h,event_data)
        slice.index = round(get(h,'Value'));
        set(h,'Value',slice.index);
        set(hdl.text.slice,'String',num2str(slice.index));
        showSlice();
    end

    function showSlice()
        slice.curr = squeeze(mr.img1(:,:,slice.index));
        set(fh,'CurrentAxes',hdl.axh);
        imagesc(slice.curr);
        colormap gray;
    end

    function editCallback(h,event_data)
        switch select_types{get(hdl.msepopup,'Value')}
            case 'Points'
                select_data = impoint(hdl.axh);
            case 'Rectangle'
                select_data = imrect(hdl.axh);
            case 'Polygon'
                select_data = impoly(hdl.axh);
        end
        mask = select_data.createMask();
        v = inputdlg('Set voxels to:');
        if ~isempty(v)
            v = str2num(v{1});
            slice.edited = slice.curr;
            slice.edited(mask) = v;
            mr.img1(:,:,slice.index) = slice.edited;
            showSlice();
        end
    end

    function saveCallback(h,event_data)
        if cts.save > 0
            p = addPrefix(mr.hdr1.fname,'edited');
        else
            p = mr.hdr1.fname;
        end
        p = inputdlg('Save image as:','',1,{p});
        if ~isempty(p)
            p = p{1};
            mr.hdr1.fname = p;
            spm_write_vol(mr.hdr1,mr.img1);
        end
    end

    function undoCallback(h,event_data)
        
    end
end




