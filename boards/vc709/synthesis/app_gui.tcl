# Vivado Launch Script

#### Change design settings here #######
set design top
set rtl_top top
set sim_top board
set device xc7vx690t-2-ffg1761
set bit_settings v7_xt_conn_bit_rev1_0.xdc

########################################

# Project Settings
create_project -name ${design} -force -dir "./runs" -part ${device}
set_property source_mgmt_mode DisplayOnly [current_project]

set_property top ${rtl_top} [current_fileset]


#  if {$LOOPBACK_ONLY} {
#    puts "Using DMA Loopback design with no DDR3 or Ethernet"
#    set_property verilog_define { {DMA_LOOPBACK=1} {USE_PVTMON=1} } [current_fileset]
#  } elseif {$BASE_ONLY} {
#    puts "Using PCIe, DMA, DDR3, and Virtual FIFO, but no Ethernet"
#    set_property verilog_define { {USE_DDR3_FIFO=1} {BASE_ONLY=1} {USE_PVTMON=1} } [current_fileset]
#  } elseif {$NO_DDR3} {
#    puts "Using PCIe, DMA, Ethernet, but no DDR3"
#    set_property verilog_define { {USE_XPHY=1} {USE_PVTMON=1} } [current_fileset]
#  } else {
#    puts "Using full Targeted Reference Design, with DDR3 and Ethernet"
    set_property verilog_define { {USE_DDR3_FIFO=1} {USE_XPHY=1} {USE_PVTMON=1} } [current_fileset]
#  }

# Project Constraints
#  if {$LOOPBACK_ONLY} {
#    add_files -fileset constrs_1 -norecurse ../constraints/v7_xt_conn_trd_loopback.xdc
#    add_files -fileset constrs_1 -norecurse ../constraints/${bit_settings}
#  } elseif {$BASE_ONLY} {
#    add_files -fileset constrs_1 -norecurse ../constraints/v7_xt_conn_trd_base.xdc
#    add_files -fileset constrs_1 -norecurse ../constraints/${bit_settings}
#  } elseif {$NO_DDR3} {
#    add_files -fileset constrs_1 -norecurse ../constraints/v7_xt_xgemac_xphy.xdc
#    add_files -fileset constrs_1 -norecurse ../constraints/v7_xt_conn_trd_noddr3.xdc
#    add_files -fileset constrs_1 -norecurse ../constraints/${bit_settings}
#  } else {
    # FULL case
#    add_files -fileset constrs_1 -norecurse ../constraints/v7_xt_xgemac_xphy.xdc
#    add_files -fileset constrs_1 -norecurse ../constraints/v7_xt_conn_trd.xdc
#    add_files -fileset constrs_1 -norecurse ../constraints/${bit_settings}
    add_files -fileset constrs_1 -norecurse ../constraints/xilinx_pcie3_7x_ep_x8g3_VC709.xdc
#    add_files -fileset constrs_1 -norecurse ../constraints/xilinx_pcie3_7x_ep_x8g3_SUME.xdc
#  }


  # Project Design Files from IP Catalog (comment out IPs using legacy Coregen cores)
#  read_ip -files {../ip_catalog/pcie3_x8_ip/pcie3_x8_ip.xci}  
  
#  if {!$LOOPBACK_ONLY && $NO_DDR3} {
#    read_ip -files {../ip_catalog/axis_ic_wr/axis_ic_wr.xci} 
#    read_ip -files {../ip_catalog/axis_ic_rd/axis_ic_rd.xci} 
#  }
  
#  if {!$LOOPBACK_ONLY && !$BASE_ONLY} {
#    read_ip -files {../ip_catalog/ten_gig_eth_mac_axi_st_ip/ten_gig_eth_mac_axi_st_ip.xci} 
#    read_ip -files {../ip_catalog/ten_gig_eth_pcs_pma_ip/ten_gig_eth_pcs_pma_ip.xci} 
#    read_ip -files {../ip_catalog/ten_gig_eth_pcs_pma_ip_shared_logic_in_core/ten_gig_eth_pcs_pma_ip_shared_logic_in_core.xci} 
#  }
    read_ip -files {../ip_catalog/pcie3_7x_0/pcie3_7x_0.xci} 
  
#  if {!$LOOPBACK_ONLY && !$BASE_ONLY} {
#    read_verilog "../rtl/network_path/rx_interface.v"
#    read_verilog "../rtl/network_path/network_path_shared.v"
#    read_verilog "../rtl/network_path/network_path.v"
#  }
  
  
#  if {!$LOOPBACK_ONLY} {
#    read_verilog "../rtl/gen_chk/crc32_D32_wrapper.v"
#    read_verilog "../rtl/gen_chk/hdr_crc_checker.v"
#    read_verilog "../rtl/gen_chk/hdr_crc_insert.v"
#    read_verilog "../rtl/gen_chk/axi_stream_gen.v"
#    read_verilog "../rtl/gen_chk/axi_stream_crc_gen_check.v"
#  }
  
#  read_verilog "../rtl/pipe_clock.v"
  read_verilog "../rtl/top.v"
  read_verilog "../rtl/pcie/EP_MEM.v"
  read_verilog "../rtl/pcie/PIO.v"
  read_verilog "../rtl/pcie/PIO_EP.v"
  read_verilog "../rtl/pcie/PIO_EP_MEM_ACCESS.v"
  read_verilog "../rtl/pcie/PIO_INTR_CTRL.v"
  read_verilog "../rtl/pcie/PIO_RX_ENGINE.v"
  read_verilog "../rtl/pcie/PIO_TO_CTRL.v"
  read_verilog "../rtl/pcie/PIO_TX_ENGINE.v"
  read_verilog "../rtl/pcie/pcie_app_7vx.v"
  read_verilog "../rtl/pcie/support/pcie3_7x_0_pipe_clock.v"
  read_verilog "../rtl/pcie/support/pcie3_7x_0_support.v"
    
  generate_target {synthesis simulation} [get_ips]


#Setting Synthesis options
set_property strategy Flow_PerfOptimized_High [get_runs synth_1]
#Setting Implementation options
set_property steps.phys_opt_design.is_enabled true [get_runs impl_1]

# Pick best strategy for different runs
set_property strategy Performance_Explore [get_runs impl_1]


# Set OOC for DMA for best timing results
#  create_fileset -blockset -define_from dma_back_end_axi dma_back_end_axi

  # Constrain DMA during OOC synthesis
#  create_fileset -constrset dma_constraints
#  add_files -fileset dma_constraints -norecurse ../constraints/dma_back_end_axi_ooc.xdc
#  add_files -fileset dma_back_end_axi [get_files dma_back_end_axi_ooc.xdc]
#  set_property USED_IN {out_of_context synthesis implementation} [get_files dma_back_end_axi_ooc.xdc]
#  set_property strategy Flow_PerfOptimized_High [get_runs dma_back_end_axi_synth_1]

####################
# Set up Simulations
#set_property top ${sim_top} [get_filesets sim_1]
#set_property include_dirs { ../testbench ../testbench/dsport ../testbench/include ../rtl/gen_chk ./} [get_filesets sim_1]

#  if {$LOOPBACK_ONLY} {
#    set_property verilog_define { {USE_PIPE_SIM=1} {SIMULATION=1} {DMA_LOOPBACK=1} } [get_filesets sim_1]
#  } elseif {$BASE_ONLY} {
#    set_property verilog_define { {USE_PIPE_SIM=1} {SIMULATION=1} {USE_DDR3_FIFO=1} {BASE_ONLY=1} {x4Gb=1} {sg107E=1} {x8=1}} [get_filesets sim_1]
#  } elseif {$NO_DDR3} {
#    set_property verilog_define { {USE_PIPE_SIM=1} {SIMULATION=1} {USE_XPHY=1} {NW_PATH_ENABLE=1} } [get_filesets sim_1]
#  } else {
#    set_property verilog_define { {USE_PIPE_SIM=1} {SIMULATION=1} {USE_DDR3_FIFO=1} {USE_XPHY=1} {NW_PATH_ENABLE=1} {x4Gb=1} {sg107E=1} {x8=1}} [get_filesets sim_1]
#  }
#
# Vivado Simulator settings
#set_property -name xsim.simulate.xsim.more_options -value {-testplusarg TESTNAME=basic_test} -objects [get_filesets sim_1]
#set_property xsim.simulate.runtime {200us} [get_filesets sim_1]
#if {$LOOPBACK_ONLY || $NO_DDR3} {
#    set_property XSIM.TCLBATCH "../../../../scripts/xsim_wave_loopback.tcl" [get_filesets sim_1]
## FULL or BASE
#} else {
#    set_property XSIM.TCLBATCH "../../../../scripts/xsim_wave.tcl" [get_filesets sim_1]
#}

# Default to MTI
#set_property target_simulator ModelSim [current_project]

# MTI settings
#set_property modelsim.simulate.runtime {200us} [get_filesets sim_1]
#set_property -name modelsim.compile.vlog.more_options -value +acc -objects [get_filesets sim_1]
#set_property -name modelsim.simulate.vsim.more_options -value {+notimingchecks +TESTNAME=basic_test } -objects [get_filesets sim_1]
#set_property compxlib.compiled_library_dir {} [current_project]

#if {$LOOPBACK_ONLY || $NO_DDR3} {
#     set_property modelsim.simulate.custom_udo "../../../../scripts/wave_loopback.do" [get_filesets sim_1]
# FULL or BASE
#} else {
#     set_property modelsim.simulate.custom_udo "../../../../scripts/wave.do" [get_filesets sim_1]
#}

# PCIe TB files (simulation only)
#add_files -fileset sim_1 "../testbench/pipe_clock.v"
#add_files -fileset sim_1 "../testbench/dsport/pci_exp_usrapp_com.v"
#add_files -fileset sim_1 "../testbench/dsport/pci_exp_usrapp_tx.v"
#add_files -fileset sim_1 "../testbench/dsport/pci_exp_usrapp_cfg.v"
#add_files -fileset sim_1 "../testbench/dsport/pci_exp_usrapp_rx.v"
#add_files -fileset sim_1 "../testbench/dsport/xilinx_pcie_3_0_7vx_rp.v"
#add_files -fileset sim_1 "../testbench/board.v"

#add_files -fileset sim_1 "../testbench/pcie3_x8_ip_gt_top_pipe.v"

#if {$LOOPBACK_ONLY || $NO_DDR3} {
#    set_property include_dirs { ../testbench ../testbench/dsport ../testbench/include ../rtl/gen_chk} [get_filesets sim_1]
#
#} else {
#    set_property include_dirs { ../testbench ../testbench/dsport ../testbench/include ../rtl/gen_chk ../ip_catalog/mig_axi_mm_dual/mig_axi_mm_dual/example_design/sim} [get_filesets sim_1]
#  
#}


#if {!$LOOPBACK_ONLY && !$NO_DDR3} {
#    add_files -fileset sim_1 -norecurse ../ip_catalog/mig_axi_mm_dual/mig_axi_mm_dual/example_design/sim/c0_ddr3_model.v
#    add_files -fileset sim_1 -norecurse ../ip_catalog/mig_axi_mm_dual/mig_axi_mm_dual/example_design/sim/c1_ddr3_model.v
#}



