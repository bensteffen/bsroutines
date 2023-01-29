% function nirsexport

c = Controller();

etgdir   = ExEtgDirectory();
etgread  = ExEtgRead     ();
etgtbl   = ExEtgTable    ();
etgwrite = ExEtgWrite    ();

c.subscribeModel(etgdir  );
c.subscribeModel(etgread );
c.subscribeModel(etgtbl  );
c.subscribeModel(etgwrite);

mainfig = plainfig('Name','ETG4000 Export Tool');

views = IdList();
views.add(View.Input.File   ('editdir'   ,etgdir  ,'directory'       ,'display_name','TBL directory ='   ,'mode','file','filter_spec',{'ETG4000Export.TBL','Select TBL-file'}));
views.add(View.Input.File   ('editexdir' ,etgwrite,'export_directory','display_name','export directory =','mode','dir'));
views.add(View.Input.Edit   ('editfntpl' ,etgwrite,'fname_template'  ,'display_name','file name template ='));
views.add(View.Input.Boolean('checkprobe',etgwrite,'split_probes'));
views.add(View.Input.Options('exporttype',etgwrite,'export_type'));
views.add(View.Tab          ('tableview' ,etgtbl));
views.add(View.PushSignal   ('pushexport',etgtbl,'start_export','Export'));
views.add(View.Waitbar      ('waitbar'));

va = MatrixAlignment(mainfig);
iviews = Iter(views);
for v = iviews
    c.subscribeView(v);
    v.show();
    va.addElement(iviews.i,1,v);
end
va.heights = [40 40 40 40 40 1 40 40];
va.realign();


