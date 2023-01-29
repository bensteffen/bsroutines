function initroutines(routine_dir)

try
    curr_dir = pwd;
    fprintf('Ciao! Initilizing "%s"...\n',routine_dir);
    
    lastdirs_fname = fullfile(prefdir,'initRoutines.lastdirs.mat');
    if ~exist(lastdirs_fname,'file')
        last_dirs = {};
    else
        load(lastdirs_fname);
    end
    curr_path = strsplit(path,pathsep);
    for i = 1:length(last_dirs)
        if any(strcmp(curr_path,last_dirs{i}))
            fprintf('\tRemove path: %s\n',last_dirs{i});
            rmpath(last_dirs{i});
        end
    end
    
    old_path = strsplit(path,pathsep);
     
    dir_content = dir(fullfile(routine_dir,'*'));
    dir_content = struct2cell(dir_content);
    dir_content = dir_content(1,:)';
    dir_content(strcmp(dir_content,'.') | strcmp(dir_content,'..')) = [];
    routine_folders = dir_content(cellfun(@(x) isdir(fullfile(routine_dir,x)),dir_content));
    routine_folders(cellfun(@(x) length(x) > 1 && strcmp(x(end-1:end),'__'),routine_folders)) = [];
    
    for f = 1:length(routine_folders)
        package_name = routine_folders{f};
        
        fprintf('\tAdd path: %s\n',fullfile(routine_dir,package_name));
            addpath(fullfile(routine_dir,package_name));

        package_info_fname = fullfile(routine_dir,package_name,'package_info.mat');
        if exist(package_info_fname,'file')
            load(package_info_fname);
            if exist('external_packages','var')
                for i = 1:length(external_packages)
                    extpath = fullfile(routine_dir,'external',external_packages{i});
                    fprintf('\tExternal Package "%s"...\n',external_packages{i});
                    if exist(fullfile(extpath,'install.m'),'file');
                        fprintf('\t\tPath: %s\n',extpath);
                        fprintf('\t\tInstalling...\n');
                        cd(extpath);
                        install;
                        cd(curr_dir);
                        fprintf('\t\t... Done!\n');
                    else
                        addpath(extpath);
                        fprintf('\t\tAdd path: %s\n',extpath);
                    end
                end
            end
        end
    end
    new_path = strsplit(path,pathsep);
    n_added = length(new_path) - length(old_path);
    last_dirs = new_path(1:n_added);
    save(fullfile(prefdir,'initRoutines.lastdirs.mat'),'last_dirs');
    fprintf('... Done!\n\n');
    help_adress = 'http://ben-steffen.de/doku.php?id=usersection:psychphys:routines:start';
    fprintf(['For information and help visit our <a href="matlab:web(''%s'',''-browser'')">WIKI</a>\n\n' ...
            '    USER: helpme    PASSWORD: withNIRS\n\n'],help_adress);
catch err
    fprintf('Could not initilize routines (%s)...\n\t%s\n',routine_dir,err.message);
end
