-makelib xcelium_lib/xil_defaultlib -sv \
  "C:/Xilinx/Vivado/2018.2/data/ip/xpm/xpm_cdc/hdl/xpm_cdc.sv" \
  "C:/Xilinx/Vivado/2018.2/data/ip/xpm/xpm_memory/hdl/xpm_memory.sv" \
-endlib
-makelib xcelium_lib/xpm \
  "C:/Xilinx/Vivado/2018.2/data/ip/xpm/xpm_VCOMP.vhd" \
-endlib
-makelib xcelium_lib/xil_defaultlib \
  "../../../bd/Game_Design/ipshared/ab8c/hdl/myip_v1_0_S00_AXI.v" \
  "../../../bd/Game_Design/ipshared/ab8c/hdl/myip_v1_0.v" \
  "../../../bd/Game_Design/ip/Game_Design_myip_0_1/sim/Game_Design_myip_0_1.v" \
-endlib
-makelib xcelium_lib/microblaze_v10_0_7 \
  "../../../../Lab_5_152_B3.srcs/sources_1/bd/Game_Design/ipshared/b649/hdl/microblaze_v10_0_vh_rfs.vhd" \
-endlib
-makelib xcelium_lib/xil_defaultlib \
  "../../../bd/Game_Design/ip/Game_Design_microblaze_0_0/sim/Game_Design_microblaze_0_0.vhd" \
-endlib
-makelib xcelium_lib/axi_lite_ipif_v3_0_4 \
  "../../../../Lab_5_152_B3.srcs/sources_1/bd/Game_Design/ipshared/cced/hdl/axi_lite_ipif_v3_0_vh_rfs.vhd" \
-endlib
-makelib xcelium_lib/lib_cdc_v1_0_2 \
  "../../../../Lab_5_152_B3.srcs/sources_1/bd/Game_Design/ipshared/ef1e/hdl/lib_cdc_v1_0_rfs.vhd" \
-endlib
-makelib xcelium_lib/interrupt_control_v3_1_4 \
  "../../../../Lab_5_152_B3.srcs/sources_1/bd/Game_Design/ipshared/8e66/hdl/interrupt_control_v3_1_vh_rfs.vhd" \
-endlib
-makelib xcelium_lib/axi_gpio_v2_0_19 \
  "../../../../Lab_5_152_B3.srcs/sources_1/bd/Game_Design/ipshared/c193/hdl/axi_gpio_v2_0_vh_rfs.vhd" \
-endlib
-makelib xcelium_lib/xil_defaultlib \
  "../../../bd/Game_Design/ip/Game_Design_axi_gpio_0_0/sim/Game_Design_axi_gpio_0_0.vhd" \
-endlib
-makelib xcelium_lib/xil_defaultlib \
  "../../../bd/Game_Design/ip/Game_Design_clk_wiz_0_0/Game_Design_clk_wiz_0_0_clk_wiz.v" \
  "../../../bd/Game_Design/ip/Game_Design_clk_wiz_0_0/Game_Design_clk_wiz_0_0.v" \
-endlib
-makelib xcelium_lib/lib_pkg_v1_0_2 \
  "../../../../Lab_5_152_B3.srcs/sources_1/bd/Game_Design/ipshared/0513/hdl/lib_pkg_v1_0_rfs.vhd" \
-endlib
-makelib xcelium_lib/lib_srl_fifo_v1_0_2 \
  "../../../../Lab_5_152_B3.srcs/sources_1/bd/Game_Design/ipshared/51ce/hdl/lib_srl_fifo_v1_0_rfs.vhd" \
-endlib
-makelib xcelium_lib/axi_uartlite_v2_0_21 \
  "../../../../Lab_5_152_B3.srcs/sources_1/bd/Game_Design/ipshared/a15e/hdl/axi_uartlite_v2_0_vh_rfs.vhd" \
-endlib
-makelib xcelium_lib/xil_defaultlib \
  "../../../bd/Game_Design/ip/Game_Design_axi_uartlite_0_0/sim/Game_Design_axi_uartlite_0_0.vhd" \
-endlib
-makelib xcelium_lib/mdm_v3_2_14 \
  "../../../../Lab_5_152_B3.srcs/sources_1/bd/Game_Design/ipshared/5125/hdl/mdm_v3_2_vh_rfs.vhd" \
-endlib
-makelib xcelium_lib/xil_defaultlib \
  "../../../bd/Game_Design/ip/Game_Design_mdm_1_0/sim/Game_Design_mdm_1_0.vhd" \
-endlib
-makelib xcelium_lib/proc_sys_reset_v5_0_12 \
  "../../../../Lab_5_152_B3.srcs/sources_1/bd/Game_Design/ipshared/f86a/hdl/proc_sys_reset_v5_0_vh_rfs.vhd" \
-endlib
-makelib xcelium_lib/xil_defaultlib \
  "../../../bd/Game_Design/ip/Game_Design_rst_clk_wiz_0_100M_0/sim/Game_Design_rst_clk_wiz_0_100M_0.vhd" \
-endlib
-makelib xcelium_lib/generic_baseblocks_v2_1_0 \
  "../../../../Lab_5_152_B3.srcs/sources_1/bd/Game_Design/ipshared/b752/hdl/generic_baseblocks_v2_1_vl_rfs.v" \
-endlib
-makelib xcelium_lib/axi_infrastructure_v1_1_0 \
  "../../../../Lab_5_152_B3.srcs/sources_1/bd/Game_Design/ipshared/ec67/hdl/axi_infrastructure_v1_1_vl_rfs.v" \
-endlib
-makelib xcelium_lib/axi_register_slice_v2_1_17 \
  "../../../../Lab_5_152_B3.srcs/sources_1/bd/Game_Design/ipshared/6020/hdl/axi_register_slice_v2_1_vl_rfs.v" \
-endlib
-makelib xcelium_lib/fifo_generator_v13_2_2 \
  "../../../../Lab_5_152_B3.srcs/sources_1/bd/Game_Design/ipshared/7aff/simulation/fifo_generator_vlog_beh.v" \
-endlib
-makelib xcelium_lib/fifo_generator_v13_2_2 \
  "../../../../Lab_5_152_B3.srcs/sources_1/bd/Game_Design/ipshared/7aff/hdl/fifo_generator_v13_2_rfs.vhd" \
-endlib
-makelib xcelium_lib/fifo_generator_v13_2_2 \
  "../../../../Lab_5_152_B3.srcs/sources_1/bd/Game_Design/ipshared/7aff/hdl/fifo_generator_v13_2_rfs.v" \
-endlib
-makelib xcelium_lib/axi_data_fifo_v2_1_16 \
  "../../../../Lab_5_152_B3.srcs/sources_1/bd/Game_Design/ipshared/247d/hdl/axi_data_fifo_v2_1_vl_rfs.v" \
-endlib
-makelib xcelium_lib/axi_crossbar_v2_1_18 \
  "../../../../Lab_5_152_B3.srcs/sources_1/bd/Game_Design/ipshared/15a3/hdl/axi_crossbar_v2_1_vl_rfs.v" \
-endlib
-makelib xcelium_lib/xil_defaultlib \
  "../../../bd/Game_Design/ip/Game_Design_xbar_0/sim/Game_Design_xbar_0.v" \
-endlib
-makelib xcelium_lib/lmb_v10_v3_0_9 \
  "../../../../Lab_5_152_B3.srcs/sources_1/bd/Game_Design/ipshared/78eb/hdl/lmb_v10_v3_0_vh_rfs.vhd" \
-endlib
-makelib xcelium_lib/xil_defaultlib \
  "../../../bd/Game_Design/ip/Game_Design_dlmb_v10_0/sim/Game_Design_dlmb_v10_0.vhd" \
  "../../../bd/Game_Design/ip/Game_Design_ilmb_v10_0/sim/Game_Design_ilmb_v10_0.vhd" \
-endlib
-makelib xcelium_lib/lmb_bram_if_cntlr_v4_0_15 \
  "../../../../Lab_5_152_B3.srcs/sources_1/bd/Game_Design/ipshared/92fd/hdl/lmb_bram_if_cntlr_v4_0_vh_rfs.vhd" \
-endlib
-makelib xcelium_lib/xil_defaultlib \
  "../../../bd/Game_Design/ip/Game_Design_dlmb_bram_if_cntlr_0/sim/Game_Design_dlmb_bram_if_cntlr_0.vhd" \
  "../../../bd/Game_Design/ip/Game_Design_ilmb_bram_if_cntlr_0/sim/Game_Design_ilmb_bram_if_cntlr_0.vhd" \
-endlib
-makelib xcelium_lib/blk_mem_gen_v8_4_1 \
  "../../../../Lab_5_152_B3.srcs/sources_1/bd/Game_Design/ipshared/67d8/simulation/blk_mem_gen_v8_4.v" \
-endlib
-makelib xcelium_lib/xil_defaultlib \
  "../../../bd/Game_Design/ip/Game_Design_lmb_bram_0/sim/Game_Design_lmb_bram_0.v" \
  "../../../bd/Game_Design/sim/Game_Design.v" \
-endlib
-makelib xcelium_lib/xil_defaultlib \
  glbl.v
-endlib

