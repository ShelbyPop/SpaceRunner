`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Reference Book: 
// Chu, Pong P.
// Wiley, 2008
// "FPGA Prototyping by Verilog Examples: Xilinx Spartan-3 Version" 
// 
// Adapted for the Basys 3 by David J. Marion
// Comments by David J. Marion
//
// FOR USE WITH AN FPGA THAT HAS A 100MHz CLOCK SIGNAL ONLY.
// VGA Mode
// 640x480 pixels VGA screen with 25MHz pixel rate based on 60 Hz refresh rate
// 800 pixels/line * 525 lines/screen * 60 screens/second = ~25.2M pixels/second
//
// A 25MHz signal will suffice. The Basys 3 has a 100MHz signal available, so a
// 25MHz tick is created for syncing the pixel counts, pixel tick, horiz sync, 
// vert sync, and video on signals.
//////////////////////////////////////////////////////////////////////////////////

module vga_controller(
    input clk_100MHz,   // Basys 3 Master Clock
    input reset,        // System Reset
    output video_on,    // Active Video Region
    output hsync,       // Horizontal Sync
    output vsync,       // Vertical Sync
    output p_tick,      // Pixel Tick Pulse
    output [9:0] x,     // X Coordinate
    output [9:0] y      // Y Coordinate
    );

    // Standard 640x480 Parameters
    localparam HD = 640; localparam HF = 48; localparam HB = 16; localparam HR = 96;
    localparam HMAX = 799;
    localparam VD = 480; localparam VF = 10; localparam VB = 33; localparam VR = 2;
    localparam VMAX = 524;

    // 1. GENERATE TICK ENABLE (Safe 25MHz Strobe)
    // We generate a 1-cycle pulse every 4 clocks.
    reg [1:0] clk_div;
    always @(posedge clk_100MHz or posedge reset)
        if(reset) clk_div <= 0;
        else clk_div <= clk_div + 1;

    // tick_en is HIGH for exactly 10ns every 40ns. 
    // This removes the glitch because we don't use it as a clock edge.
    wire tick_en = (clk_div == 0);
    assign p_tick = tick_en;

    // 2. COUNTERS (Synchronous to 100MHz, Gated by tick_en)
    reg [9:0] h_count_reg, v_count_reg;
    reg h_sync_reg, v_sync_reg;

    always @(posedge clk_100MHz or posedge reset) begin
        if(reset) begin
            h_count_reg <= 0; v_count_reg <= 0;
            h_sync_reg <= 0; v_sync_reg <= 0;
        end
        else if (tick_en) begin // <--- THE FIX: Update only when Enable is High
            // Horizontal
            if(h_count_reg == HMAX) h_count_reg <= 0;
            else h_count_reg <= h_count_reg + 1;
            
            // Vertical
            if(h_count_reg == HMAX) begin
                if(v_count_reg == VMAX) v_count_reg <= 0;
                else v_count_reg <= v_count_reg + 1;
            end
            
            // Sync
            h_sync_reg <= (h_count_reg >= (HD+HB) && h_count_reg <= (HD+HB+HR-1));
            v_sync_reg <= (v_count_reg >= (VD+VB) && v_count_reg <= (VD+VB+VR-1));
        end
    end

    // 3. OUTPUTS
    assign hsync = h_sync_reg;
    assign vsync = v_sync_reg;
    assign x = h_count_reg;
    assign y = v_count_reg;
    assign video_on = (h_count_reg < HD) && (v_count_reg < VD);

endmodule
