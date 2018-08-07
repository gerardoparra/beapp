function [seg_button_list,seg_button_geometry,seg_ver_geometry,skipline_panel] = beapp_gui_seg_subfunction_prep (current_sub_panel,grp_proc_info)
% spacer for formatting in supergui
extra_space_line = {{'style','text','string',''}};

switch current_sub_panel
    case 'seg_general'
        
        if isempty(grp_proc_info.win_select_n_trials);
            win_select_n_trials_disp_str = 'all';
        else
            win_select_n_trials_disp_str = num2str(grp_proc_info.win_select_n_trials);
        end
        
        % in case there are multiple related module in the future
        seg_mod_inds = find(ismember(grp_proc_info.beapp_toggle_mods.Module_Output_Type,'seg'));
        
        seg_button_list = [{{'style','text','string', 'General BEAPP Segmentation Settings:'}},...
            {{'style','text','string', 'Run Segmentation Module?'}},...
            {{'style','uitable','data', [grp_proc_info.beapp_toggle_mods.Mod_Names(seg_mod_inds),...
            num2cell(grp_proc_info.beapp_toggle_mods.Module_On(seg_mod_inds)), ...
            num2cell(grp_proc_info.beapp_toggle_mods.Module_Export_On(seg_mod_inds))],'tag','seg_mod_sel_table',...
            'ColumnEditable',[false,true,true], 'ColumnName',{'Module','Module On?','Save Module Outputs?'}}},...
            {{'style','text','string', 'General Settings:'}},...
            {{'style','text','string', 'Amplitude-Based Artifact Rejection:'}},...
            {{'style','text','string', 'Type of Data Being Processed:','tag','seg_data_type_prompt'}},...
            {{'style','popupmenu','string', {'baseline','event-related','conditioned baseline'},...
            'tag','segment_type_resp','Value', grp_proc_info.src_data_type}},...
            {{'style','text','string', sprintf(['Threshold for All Amplitude-Based Artifact Removal (uV)', '\n', '(Adjust if Running HAPPE or CSDLP)']),...
            'tag','seg_amp_art_threshold_prompt'}},...
            {{'style','edit','string', num2str(grp_proc_info.art_thresh),...
            'tag','seg_amp_art_threshold_resp'}},...
            {{'style','text','tag','select_number_segs_per_cond_prompt',...
            'string',sprintf(['Enter number of(random) segments to analyze per condition,',...
            '\n', 'or all to analyze all segments (applied post-segment rejection) :'])}},...
            {{'style','edit','string', win_select_n_trials_disp_str,...
            'tag','beapp_win_select_n_trials'}},...
            {{'style','checkbox','string', 'Reject Segments By Amplitude After Segmentation? ',...
            'tag','post_seg_amp_rej','value',grp_proc_info.beapp_reject_segs_by_amplitude}},...
            {{'style','text','string', 'Detrend Segments?','tag','seg_detrend_prompt'}},...
            {{'style','popupmenu','string', {'none','linear detrend','mean detrend'},...
            'tag','segment_detrend_resp','Value', grp_proc_info.segment_linear_detrend+1}},...
            {{'style','checkbox','string', 'HAPPE Segment Rejection (Post-Seg JointProb + Amplitude Based)?',...
            'tag','post_seg_happe_rej','value',grp_proc_info.beapp_happe_segment_rejection}}];
        
        seg_button_geometry = {1 1 1 [.5 .5] [.35 .15 .4 .1] [.35 .15 .5] [.3 .2 .5]};
        seg_ver_geometry = ones(1,length(seg_button_geometry));
        skipline_panel ='off';
        
    case 'seg_evt_condition_codes'
        
        if  grp_proc_info.beapp_event_use_tags_only  == 0
            assumed_max_number_condition_sets = 5; % can let user change if needed
            init_cel_set = {'Event_Cond_Set1','Event_Cond_Set2','Event_Cond_Set3','Event_Cond_Set4','Event_Cond_Set5'};
            
            if ~isequal(grp_proc_info.beapp_event_eprime_values.condition_names,{''})
                
                init_seg_tag_cond_headers = grp_proc_info.beapp_event_eprime_values.condition_names;
                init_seg_tag_evt_codes = cell(assumed_max_number_condition_sets ,size(grp_proc_info.beapp_event_eprime_values.event_codes,1));
                init_seg_tag_evt_codes(:) =deal({[]});
                init_seg_tag_evt_codes(1:size(grp_proc_info.beapp_event_eprime_values.event_codes,2),...
                    1:size(grp_proc_info.beapp_event_eprime_values.event_codes,1))= num2cell(grp_proc_info.beapp_event_eprime_values.event_codes');
                
            else
                init_seg_tag_cond_headers = { 'Condition1', 'Condition2', 'Condition3', 'Condition4', 'Condition5'};
                init_seg_tag_evt_codes = cell(assumed_max_number_condition_sets,5);
                init_seg_tag_evt_codes(:) = deal({[]});
            end
            
            column_format = cell(1,length(init_seg_tag_cond_headers));
            column_format(:) = deal({'numeric'});
            
            seg_button_list = [{{'style','text','string','Segmenting Specifications: Conditioned Baseline/ Event Related Data'}},...
                {{'style','text','string','Enter Condition Names and enter all associated cel codes in the corresponding column (see guide)'}},...
                {{'style','uitable','data', init_seg_tag_evt_codes,'tag','seg_evt_tag_table',...
                'ColumnFormat',column_format,'ColumnEditable',true(1,length(init_seg_tag_cond_headers)),...
                'ColumnName',init_seg_tag_cond_headers,'RowName',init_cel_set}},...
                extra_space_line, ...
                extra_space_line, ...
                {{'style','pushbutton','string', 'Add Condition','CallBack',...
                ['beapp_gui_add_delete_rename_condition_columns(get(findobj(''tag'',''seg_evt_tag_table'')),''add''); ']}},...
                {{'style','pushbutton','string', 'Rename Condition','CallBack',...
                ['beapp_gui_add_delete_rename_condition_columns(get(findobj(''tag'',''seg_evt_tag_table'')),''rename''); ']}},...
                {{'style','pushbutton','string', 'Delete Condition', 'CallBack',...
                ['beapp_gui_add_delete_rename_condition_columns(get(findobj(''tag'',''seg_evt_tag_table'')),''delete''); ']}},...
                extra_space_line];
            
            seg_button_geometry = {1 1 1 1 [.05 .3 .3 .3 .05]};
            seg_ver_geometry=  [1 1 6 1 1];
            skipline_panel ='on';
        elseif grp_proc_info.beapp_event_use_tags_only ==1
            if length(grp_proc_info.beapp_event_eprime_values.condition_names)<=length(grp_proc_info.beapp_event_code_onset_strs)
                cond_names_disp = cell(length(grp_proc_info.beapp_event_code_onset_strs),1);
                cond_names_disp(:) = deal({''});
                cond_names_disp(1:length(grp_proc_info.beapp_event_eprime_values.condition_names)) =...
                    grp_proc_info.beapp_event_eprime_values.condition_names;
            else
                cond_names_disp = cell(length(grp_proc_info.beapp_event_code_onset_strs),1);
                cond_names_disp(:) = deal({grp_proc_info.beapp_event_code_onset_strs{:}});
            end
            
            
            seg_button_list = [{{'style','text','string','Segmenting Specifications: Conditioned Baseline/ Event Related Data'}},...
                {{'style','text','string','Enter Condition Names Associated With Each Tags (Repeated Condition Names are fine, see guide)'}},...
                {{'style','uitable','data', [grp_proc_info.beapp_event_code_onset_strs  cond_names_disp],'tag','seg_evt_tag_cond_table',...
                'ColumnFormat',{'char','char'},'ColumnEditable',[false true],...
                'ColumnName',{'Event Tag Names','Corresponding Condition Names'}}}];
            
            seg_button_geometry = {1 1 1};
            seg_ver_geometry=  [1 1 6];
            skipline_panel ='on';
        end
        
    case 'seg_evt_stm_on_off_info'
        
        empty_10_cel = cell(10,1);
        empty_10_cel(:) = deal({''});
        
        % fill in previous onset settings
        onset_strs_to_disp = empty_10_cel;
        if ~isempty (grp_proc_info.beapp_event_code_onset_strs)
            onset_strs_to_disp (1:length(grp_proc_info.beapp_event_code_onset_strs))= grp_proc_info.beapp_event_code_onset_strs;
        end
        
        % if event related data
        if grp_proc_info.src_data_type == 2
            
            bsl_vis_str = logical_to_on_off_helper(grp_proc_info.evt_trial_baseline_removal);
            
            seg_button_list = [{{'style','text','string',['Enter the event tags that signify stimulus onset below (ex. (stm+)): ']}},...
                {{'style','uitable','data',onset_strs_to_disp,'tag','evt_code_on_off_strs', ...
                'ColumnFormat',{'char'},'ColumnEditable',true,'ColumnName','Onset'}},...
                extra_space_line,...
                {{'style','text','string',sprintf(['Segment Creation: Segment start time \n relative to event marker in seconds (def: -0.100)'])}},...
                {{'style','text','string',sprintf(['Segment Creation: Segment end time  \n relative to event marker in seconds (def: 0.800)'])}},...
                {{'style','edit','string',num2str(grp_proc_info.evt_seg_win_start),'tag','evt_seg_win_start'}},...
                {{'style','edit','string',num2str(grp_proc_info.evt_seg_win_end),'tag','evt_seg_win_end'}},...
                {{'style','checkbox','String','Apply baseline correction (pop_rmbaseline)?','tag','use_bsl_corr','value',...
                grp_proc_info.evt_trial_baseline_removal,'callback', ...
                ['beapp_gui_hide_unneeded_inputs(''use_bsl_corr'',',...
                '{''bsl_startp'',''bsl_startr'',''bsl_endp'',''bsl_endr''},''On'',''NoCompVal'');']}},...
                {{'style','text','string',sprintf(['Baseline Correction: Baseline start time\n', ...
                'relative to event marker in seconds (def: -0.100)']),'tag','bsl_startp',...
                'Visible',bsl_vis_str}},...
                {{'style','text','string',sprintf(['Baseline Correction: Baseline end time \n relative to event marker in seconds (def: 0)']),...
                'tag','bsl_endp','Visible',bsl_vis_str}},...
                {{'style','edit','string',grp_proc_info.evt_trial_baseline_win_start,'tag','bsl_startr','Visible',bsl_vis_str}},...
                {{'style','edit','string',grp_proc_info.evt_trial_baseline_win_end,'tag','bsl_endr','Visible',bsl_vis_str}},...
                {{'style','text', 'string', 'Segment conditions determined by: '}},{{'style','popupmenu','string', {'Event Tags and Condition/Cel Codes','Event Tags Only'},...
                'tag','event_use_tags_only','Value', grp_proc_info.beapp_event_use_tags_only+1}}];
            
            seg_button_geometry = {1 1 1 [.5 .5] [.5 .5] 1 [.5 .5] [.5 .5] [.5 .5]};
            seg_ver_geometry=  [1 5 1 1 1 1 1 1 1];
            
            %             % Segmentiing: Event Related Only
            %             %For event-related data only: Set where to create segments, relative to the event marker of interest
            %             grp_proc_info.evt_seg_win_start = -0.100; % def = -0.100;  start time in seconds for segments, relative to the event marker of interest (ex -0.100, 0)
            %             grp_proc_info.evt_seg_win_end = 0.800;  % def = .800; end time in seconds for segments, relative to the event marker of interest (ex .800, 1)
            %
            %
            %             %Set which event data is baseline
            %             grp_proc_info.evt_trial_baseline_removal = 0; % def = 0; flag on use of pop_rmbaseline in segmentation module.
            %             grp_proc_info.evt_trial_baseline_win_start = -.100; % def = -0.100;  start time in seconds for baseline, relative to the event marker of interest (ex -0.100, 0). Must be within range you've segmented on.
            %             grp_proc_info.evt_trial_baseline_win_end = -.001; % def = -0.100;  start time in seconds for baseline, relative to the event marker of interest (ex -0.100, 0)
            %
            %
            %             % Set which event data to analyze, relative to the event marker of interest (This can be the whole segment, or part of a segment)
            %             grp_proc_info.evt_analysis_win_start = 0.000; % def = -0.100;  start time in seconds for analysis segments, relative to the event marker of interest (ex -0.100, 0)
            %             grp_proc_info.evt_analysis_win_end = 0.800;  % def = .800; end time in seconds for analysis segments, relative to the event marker of interest (ex .800, 1)
            %
        elseif grp_proc_info.src_data_type == 3 % conditioned baseline
            % fill in previous offset settings
            offset_strs_to_disp = empty_10_cel;
            if ~isempty (grp_proc_info.beapp_event_code_offset_strs)
                offset_strs_to_disp (1:length(grp_proc_info.beapp_event_code_offset_strs))= grp_proc_info.beapp_event_code_offset_strs;
            end
            
            seg_button_list = [{{'style','text','string',sprintf(['Enter the event tags that signify onset and offset of conditioned baseline periods.', '\n',...
                'On and off tags for the same condition should be in the same row (ex. (stm+, TRSP))'])}},...
                {{'style','uitable','data', [onset_strs_to_disp,offset_strs_to_disp],'tag','evt_code_on_off_strs', ...
                'ColumnFormat',{'char','char'},'ColumnEditable',[true, true],'ColumnName',{'Onset','Offset'}}},...
                extra_space_line...
                {{'style','text','string', 'Pre-Segmentation Baseline Amplitude Rejection:'}},...
                {{'style','popupmenu','string', {'none','Exclude timepoints with any channels above threshold',...
                'Exclude timepoints with a percentage of channels above threshold'},...
                'tag','bsl_seg_rej_type','Value', grp_proc_info.beapp_baseline_msk_artifact+1,...
                'callback', ['beapp_gui_hide_unneeded_inputs(''bsl_seg_rej_type'',',...
                '{''perc_rej_setting'',''perc_rej_setting_prompt''},''On'',3);']}},...
                {{'style','text','string','Bad Channel Threshold Percentage for Amplitude Rejection (def: .01, for .01%)','tag','perc_rej_setting_prompt',...
                'Visible',logical_to_on_off_helper(isequal(grp_proc_info.beapp_baseline_msk_artifact,2))}},...
                {{'style','edit','string',grp_proc_info.beapp_baseline_rej_perc_above_threshold,...
                'tag','perc_rej_setting','Visible',logical_to_on_off_helper(isequal(grp_proc_info.beapp_baseline_msk_artifact,2))}}...
                {{'style','text','string','Baseline Segment Window Size in Seconds (Segmentation and Analysis):'}},...
                {{'style','edit','string',grp_proc_info.win_size_in_secs,'tag','bsl_seg_win_size'}},...
                {{'style','text', 'string', 'Segment conditions determined by: '}},{{'style','popupmenu','string', {'Event Tags and Condition/Cel Codes','Event Tags Only'},...
                'tag','event_use_tags_only','Value', grp_proc_info.beapp_event_use_tags_only+1}}];
            
            seg_button_geometry = {1 1 1 1 1 [.85 .15] [.85 .15] [.5 .5]};
            seg_ver_geometry = [1 5 1 1 1 1 1 1];
            
        end
        
        skipline_panel ='on';
        
    case 'seg_baseline'
        
        seg_button_list = [ {{'style','text','string', 'General BEAPP Segmentation Settings:'}},...
            extra_space_line...
            {{'style','text','string', 'Pre-Segmentation Baseline Amplitude Rejection:'}},...
            {{'style','popupmenu','string', {'none','Exclude timepoints with any channels above threshold',...
            'Exclude timepoints with a percentage of channels above threshold'},...
            'tag','bsl_seg_rej_type','Value', grp_proc_info.beapp_baseline_msk_artifact+1,...
            'callback', ['beapp_gui_hide_unneeded_inputs(''bsl_seg_rej_type'',',...
            '{''perc_rej_setting'',''perc_rej_setting_prompt''},''On'',3);']}},...
            {{'style','text','string','Bad Channel Threshold Percentage for Amplitude Rejection (def: .01, for .01%)','tag','perc_rej_setting_prompt',...
            'Visible',logical_to_on_off_helper(isequal(grp_proc_info.beapp_baseline_msk_artifact,2))}},...
            {{'style','edit','string',grp_proc_info.beapp_baseline_rej_perc_above_threshold,...
            'tag','perc_rej_setting','Visible',logical_to_on_off_helper(isequal(grp_proc_info.beapp_baseline_msk_artifact,2))}}...
            {{'style','text','string','Baseline Segment Window Size in Seconds (Segmentation and Analysis):'}},...
            {{'style','edit','string',grp_proc_info.win_size_in_secs,'tag','bsl_seg_win_size'}}];
        
        seg_button_geometry = {1 1 1 1 [.85 .15] [.85 .15]};
        seg_ver_geometry = [1 1 1 2 1 1];
        skipline_panel ='on';
end
end