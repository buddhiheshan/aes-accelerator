######################################################################

# Created by Genus(TM) Synthesis Solution 23.14-s090_1 on Mon Nov 10 18:02:17 EST 2025

# This file contains the Genus script for design:mux4to1

######################################################################

set_db -quiet information_level 7
set_db -quiet init_lib_search_path {/ip/tsmc/tsmc16adfp/stdcell/CCS /ip/tsmc/tsmc16adfp/sram/NLDM /ip/tsmc/tsmc16adfp/stdio/NLDM /ip/tsmc/tsmc16adfp/pll/LIB}
set_db -quiet design_mode_process no_value
set_db -quiet phys_assume_met_fill 0.0
set_db -quiet map_placed_for_route_early_global false
set_db -quiet phys_use_invs_extraction true
set_db -quiet phys_route_time_out 120.0
set_db -quiet capacitance_per_unit_length_mmmc {}
set_db -quiet resistance_per_unit_length_mmmc {}
set_db -quiet runtime_by_stage {{to_generic 1 11109 0 437} {first_condense 0 11109 0 438} {PBS_Generic_Opt-Post 1 11109 0.9493580000000179 437.949356} {{PBS_Generic-Postgen HBO Optimizations} 0 11109 0.0 437.949356} {PBS_TechMap-Start 0 11110 0.0 438.949356} {{PBS_TechMap-Premap HBO Optimizations} 0 11110 0.0 438.949356} {second_condense 0 11110 0 438} {reify 0 11110 0 439} {global_incr_map 0 11110 0 439} {{PBS_Techmap-Global Mapping} 0 11110 -0.1530480000000125 438.796308} {{PBS_TechMap-Datapath Postmap Operations} 1 11111 1.0 439.796308} {{PBS_TechMap-Postmap HBO Optimizations} 0 11111 -0.001174999999989268 439.795133} {{PBS_TechMap-Postmap Clock Gating} 0 11111 0.0 439.795133} {{PBS_TechMap-Postmap Cleanup} 0 11111 -0.0010190000000420696 439.794114} {PBS_Techmap-Post_MBCI 0 11111 0.0 439.794114} {incr_opt 1 11112 0 440} }
set_db -quiet timing_adjust_tns_of_complex_flops false
set_db -quiet tim_complex_use_dense false
set_db -quiet tim_complex_use_prevs false
set_db -quiet dft_use_ungated_clock_for_testpoint true
set_db -quiet tinfo_tstamp_file .rs_jy5187.tstamp
set_db -quiet metric_enable true
set_db -quiet syn_generic_effort high
set_db -quiet phys_use_segment_parasitics true
set_db -quiet probabilistic_extraction true
set_db -quiet ple_correlation_factors {1.9000 2.0000}
set_db -quiet maximum_interval_of_vias inf
set_db -quiet layer_aware_buffer true
set_db -quiet interconnect_mode wireload
set_db -quiet wireload_mode segmented
set_db -quiet lib_cell:default_emulate_libset_max/N16ADFP_StdCellss0p72v125c_ccs/ISOLOD4BWP16P90LVT .is_isolation_cell true
set_db -quiet lib_cell:default_emulate_libset_max/N16ADFP_StdCellss0p72v125c_ccs/ISOLOD4BWP20P90 .is_isolation_cell true
set_db -quiet lib_cell:default_emulate_libset_max/N16ADFP_StdCellss0p72v125c_ccs/PTBUFFHDCWD1BWP16P90LVT .is_always_on true
set_db -quiet lib_cell:default_emulate_libset_max/N16ADFP_StdCellss0p72v125c_ccs/PTBUFFHDCWD1BWP20P90 .is_always_on true
set_db -quiet lib_cell:default_emulate_libset_max/N16ADFP_StdCellss0p72v125c_ccs/PTBUFFHDCWD4BWP16P90LVT .is_always_on true
set_db -quiet lib_cell:default_emulate_libset_max/N16ADFP_StdCellss0p72v125c_ccs/PTBUFFHDCWD4BWP20P90 .is_always_on true
set_db -quiet lib_cell:default_emulate_libset_max/N16ADFP_StdCellss0p72v125c_ccs/PTBUFFHDCWD8BWP16P90LVT .is_always_on true
set_db -quiet lib_cell:default_emulate_libset_max/N16ADFP_StdCellss0p72v125c_ccs/PTBUFFHDCWD8BWP20P90 .is_always_on true
set_db -quiet lib_cell:default_emulate_libset_max/N16ADFP_StdCellss0p72v125c_ccs/PTINVHDCWD1BWP16P90LVT .is_always_on true
set_db -quiet lib_cell:default_emulate_libset_max/N16ADFP_StdCellss0p72v125c_ccs/PTINVHDCWD1BWP20P90 .is_always_on true
set_db -quiet lib_cell:default_emulate_libset_max/N16ADFP_StdCellss0p72v125c_ccs/PTINVHDCWD4BWP16P90LVT .is_always_on true
set_db -quiet lib_cell:default_emulate_libset_max/N16ADFP_StdCellss0p72v125c_ccs/PTINVHDCWD4BWP20P90 .is_always_on true
set_db -quiet lib_cell:default_emulate_libset_max/N16ADFP_StdCellss0p72v125c_ccs/PTINVHDCWD8BWP16P90LVT .is_always_on true
set_db -quiet lib_cell:default_emulate_libset_max/N16ADFP_StdCellss0p72v125c_ccs/PTINVHDCWD8BWP20P90 .is_always_on true
set_db -quiet wireload_selection wireload_selection:default_emulate_libset_max/N16ADFP_StdCellss0p72v125c_ccs/WireAreaForZero
set_db -quiet operating_condition:default_emulate_libset_max/N16ADFP_StdCellss0p72v125c_ccs/ss0p72v125c .tree_type balanced_tree
set_db -quiet operating_condition:default_emulate_libset_max/N16ADFP_StdCellss0p72v125c_ccs/_nominal_ .tree_type balanced_tree
set_db -quiet operating_condition:default_emulate_libset_max/N16ADFP_StdCellff0p88vm40c_ccs/ff0p88vm40c .tree_type balanced_tree
set_db -quiet operating_condition:default_emulate_libset_max/N16ADFP_StdCellff0p88vm40c_ccs/_nominal_ .tree_type balanced_tree
set_db -quiet operating_condition:default_emulate_libset_max/N16ADFP_StdCelltt0p8v25c_ccs/tt0p8v25c .tree_type balanced_tree
set_db -quiet operating_condition:default_emulate_libset_max/N16ADFP_StdCelltt0p8v25c_ccs/_nominal_ .tree_type balanced_tree
set_db -quiet operating_condition:default_emulate_libset_max/N16ADFP_SRAM_ss0p72v0p72v125c/ssgnp0p72v0p72v125c .tree_type balanced_tree
set_db -quiet operating_condition:default_emulate_libset_max/N16ADFP_SRAM_ss0p72v0p72v125c/_nominal_ .tree_type balanced_tree
set_db -quiet operating_condition:default_emulate_libset_max/N16ADFP_SRAM_ff0p88v0p88vm40c/ffgnp0p88v0p88vm40c .tree_type balanced_tree
set_db -quiet operating_condition:default_emulate_libset_max/N16ADFP_SRAM_ff0p88v0p88vm40c/_nominal_ .tree_type balanced_tree
set_db -quiet operating_condition:default_emulate_libset_max/N16ADFP_SRAM_tt0p8v0p8v25c/tt0p8v0p8v25c .tree_type balanced_tree
set_db -quiet operating_condition:default_emulate_libset_max/N16ADFP_SRAM_tt0p8v0p8v25c/_nominal_ .tree_type balanced_tree
set_db -quiet operating_condition:default_emulate_libset_max/N16ADFP_StdIOss0p72v1p62v125c/ss0p72v1p62v125c .tree_type balanced_tree
set_db -quiet operating_condition:default_emulate_libset_max/N16ADFP_StdIOss0p72v1p62v125c/_nominal_ .tree_type balanced_tree
set_db -quiet operating_condition:default_emulate_libset_max/N16ADFP_StdIOff0p88v1p98vm40c/ff0p88v1p98vm40c .tree_type balanced_tree
set_db -quiet operating_condition:default_emulate_libset_max/N16ADFP_StdIOff0p88v1p98vm40c/_nominal_ .tree_type balanced_tree
set_db -quiet operating_condition:default_emulate_libset_max/N16ADFP_StdIOtt0p8v1p8v25c/tt0p8v1p8v25c .tree_type balanced_tree
set_db -quiet operating_condition:default_emulate_libset_max/N16ADFP_StdIOtt0p8v1p8v25c/_nominal_ .tree_type balanced_tree
set_db -quiet operating_condition:default_emulate_libset_max/n16adfp_pllff0p88v1p98vm40c/ff0p88v1p98vm40c .tree_type best_case_tree
set_db -quiet operating_condition:default_emulate_libset_max/n16adfp_pllff0p88v1p98vm40c/_nominal_ .tree_type balanced_tree
set_db -quiet operating_condition:default_emulate_libset_max/n16adfp_pllss0p72v1p62v125c/ss0p72v1p62v125c .tree_type worst_case_tree
set_db -quiet operating_condition:default_emulate_libset_max/n16adfp_pllss0p72v1p62v125c/_nominal_ .tree_type balanced_tree
set_db -quiet operating_condition:default_emulate_libset_max/n16adfp_plltt0p8v1p8v25c/tt0p8v1p8v25c .tree_type balanced_tree
set_db -quiet operating_condition:default_emulate_libset_max/n16adfp_plltt0p8v1p8v25c/_nominal_ .tree_type balanced_tree
# BEGIN MSV SECTION
# END MSV SECTION
# BEGIN DFT SECTION
set_db -quiet dft_scan_style muxed_scan
set_db -quiet dft_scanbit_waveform_analysis false
# END DFT SECTION
set_db -quiet design:mux4to1 .seq_reason_deleted_internal {}
set_db -quiet design:mux4to1 .qos_by_stage {{to_generic {wns 214748365} {tns 0} {vep 0} {area 10} {cell_count 10} {utilization  0.00} {runtime 1 11109 0 437} }{first_condense {wns -11111111} {tns -111111111} {vep -111111111} {area 15} {cell_count 32} {utilization  0.00} {runtime 0 11109 0 438} }{second_condense {wns -11111111} {tns -111111111} {vep -111111111} {area 15} {cell_count 32} {utilization  0.00} {runtime 0 11110 0 438} }{reify {wns 214748365} {tns 0} {vep 0} {area 4} {cell_count 16} {utilization  0.00} {runtime 0 11110 0 439} }{global_incr_map {wns 214748365} {tns 0} {vep 0} {area 4} {cell_count 16} {utilization  0.00} {runtime 0 11110 0 439} }{incr_opt {wns 214748365} {tns 0} {vep 0} {area 4} {cell_count 16} {utilization  0.00} {runtime 1 11112 0 440} }}
set_db -quiet design:mux4to1 .seq_mbci_coverage 0.0
set_db -quiet design:mux4to1 .hdl_filelist {{default -v2001 {SYNTHESIS} {/home/jy5187/Documents/soc/aes-accelerator/cpu/example/example.v} {/home/jy5187/Documents/soc/aes-accelerator/cpu/example} {}}}
set_db -quiet design:mux4to1 .hdl_user_name mux4to1
set_db -quiet design:mux4to1 .verification_directory fv/mux4to1
set_db -quiet design:mux4to1 .arch_filename /home/jy5187/Documents/soc/aes-accelerator/cpu/example/example.v
set_db -quiet design:mux4to1 .entity_filename /home/jy5187/Documents/soc/aes-accelerator/cpu/example/example.v
set_db -quiet {port:mux4to1/a[3]} .original_name {a[3]}
set_db -quiet {port:mux4to1/a[2]} .original_name {a[2]}
set_db -quiet {port:mux4to1/a[1]} .original_name {a[1]}
set_db -quiet {port:mux4to1/a[0]} .original_name {a[0]}
set_db -quiet {port:mux4to1/b[3]} .original_name {b[3]}
set_db -quiet {port:mux4to1/b[2]} .original_name {b[2]}
set_db -quiet {port:mux4to1/b[1]} .original_name {b[1]}
set_db -quiet {port:mux4to1/b[0]} .original_name {b[0]}
set_db -quiet {port:mux4to1/c[3]} .original_name {c[3]}
set_db -quiet {port:mux4to1/c[2]} .original_name {c[2]}
set_db -quiet {port:mux4to1/c[1]} .original_name {c[1]}
set_db -quiet {port:mux4to1/c[0]} .original_name {c[0]}
set_db -quiet {port:mux4to1/d[3]} .original_name {d[3]}
set_db -quiet {port:mux4to1/d[2]} .original_name {d[2]}
set_db -quiet {port:mux4to1/d[1]} .original_name {d[1]}
set_db -quiet {port:mux4to1/d[0]} .original_name {d[0]}
set_db -quiet {port:mux4to1/sel[1]} .original_name {sel[1]}
set_db -quiet {port:mux4to1/sel[0]} .original_name {sel[0]}
set_db -quiet {port:mux4to1/out[3]} .original_name {out[3]}
set_db -quiet {port:mux4to1/out[2]} .original_name {out[2]}
set_db -quiet {port:mux4to1/out[1]} .original_name {out[1]}
set_db -quiet {port:mux4to1/out[0]} .original_name {out[0]}
# BEGIN PMBIST SECTION
# END PMBIST SECTION
# BEGIN GLO TBR TABLE
set_db -quiet design:mux4to1 .set_boundary_change_new {start restore}
set_db -quiet design:mux4to1 .set_boundary_change_new {finish restore}
# END GLO TBR TABLE
set_db -quiet source_verbose true
#############################################################
#####   FLOW WRITE   ########################################
##
## Written by Genus(TM) Synthesis Solution version 23.14-s090_1
## Generated using: Flowkit 23.16-e002_1
## Written on 18:02:17 10-Nov 2025
#############################################################
#####   Flow Definitions   ##################################

#############################################################
#####   Step Definitions   ##################################


#############################################################
#####   Attribute Definitions   #############################

if {[is_attribute flow_edit_end_steps -obj_type root]} {set_db flow_edit_end_steps {}}
if {[is_attribute flow_edit_start_steps -obj_type root]} {set_db flow_edit_start_steps {}}
if {[is_attribute flow_footer_tcl -obj_type root]} {set_db flow_footer_tcl {}}
if {[is_attribute flow_header_tcl -obj_type root]} {set_db flow_header_tcl {}}
if {[is_attribute flow_metadata -obj_type root]} {set_db flow_metadata {}}
if {[is_attribute flow_setup_config -obj_type root]} {set_db flow_setup_config {HUDDLE {!!map {}}}}
if {[is_attribute flow_step_begin_tcl -obj_type root]} {set_db flow_step_begin_tcl {}}
if {[is_attribute flow_step_check_tcl -obj_type root]} {set_db flow_step_check_tcl {}}
if {[is_attribute flow_step_end_tcl -obj_type root]} {set_db flow_step_end_tcl {}}
if {[is_attribute flow_step_order -obj_type root]} {set_db flow_step_order {}}
if {[is_attribute flow_summary_tcl -obj_type root]} {set_db flow_summary_tcl {}}
if {[is_attribute flow_template_feature_definition -obj_type root]} {set_db flow_template_feature_definition {}}
if {[is_attribute flow_template_type -obj_type root]} {set_db flow_template_type {}}
if {[is_attribute flow_template_tools -obj_type root]} {set_db flow_template_tools {}}
if {[is_attribute flow_template_version -obj_type root]} {set_db flow_template_version {}}
if {[is_attribute flow_user_templates -obj_type root]} {set_db flow_user_templates {}}


#############################################################
#####   Flow History   ######################################

if {[is_attribute flow_user_templates -obj_type root]} {set_db flow_user_templates {}}
if {[is_attribute flow_plugin_steps -obj_type root]} {set_db flow_plugin_steps {}}
if {[is_attribute flow_template_type -obj_type root]} {set_db flow_template_type {}}
if {[is_attribute flow_template_tools -obj_type root]} {set_db flow_template_tools {}}
if {[is_attribute flow_template_version -obj_type root]} {set_db flow_template_version {}}
if {[is_attribute flow_template_feature_definition -obj_type root]} {set_db flow_template_feature_definition {}}
if {[is_attribute flow_remark -obj_type root]} {set_db flow_remark {}}
if {[is_attribute flow_features -obj_type root]} {set_db flow_features {}}
if {[is_attribute flow_feature_values -obj_type root]} {set_db flow_feature_values {}}
if {[is_attribute flow_write_db_args -obj_type root]} {set_db flow_write_db_args {}}
if {[is_attribute flow_write_db_sdc -obj_type root]} {set_db flow_write_db_sdc true}
if {[is_attribute flow_write_db_common -obj_type root]} {set_db flow_write_db_common false}
if {[is_attribute flow_post_db_overwrite -obj_type root]} {set_db flow_post_db_overwrite {}}
if {[is_attribute flow_step_order -obj_type root]} {set_db flow_step_order {}}
if {[is_attribute flow_step_begin_tcl -obj_type root]} {set_db flow_step_begin_tcl {}}
if {[is_attribute flow_step_end_tcl -obj_type root]} {set_db flow_step_end_tcl {}}
if {[is_attribute flow_step_last -obj_type root]} {set_db flow_step_last {}}
if {[is_attribute flow_step_current -obj_type root]} {set_db flow_step_current {}}
if {[is_attribute flow_step_canonical_current -obj_type root]} {set_db flow_step_canonical_current {}}
if {[is_attribute flow_step_next -obj_type root]} {set_db flow_step_next {}}
if {[is_attribute flow_working_directory -obj_type root]} {set_db flow_working_directory .}
if {[is_attribute flow_branch -obj_type root]} {set_db flow_branch {}}
if {[is_attribute flow_caller_data -obj_type root]} {set_db flow_caller_data {}}
if {[is_attribute flow_metrics_snapshot_uuid -obj_type root]} {set_db flow_metrics_snapshot_uuid {}}
if {[is_attribute flow_starting_db -obj_type root]} {set_db flow_starting_db {}}
if {[is_attribute flow_db_directory -obj_type root]} {set_db flow_db_directory dbs}
if {[is_attribute flow_report_directory -obj_type root]} {set_db flow_report_directory reports}
if {[is_attribute flow_log_directory -obj_type root]} {set_db flow_log_directory logs}
if {[is_attribute flow_mail_to -obj_type root]} {set_db flow_mail_to {}}
if {[is_attribute flow_exit_when_done -obj_type root]} {set_db flow_exit_when_done false}
if {[is_attribute flow_mail_on_error -obj_type root]} {set_db flow_mail_on_error false}
if {[is_attribute flow_summary_tcl -obj_type root]} {set_db flow_summary_tcl {}}
if {[is_attribute flow_history -obj_type root]} {set_db flow_history {}}
if {[is_attribute flow_step_last_status -obj_type root]} {set_db flow_step_last_status not_run}
if {[is_attribute flow_step_last_msg -obj_type root]} {set_db flow_step_last_msg {}}
if {[is_attribute flow_run_tag -obj_type root]} {set_db flow_run_tag {}}
if {[is_attribute flow_current_cache -obj_type root]} {set_db flow_current_cache {}}
if {[is_attribute flow_step_order_cache -obj_type root]} {set_db flow_step_order_cache {}}
if {[is_attribute flow_step_results_cache -obj_type root]} {set_db flow_step_results_cache {}}
if {[is_attribute flow_metadata -obj_type root]} {set_db flow_metadata {}}
if {[is_attribute flow_execute_in_global -obj_type root]} {set_db flow_execute_in_global true}
if {[is_attribute flow_overwrite_db -obj_type root]} {set_db flow_overwrite_db false}
if {[is_attribute flow_print_run_information -obj_type root]} {set_db flow_print_run_information false}
if {[is_attribute flow_verbose -obj_type root]} {set_db flow_verbose true}
if {[is_attribute flow_print_run_information_full -obj_type root]} {set_db flow_print_run_information_full false}
if {[is_attribute flow_header_tcl -obj_type root]} {set_db flow_header_tcl {}}
if {[is_attribute flow_footer_tcl -obj_type root]} {set_db flow_footer_tcl {}}
if {[is_attribute flow_init_header_tcl -obj_type root]} {set_db flow_init_header_tcl {}}
if {[is_attribute flow_init_footer_tcl -obj_type root]} {set_db flow_init_footer_tcl {}}
if {[is_attribute flow_edit_start_steps -obj_type root]} {set_db flow_edit_start_steps {}}
if {[is_attribute flow_edit_end_steps -obj_type root]} {set_db flow_edit_end_steps {}}
if {[is_attribute flow_step_last_number -obj_type root]} {set_db flow_step_last_number 0}
if {[is_attribute flow_autoload_applets -obj_type root]} {set_db flow_autoload_applets false}
if {[is_attribute flow_autoload_dir -obj_type root]} {set_db flow_autoload_dir error}
if {[is_attribute flow_skip_auto_db_save -obj_type root]} {set_db flow_skip_auto_db_save true}
if {[is_attribute flow_skip_auto_generate_metrics -obj_type root]} {set_db flow_skip_auto_generate_metrics false}
if {[is_attribute flow_top -obj_type root]} {set_db flow_top {}}
if {[is_attribute flow_hier_path -obj_type root]} {set_db flow_hier_path {}}
if {[is_attribute flow_schedule -obj_type root]} {set_db flow_schedule {}}
if {[is_attribute flow_step_check_tcl -obj_type root]} {set_db flow_step_check_tcl {}}
if {[is_attribute flow_script -obj_type root]} {set_db flow_script {}}
if {[is_attribute flow_yaml_script -obj_type root]} {set_db flow_yaml_script {}}
if {[is_attribute flow_cla_enabled_features -obj_type root]} {set_db flow_cla_enabled_features {}}
if {[is_attribute flow_cla_inject_tcl -obj_type root]} {set_db flow_cla_inject_tcl {}}
if {[is_attribute flow_error_message -obj_type root]} {set_db flow_error_message {}}
if {[is_attribute flow_error_errorinfo -obj_type root]} {set_db flow_error_errorinfo {}}
if {[is_attribute flow_exclude_time_for_init_flow -obj_type root]} {set_db flow_exclude_time_for_init_flow false}
if {[is_attribute flow_error_write_db -obj_type root]} {set_db flow_error_write_db true}
if {[is_attribute flow_advanced_metric_isolation -obj_type root]} {set_db flow_advanced_metric_isolation flow}
if {[is_attribute flow_yaml_root -obj_type root]} {set_db flow_yaml_root {}}
if {[is_attribute flow_yaml_root_dir -obj_type root]} {set_db flow_yaml_root_dir {}}
if {[is_attribute flow_setup_config -obj_type root]} {set_db flow_setup_config {HUDDLE {!!map {}}}}

#############################################################
#####   User Defined Attributes   ###########################

