//Copyright 1986-2018 Xilinx, Inc. All Rights Reserved.
//--------------------------------------------------------------------------------
//Tool Version: Vivado v.2018.2.2 (win64) Build 2348494 Mon Oct  1 18:25:44 MDT 2018
//Date        : Tue Nov 25 23:18:11 2025
//Host        : RSA_PC running 64-bit major release  (build 9200)
//Command     : generate_target Game_Design_wrapper.bd
//Design      : Game_Design_wrapper
//Purpose     : IP block netlist
//--------------------------------------------------------------------------------
`timescale 1 ps / 1 ps

module Game_Design_wrapper
   (clk_100MHz,
    gpio_rtl_0_tri_i,
    reg_GPU_bus0_0,
    reg_GPU_bus1_0,
    reg_GPU_bus2_0,
    reg_GPU_bus3_0,
    reg_GPU_bus4_0,
    reg_GPU_bus5_0,
    reg_GPU_bus6_0,
    reg_GPU_bus7_0,
    reg_gamestate_0,
    reg_inputs_0,
    reg_plat0_pos_0,
    reg_plat1_pos_0,
    reg_plat2_pos_0,
    reg_plat3_pos_0,
    reg_plat4_pos_0,
    reg_player_pos_0,
    reset_rtl_0,
    reset_rtl_0_0,
    uart_rtl_0_rxd,
    uart_rtl_0_txd);
  input clk_100MHz;
  input [0:0]gpio_rtl_0_tri_i;
  output [31:0]reg_GPU_bus0_0;
  output [31:0]reg_GPU_bus1_0;
  output [31:0]reg_GPU_bus2_0;
  output [31:0]reg_GPU_bus3_0;
  output [31:0]reg_GPU_bus4_0;
  output [31:0]reg_GPU_bus5_0;
  output [31:0]reg_GPU_bus6_0;
  output [31:0]reg_GPU_bus7_0;
  output [31:0]reg_gamestate_0;
  input [31:0]reg_inputs_0;
  output [31:0]reg_plat0_pos_0;
  output [31:0]reg_plat1_pos_0;
  output [31:0]reg_plat2_pos_0;
  output [31:0]reg_plat3_pos_0;
  output [31:0]reg_plat4_pos_0;
  output [31:0]reg_player_pos_0;
  input reset_rtl_0;
  input reset_rtl_0_0;
  input uart_rtl_0_rxd;
  output uart_rtl_0_txd;

  wire clk_100MHz;
  wire [0:0]gpio_rtl_0_tri_i;
  wire [31:0]reg_GPU_bus0_0;
  wire [31:0]reg_GPU_bus1_0;
  wire [31:0]reg_GPU_bus2_0;
  wire [31:0]reg_GPU_bus3_0;
  wire [31:0]reg_GPU_bus4_0;
  wire [31:0]reg_GPU_bus5_0;
  wire [31:0]reg_GPU_bus6_0;
  wire [31:0]reg_GPU_bus7_0;
  wire [31:0]reg_gamestate_0;
  wire [31:0]reg_inputs_0;
  wire [31:0]reg_plat0_pos_0;
  wire [31:0]reg_plat1_pos_0;
  wire [31:0]reg_plat2_pos_0;
  wire [31:0]reg_plat3_pos_0;
  wire [31:0]reg_plat4_pos_0;
  wire [31:0]reg_player_pos_0;
  wire reset_rtl_0;
  wire reset_rtl_0_0;
  wire uart_rtl_0_rxd;
  wire uart_rtl_0_txd;

  Game_Design Game_Design_i
       (.clk_100MHz(clk_100MHz),
        .gpio_rtl_0_tri_i(gpio_rtl_0_tri_i),
        .reg_GPU_bus0_0(reg_GPU_bus0_0),
        .reg_GPU_bus1_0(reg_GPU_bus1_0),
        .reg_GPU_bus2_0(reg_GPU_bus2_0),
        .reg_GPU_bus3_0(reg_GPU_bus3_0),
        .reg_GPU_bus4_0(reg_GPU_bus4_0),
        .reg_GPU_bus5_0(reg_GPU_bus5_0),
        .reg_GPU_bus6_0(reg_GPU_bus6_0),
        .reg_GPU_bus7_0(reg_GPU_bus7_0),
        .reg_gamestate_0(reg_gamestate_0),
        .reg_inputs_0(reg_inputs_0),
        .reg_plat0_pos_0(reg_plat0_pos_0),
        .reg_plat1_pos_0(reg_plat1_pos_0),
        .reg_plat2_pos_0(reg_plat2_pos_0),
        .reg_plat3_pos_0(reg_plat3_pos_0),
        .reg_plat4_pos_0(reg_plat4_pos_0),
        .reg_player_pos_0(reg_player_pos_0),
        .reset_rtl_0(reset_rtl_0),
        .reset_rtl_0_0(reset_rtl_0_0),
        .uart_rtl_0_rxd(uart_rtl_0_rxd),
        .uart_rtl_0_txd(uart_rtl_0_txd));
endmodule
