%Disclaimer of Warranty (from http://www.gnu.org/licenses/). 
%THERE IS NO WARRANTY FOR THE PROGRAM, TO THE EXTENT PERMITTED BY APPLICABLE LAW.
%EXCEPT WHEN OTHERWISE STATED IN WRITING THE COPYRIGHT HOLDERS AND/OR OTHER PARTIES 
%PROVIDE THE PROGRAM "AS IS" WITHOUT WARRANTY OF ANY KIND, EITHER EXPRESSED OR IMPLIED,
%INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR
%A PARTICULAR PURPOSE. THE ENTIRE RISK AS TO THE QUALITY AND PERFORMANCE OF THE PROGRAM
%IS WITH YOU. SHOULD THE PROGRAM PROVE DEFECTIVE, YOU ASSUME THE COST OF ALL NECESSARY
%SERVICING, REPAIR OR CORRECTION.

%Author: Florian Haeussinger (florian.haeussinger@med.uni-tuebingen.de)
%Date: 23-Apr-2012 18:12:50


function defaults = NAnaT_DEFAULTS

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
    % Date: 2017-04-10 18:10:00
    % Packaged: 2017-04-27 17:58:43
defaults.experiment.name = 'fNIRS-Experiment';
defaults.experiment.subjects2skip = [];
defaults.experiment.events2skip = {[],[]};
defaults.experiment.time_series = '<__EMPTY__>';
defaults.experiment.category = '<__EMPTY__>';
defaults.experiment.contrast = '<__EMPTY__>';
defaults.experiment.group = '<__EMPTY__>';
defaults.experiment.roi = '<__EMPTY__>';

defaults.subject_data.read_directory = '';
defaults.subject_data.file_name_filter = {'','',''};
defaults.subject_data.subject_keyword = 'S';
defaults.subject_data.read_type = 'etg4000';

defaults.reader.file_name = '';
defaults.reader.variable_name = '';
defaults.reader.read_type = 'etg4000';

defaults.functor.function_handle = @bandpass;
defaults.functor.parameters = {};
defaults.functor.input_names = {};
defaults.functor.output_names = {};

defaults.hemodynamic_response.hr_handle = @NAhr.hrGamma;
defaults.hemodynamic_response.derivation_level = 0;
defaults.hemodynamic_response.kernel_length = 32;
defaults.hemodynamic_response.peak_time = 6;
defaults.hemodynamic_response.peak_dispersion = 1;
defaults.hemodynamic_response.undershoot_time = 16;
defaults.hemodynamic_response.undershoot_dispersion = 1;
defaults.hemodynamic_response.ratio_response2undershoot = 6;
defaults.hemodynamic_response.onset = 0;

defaults.event_related_average.interval = [0 30];
defaults.event_related_average.pre_time = 2;
defaults.event_related_average.linear_detrend = 'off';
defaults.event_related_average.peak_window = [0 30];
defaults.event_related_average.average_window = [0 30];
defaults.event_related_average.peak_detection_sensitivity = 1e-3;

defaults.event_related_average2.interval = [0 30];
defaults.event_related_average2.baseline_interval = [-2 0];
defaults.event_related_average2.baseline_method = @(x,bl) x-bl;
defaults.event_related_average2.linear_detrend = 'off';
defaults.event_related_average2.peak_window = [];
defaults.event_related_average2.average_window = [];
defaults.event_related_average2.peak_detection_sensitivity = [];
defaults.event_related_average2.single_trial_mode = false;

defaults.event_averager.interval = [-1 30];
defaults.event_averager.baseline_interval = [-1 1];

defaults.regression.event_duration = 0;
defaults.regression.standardize_hrf = 'off';
defaults.regression.global_regressors = {};
defaults.regression.channel_wise_regressors = {};
defaults.regression.event_related_regressors = '<__EMPTY__>';
defaults.regression.event_related_hrfamps = '';

defaults.statistics.correction_method = 'none';
defaults.statistics.alpha_level = 0.05;
defaults.statistics.levene_alpha_level = 0.05;
defaults.statistics.ttest2_variance_type = 'levene';

defaults.probeset.dimension = [];
defaults.probeset.optode_distance = 30;
defaults.probeset.transformation = {};
defaults.probeset.brain_coord_file = '';
defaults.probeset.xy_coord_file = '';
defaults.probeset.optode_channel_assignment = 'off';
defaults.probeset.anatomic_assignment_type = 'brodmann';
defaults.probeset.template_name = 'Colin27';
defaults.probeset.anatomic_assignment_column = [];
defaults.probeset.assignment_probability_column = [];

defaults.plot_tool.color_map = 'braincmap2';
defaults.plot_tool.color_limit = [];
defaults.plot_tool.color_gap = [];
defaults.plot_tool.global_scale = [];
defaults.plot_tool.era_mark = [];
defaults.plot_tool.era_plot_style = 'probeset';
defaults.plot_tool.standard_score = 'off';
defaults.plot_tool.statistic_map_values = 'test_statistic';
defaults.plot_tool.show_peaks = 'on';
defaults.plot_tool.show_probeset = 'on';
defaults.plot_tool.show_head = 'off';
defaults.plot_tool.show_colorbar = 'off';
defaults.plot_tool.map_type = 'map';
defaults.plot_tool.values2map = {};
defaults.plot_tool.tests2map = {};
defaults.plot_tool.probesets2map = {};
defaults.plot_tool.row_names = {};
defaults.plot_tool.column_names = {};
defaults.plot_tool.probesets = '<__EMPTY__>';
defaults.plot_tool.view_angles = [90 90];
defaults.plot_tool.plot_parent = [];

defaults.event.event_interval = [0 12];
defaults.event.average_interval = [0 12];
defaults.event.peak_interval = [0 12];
defaults.event.baseline_interval = [-2 0];
defaults.event.trigger_type = 'start';
defaults.event.save_mode = 'raw';

defaults.interpolation.probesets = '<__EMPTY__>';
defaults.interpolation.gui = 'off';
defaults.interpolation.variance_threshold = 3;
defaults.interpolation.detection_method = 'within_subject_variance';
defaults.interpolation.data2interp = {};
defaults.interpolation.probesets2interp = {};
