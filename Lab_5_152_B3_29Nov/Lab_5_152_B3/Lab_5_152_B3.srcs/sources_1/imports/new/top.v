`timescale 1ns / 1ps

module top(
    input  clk_100MHz,       
    input  reset,            // btnC
    input  start,            // btnL
    input  wire up,          // btnU
    input  wire down,        // btnD
    
    output [6:0] seg,
    output [3:0] an,
    output       dp,
    
    output hsync,            
    output vsync,            
    output [11:0] rgb        
    );
    
    // ---------------------------------------------------------
    // Wires
    // ---------------------------------------------------------
    wire w_reset, w_start, w_up, w_down;
    wire w_video_on, w_p_tick;
    wire w_hsync, w_vsync;
    wire [9:0] w_x, w_y;
    wire btn_hz_clk; // debouncing clock
    
    reg  [11:0] rgb_reg;
    wire [11:0] rgb_next;
    
    // Processor Registers
    wire [31:0] w_reg_player_pos, w_reg_gamestate;
    wire [31:0] w_reg_plat0_pos, w_reg_plat1_pos, w_reg_plat2_pos, w_reg_plat3_pos, w_reg_plat4_pos;

    // GPU Buses
    wire [31:0] w_reg_GPU_bus0;   // Player Sprite
    wire [31:0] w_reg_GPU_bus1;   // Enemy Pos/Type
    wire [31:0] w_reg_GPU_bus2;   // Enemy Sprite
    wire [31:0] w_reg_GPU_bus3;   // Bullet 0
    wire [31:0] w_reg_GPU_bus4;   // Bullet 1
    wire [31:0] w_reg_GPU_bus5;   // Bullet 2
    wire [31:0] w_reg_GPU_bus6;   // 6th Platform (Plat index 5)
    wire [31:0] w_reg_GPU_bus7;   // Score

    // VGA Sync (Active Low)
    assign hsync = ~w_hsync;
    assign vsync = ~w_vsync;
    
    // ---------------------------------------------------------
    // Inputs & Debounce
    // ---------------------------------------------------------
    btn_debounce d_rst   (.clk(btn_hz_clk), .btn(reset), .btn_out(w_reset));   
    btn_debounce d_start (.clk(btn_hz_clk), .btn(start), .btn_out(w_start));
    btn_debounce d_up    (.clk(btn_hz_clk), .btn(up),    .btn_out(w_up));
    btn_debounce d_down  (.clk(btn_hz_clk), .btn(down),  .btn_out(w_down));
    
    // Buttons sent to MicroBlaze ([3]=Start, [2]=Reset, [1]=Down, [0]=Up)
    wire [31:0] w_buttons;
    assign w_buttons = {28'b0, w_start, w_reset, w_down, w_up};
    
    // ---------------------------------------------------------
    // VGA Controller
    // ---------------------------------------------------------
    vga_controller vga(
        .clk_100MHz(clk_100MHz),
        .reset(1'b0),
        .video_on(w_video_on),
        .hsync(w_hsync),
        .vsync(w_vsync),
        .p_tick(w_p_tick),
        .x(w_x),
        .y(w_y)
    );
                       
    // ---------------------------------------------------------
    // Pixel Generator (MERGED)
    // ---------------------------------------------------------
    pixel_gen pg(
        .clk(clk_100MHz),
        .video_on(w_video_on),
        .x(w_x),
        .y(w_y),
        .rgb(rgb_next),

        // Game State
        .reg_player_pos(w_reg_player_pos),
        .reg_gamestate(w_reg_gamestate),

        // Platforms (0-4 Standard, 5 via Bus6)
        .reg_plat0_pos(w_reg_plat0_pos), 
        .reg_plat1_pos(w_reg_plat1_pos),
        .reg_plat2_pos(w_reg_plat2_pos), 
        .reg_plat3_pos(w_reg_plat3_pos),
        .reg_plat4_pos(w_reg_plat4_pos), 
        .reg_plat5_pos(w_reg_GPU_bus6), 

        // GPU Buses
        .reg_GPU_bus0(w_reg_GPU_bus0),    // Player Sprite
        .reg_GPU_bus1(w_reg_GPU_bus1),    // Enemy Pos
        .reg_GPU_bus2(w_reg_GPU_bus2),    // Enemy Sprite
        .reg_GPU_bus3(w_reg_GPU_bus3),    // Bullet 0
        .reg_GPU_bus4(w_reg_GPU_bus4),    // Bullet 1
        .reg_GPU_bus5(w_reg_GPU_bus5)     // Bullet 2
    );
   
    // ---------------------------------------------------------
    // Clocks
    // ---------------------------------------------------------
    clock_manager clk_mgr(
        .clk(clk_100MHz),
        .one_hz_clk(),      // unused
        .fast_hz_clk(),     // unused
        .btn_hz_clk(btn_hz_clk)
    );          
    
    // Pixel Pipeline
    always @(posedge clk_100MHz) begin
        if (w_p_tick)
            rgb_reg <= rgb_next;
    end
    assign rgb = rgb_reg;
    
    // ---------------------------------------------------------
    // 7-Segment Score
    // ---------------------------------------------------------
    counter_basys u_counter_basys (
        .clk(clk_100MHz),
        .reset(1'b0), 
        .score_bus(w_reg_GPU_bus7),
        .seg(seg),
        .an(an),
        .dp(dp)
    );
    
    // ---------------------------------------------------------
    // MicroBlaze Wrapper
    // ---------------------------------------------------------
    Game_Design_wrapper mb_system (
        .clk_100MHz(clk_100MHz),          
        .gpio_rtl_0_tri_i(w_vsync), 
        .reg_inputs_0(w_buttons),
        
        .reg_player_pos_0(w_reg_player_pos),
        .reg_plat0_pos_0(w_reg_plat0_pos),
        .reg_plat1_pos_0(w_reg_plat1_pos),
        .reg_plat2_pos_0(w_reg_plat2_pos),
        .reg_plat3_pos_0(w_reg_plat3_pos),
        .reg_plat4_pos_0(w_reg_plat4_pos),
        .reg_gamestate_0(w_reg_gamestate),

        .reg_GPU_bus0_0(w_reg_GPU_bus0),
        .reg_GPU_bus1_0(w_reg_GPU_bus1),
        .reg_GPU_bus2_0(w_reg_GPU_bus2),
        .reg_GPU_bus3_0(w_reg_GPU_bus3),
        .reg_GPU_bus4_0(w_reg_GPU_bus4),
        .reg_GPU_bus5_0(w_reg_GPU_bus5),
        .reg_GPU_bus6_0(w_reg_GPU_bus6), 
        .reg_GPU_bus7_0(w_reg_GPU_bus7),
        
        .reset_rtl_0(1'b0),
        .reset_rtl_0_0(1'b1),
        .uart_rtl_0_rxd(1'b1),
        .uart_rtl_0_txd() 
    );
endmodule