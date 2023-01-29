function nirsplaner

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
    % Date: 2017-04-27 15:29:51
    % Packaged: 2017-04-27 17:58:54
scr_sz = valueat(get(0,'ScreenSize'),[3 4]);

settingfig = GuiFigure('NirsPlaner - Settings',plainfig,'Position',[45+0.4*scr_sz(1) 80 0.3*scr_sz(1) scr_sz(2)-200]);
scroll_alg = ListScrolling('settings.scroll_panel',settingfig);

head_fig = figure('Name','NirsPlaner - Display','Color','w','Position',[30 80 0.4*scr_sz(1) scr_sz(2)-200]);
head_alg = MatrixAlignment(head_fig);

% models
head_model   = NirsPlaner.HeadModel('head_model');
probe_list   = Model.List('probe_list');
nirs_style   = NirsPlaner.MarkerModel('nirs_marker_sytle');% add_marker_styles;
nirs_style.addToInput('marker_3d_shape','e',cylinderPatch(5,1,'FaceColor','r','EdgeColor','none'));
nirs_style.addToInput('marker_3d_shape','d',cylinderPatch(5,1,'FaceColor','b','EdgeColor','none'));
probe_writer = NirsPlaner.ProbeWriter('probe_writer',probe_list,head_fig);

head_model.setInput('scale_factor',1.01);
head_model.setInput('template_name','Colin27(570mm)');
head_model.updateOutput();

% views
head_setview = View.ModelInputs('head_setview',head_model,'title','Head Settings');
head_viewer  = NirsPlaner.HeadView('head_view','head_model');
view_sets    = View.ModelInputs('head_viewsets',head_viewer,'title','View Settings');
head_size_v  = View.StateItem('head_size_view',head_model,'head_size','state2string',@(x) sprintf('%s cm',stringify(x)));
writer_sets  = View.ModelInputs('write_setview',probe_writer,'title','Write Settings');
write_push   = View.PushSignal('write_push',probe_writer,'start_writing','Write coordinate files');
exdisp_push  = View.PushSignal('export_display',probe_writer,'export_display','Save display as picture');

plist_view   = NirsPlaner.NirsProbeListView('plist_view',probe_list,scroll_alg);
nirs_probe_factory = ModelFactory(@(id_)NirsPlaner.NirsProbe(id_,'head_model') ...
                                  ,'2d_coordinate_file',fullfile(NirsPlaner.Global().planer_path,'xy','ETG4000-3x5probe1.txt') ...
                                  ,'2d_coordinate_transformation',{''} ...
                                  );
plist_view.addFactory('optode arrangement',nirs_probe_factory);

head_setview.show();
 head_viewer.show();
   view_sets.show();
 head_size_v.show();
  plist_view.show();
 writer_sets.show();
  write_push.show();
 exdisp_push.show();

c = Controller();
c.subscribeModel(head_model);
c.subscribeModel(probe_list);
c.subscribeModel(nirs_style);
c.subscribeModel(probe_writer);
c.subscribeModel(head_viewer);
c.subscribeView(head_setview);
c.subscribeView(view_sets);
c.subscribeView(head_size_v);
c.subscribeView(plist_view);
c.subscribeView(writer_sets);
c.subscribeView(write_push);
c.subscribeView(exdisp_push);

head_alg.addElement(1,1,head_viewer.h);
scroll_alg.appendElement(head_setview.id,head_setview);
scroll_alg.appendElement(head_size_v.id,head_size_v,40);
scroll_alg.appendElement(view_sets.id,view_sets);
scroll_alg.appendElement(plist_view.id,plist_view,200);
scroll_alg.appendElement(writer_sets.id,writer_sets);
scroll_alg.appendElement(write_push.id,write_push,40);
scroll_alg.appendElement(exdisp_push.id,exdisp_push,40);

% scale_factor 0.775 0.852 0.912
% headsz [mm]  541   570   610
head_model.setInput('scale_factor',1);
head_model.setInput('template_name','Colin27(570mm)');
head_model.updateOutput();