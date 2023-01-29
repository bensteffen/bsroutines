classdef NirsProbeset < NirsObject
    %
    % Hold and analyzes the spatial positions of measurement probes and
    % channels
    %
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
    % Date: 2017-04-10 18:35:32
    % Packaged: 2017-04-27 17:58:44
    
    properties
        transformation_handles_;
        chcoord_data_;
    end
    
    methods
        function obj = NirsProbeset(varargin)
            obj = obj@NirsObject(varargin);
            obj.transformation_handles_ = TagMatrix({'string'});
            obj.transformation_handles_ = obj.transformation_handles_.add({'flip_up2down'}, @flipud);
            obj.transformation_handles_ = obj.transformation_handles_.add({'flip_left2right'}, @fliplr);
            obj.transformation_handles_ = obj.transformation_handles_.add({'transpose'}, @transpose);
            obj.transformation_handles_ = obj.transformation_handles_.add({'rotate90'}, @rot90);
        end
        
        function channels = channels(obj)
            channel_matrix = obj.createChannelMatrix();
            channels = channel_matrix(~isnan(channel_matrix));
        end
        
        function matrix = channelMatrix(obj)
            channel_matrix = obj.createChannelMatrix();
            matrix = obj.applyTransformations(channel_matrix);
        end
        
        function matrix = optodeMatrix(obj)
            optode_matrix = obj.createOptodeMatrix();
            matrix = obj.applyTransformations(optode_matrix);
        end
        
        function coord_data = coordData(obj)
            coord_data = obj.chcoord_data_;
        end
        
        function roi_channels = findRoiChannels(obj,roi_name)
            if ~isempty(obj.getProperty('brain_coord_file'))
                labels = groupLabels(obj.coordData(),obj.getProperty('anatomic_assignment_type'));
                hit = strcmp(labels(:,1),roi_name);
                if any(hit)
                    roi_channels = labels{hit,2};
                else
                    error('NirsProbeset.findRoiChannels: ROI "%s" not found.',roi_name);
                end
            else
                error('NirsProbeset.findRoiChannels: To find ROI channels a channel coordinate file is needed.');
            end
        end
        
        function showAnatomicLabels(obj)
            groupLabels(obj.coordData(),obj.getProperty('anatomic_assignment_type'));
            fprintf('\n');
        end
    end
    
    methods(Access = 'protected')
        function matrix = createOptodeMatrix(obj)
            % +1: emitter
            % -1: detector
            matrix = [];
            optode_dimension = obj.getProperty('dimension');
            if ~isempty(optode_dimension)
                total_dim = 2*optode_dimension - 1;
                matrix = NaN(total_dim);
                first_optode = +1;
                M = optode_dimension(1);
                optode_vec = 2*mod(1:M,2) - 1;
                if first_optode == -1
                    optode_vec = -optode_vec;
                end
                optode_counter = 1;
                [optI,optJ] = meshgrid(1:2:total_dim(1),1:2:total_dim(2));
                for n = 1:numel(optI)
                    matrix(optI(n),optJ(n)) = optode_vec(optode_counter);
                    optode_counter = optode_counter + 1;
                    if ~mod(n,optode_dimension(1))
                        optode_counter = 1;
                        optode_vec = -optode_vec;
                    end
                end
            end
        end
        
        function matrix = createChannelMatrix(obj)
            matrix = [];
            if isempty(obj.getProperty('xy_coord_file'))
                optode_dimension = obj.getProperty('dimension');
                if ~isempty(optode_dimension)
                    total_dim = 2*optode_dimension - 1;
                    matrix = NaN(total_dim);
                    [coeffI,coeffJ] = meshgrid(1:2:total_dim(1),2:2:total_dim(2));
                    for n = 1:numel(coeffI)
                        matrix(coeffI(n),coeffJ(n)) = 0;
                    end
                    [coeffI,coeffJ] = meshgrid(2:2:total_dim(1),1:2:total_dim(2));
                    for n = 1:numel(coeffI)
                        matrix(coeffI(n),coeffJ(n)) = 0;
                    end
                    matrix(~isnan(matrix)) = 1:sum(sum(~isnan(matrix)));
                end
            else
                xy = cell2mat(file2cell(obj.getProperty('xy_coord_file')));
                d = mindiff(xy);
                ij = voxelsToOrigin(round(xy/d));
                ij = fliplr(ij);
                ij(:,1) = max(ij(:,1)) - ij(:,1);
                ij = ij + 1;
                matrix = NaN(max(ij));
                matrix(voxel2index(ij,size(matrix))) = 1:size(ij,1);
            end
        end
        
        function matrix = applyTransformations(obj, matrix)
            transformations = obj.getProperty('transformation');
            trans_avbl = obj.transformation_handles_.tags(1);
            for i = 1:length(transformations)
                if any(strcmp(transformations{i},trans_avbl))
                    fh = obj.transformation_handles_.get({transformations{i}});
                else
                    error(['NirsProbeset.applyTransformations: Transformation "' transformations{i} '" not available.']);
                end
                matrix = fh(matrix);
            end
        end
        
        function obj = update(obj,prop_name,prop_value)
            switch prop_name
                case 'brain_coord_file'
                    if ~isempty(prop_value)
                        [~,~,ext] = fileparts(prop_value);
                        switch ext
                            case '.xls'
                                obj.chcoord_data_ = extractMniCoordsXls(prop_value ...
                                                                       ,'label_types',obj.getProperty('anatomic_assignment_type') ...
                                                                       ,'opt_ch_assignment',onoff2flag(obj.getProperty('optode_channel_assignment')) ...
                                                                       ,'template_name',obj.getProperty('template_name') ...
                                                                       ,'label_column',obj.getProperty('anatomic_assignment_column') ...
                                                                       ,'label_prob_column',obj.getProperty('assignment_probability_column') ...
                                                                       );
                            otherwise
                                [obj.chcoord_data_,file_template_name] = readCoordFile(prop_value ...
                                                                                      ,'label_types',obj.getProperty('anatomic_assignment_type') ...
                                                                                      ,'opt_ch_assignment',onoff2flag(obj.getProperty('optode_channel_assignment')) ...
                                                                                      ,'template_name',obj.getProperty('template_name') ...
                                                                                      );
                                if ~isempty(file_template_name)
                                    obj = obj.setProperty('template_name',file_template_name);
                                end
                        end
                        obj.showAnatomicLabels();
                    end 
                case 'dimension'
                    if ~isempty(prop_value) && ~isempty(obj.getProperty('brain_coord_file'))
                        d = obj.getProperty('dimension');
                        if  d(1)*(d(2)-1) + d(2)*(d(1)-1) ~= obj.chcoord_data_.ch_number
                            error('NirsProbeset.setProperty(''dimension''): Probeset dimension and channel number in channel coordinate file must fit.');
                        end
                    end
            end
        end
    end

    methods(Static = true)
        function prop_info = getPropertyInfos()
            prop_info.dimension.test_fcn_handle = @(x) isempty(x) || (isnumeric(x) && isvector(x) && length(x) == 2 && x(1) > 0 && x(2) > 0);
            prop_info.dimension.error_str = 'Dimension must be a numeric vector with two positive elements.';
            
            prop_info.optode_distance.test_fcn_handle = @(x) isnumeric(x) && isscalar(x) && x > 0;
            prop_info.optode_distance.error_str = 'Optode distance [mm] must be a positive scalar';
            
            prop_info.anatomic_assignment_column.test_fcn_handle = @(x) isnumeric(x) && (isempty(x) || (isscalar(x) && x > 0));
            prop_info.optode_distance.error_str = 'anatomic assignment column must be empty or a scalar > 0';
            
            prop_info.assignment_probability_column.test_fcn_handle = @(x) isnumeric(x) && (isempty(x) || (isscalar(x) && x > 0));
            prop_info.optode_distance.error_str = 'assignment probability column must be empty or a scalar > 0';
            
            prop_info.transformation.test_fcn_handle = @(x) iscellstr(x);
            prop_info.transformation.error_str = 'Transformation must be cell string.';
            
            prop_info.brain_coord_file.test_fcn_handle = @(x) exist(fullpath(x),'file');
            prop_info.brain_coord_file.error_str = 'Brain coordinate file not found.';
            
            prop_info.xy_coord_file.test_fcn_handle = @(x) exist(fullpath(x),'file');
            prop_info.xy_coord_file.error_str = 'XY coordinate file not found.';
            
            prop_info.optode_channel_assignment.test_fcn_handle = @(x) any(strcmpi(x,{'on','off'}));
            prop_info.optode_channel_assignment.error_str = 'Optode channel assignment flag must be ''on'' or ''off''.';

            prop_info.anatomic_assignment_type.test_fcn_handle = @(x) (ischar(x) && any(strcmpi(x,{'aal','brodmann'}))) || ( iscellstr(x) && all(cellfun(@(y) any(strcmpi(y,{'aal','brodmann'})),x)) );
            prop_info.anatomic_assignment_type.error_str = 'Assignment type must be ''aal'' or ''brodmann''.';
            
            template_dir = fullfile(fileparts(fileparts(mfilename('fullpath'))),'brainprobeset','templates');
            template_names = sprintf('''%s''',strjoin(nonunicfun(@(x) x{1},strsplit(dircontent(template_dir),'.')),''', '''));
            prop_info.template_name.test_fcn_handle = @(x) exist(fullfile(template_dir,[x '.mat']),'file');
            prop_info.template_name.error_str = ['Must be a valid template name. Available: ' template_names];
            
            prop_info = NirsObject.addHelpTexts('probeset',prop_info);
        end
    end
        
    methods(Access = 'protected', Static = true)
        function keyword = getKeyword()
            keyword = 'probeset';
        end
    end
end