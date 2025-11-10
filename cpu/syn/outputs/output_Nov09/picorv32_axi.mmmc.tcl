#################################################################################
#
# Created by Genus(TM) Synthesis Solution 23.14-s090_1 on Sun Nov 09 13:53:59 EST 2025
#
#################################################################################

## library_sets
create_library_set -name default_emulate_libset_max \
    -timing { /ip/tsmc/tsmc16adfp/stdcell/CCS/N16ADFP_StdCellss0p72v125c_ccs.lib \
              /ip/tsmc/tsmc16adfp/stdcell/CCS/N16ADFP_StdCellff0p88vm40c_ccs.lib \
              /ip/tsmc/tsmc16adfp/stdcell/CCS/N16ADFP_StdCelltt0p8v25c_ccs.lib \
              /ip/tsmc/tsmc16adfp/sram/NLDM/N16ADFP_SRAM_ss0p72v0p72v125c_100a.lib \
              /ip/tsmc/tsmc16adfp/sram/NLDM/N16ADFP_SRAM_ff0p88v0p88vm40c_100a.lib \
              /ip/tsmc/tsmc16adfp/sram/NLDM/N16ADFP_SRAM_tt0p8v0p8v25c_100a.lib \
              /ip/tsmc/tsmc16adfp/stdio/NLDM/N16ADFP_StdIOss0p72v1p62v125c.lib \
              /ip/tsmc/tsmc16adfp/stdio/NLDM/N16ADFP_StdIOff0p88v1p98vm40c.lib \
              /ip/tsmc/tsmc16adfp/stdio/NLDM/N16ADFP_StdIOtt0p8v1p8v25c.lib }

## opcond
create_opcond -name default_emulate_opcond \
    -process 1.0 \
    -voltage 0.72 \
    -temperature 125.0

## timing_condition
create_timing_condition -name default_emulate_timing_cond_max \
    -opcond default_emulate_opcond \
    -library_sets { default_emulate_libset_max }

## rc_corner
create_rc_corner -name default_emulate_rc_corner \
    -temperature 125.0 \
    -pre_route_res 1.0 \
    -pre_route_cap 1.0 \
    -pre_route_clock_res 0.0 \
    -pre_route_clock_cap 0.0 \
    -post_route_res {1.0 1.0 1.0} \
    -post_route_cap {1.0 1.0 1.0} \
    -post_route_cross_cap {1.0 1.0 1.0} \
    -post_route_clock_res {1.0 1.0 1.0} \
    -post_route_clock_cap {1.0 1.0 1.0} \
    -post_route_clock_cross_cap {1.0 1.0 1.0}

## delay_corner
create_delay_corner -name default_emulate_delay_corner \
    -early_timing_condition { default_emulate_timing_cond_max } \
    -late_timing_condition { default_emulate_timing_cond_max } \
    -early_rc_corner default_emulate_rc_corner \
    -late_rc_corner default_emulate_rc_corner

## constraint_mode
create_constraint_mode -name default_emulate_constraint_mode \
    -sdc_files { syn/outputs/output_Nov09/picorv32_axi.default_emulate_constraint_mode.sdc }

## analysis_view
create_analysis_view -name default_emulate_view \
    -constraint_mode default_emulate_constraint_mode \
    -delay_corner default_emulate_delay_corner

## set_analysis_view
set_analysis_view -setup { default_emulate_view } \
                  -hold { default_emulate_view }
