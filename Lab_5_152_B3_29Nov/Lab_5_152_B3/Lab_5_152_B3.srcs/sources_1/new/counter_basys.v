`timescale 1ns / 1ps

// Drives the Basys3 4-digit 7-seg display from a 32-bit BCD word.
//
// score_bus layout (from C):
//   [3:0]   = ones      (BCD 0-9)
//   [7:4]   = tens      (BCD 0-9)
//   [11:8]  = hundreds  (BCD 0-9)
//   [15:12] = thousands (BCD 0-9)
//   [31:16] = unused
//
// Basys3 details:
//   - Common ANODE display (an[x] = 0 => digit ON)
//   - seg[x] are ACTIVE-LOW (0 => segment ON)
//   - dp is ACTIVE-LOW (0 => decimal point ON)

module counter_basys(
    input  wire        clk,        // 100 MHz system clock
    input  wire        reset,      // active-high reset
    input  wire [31:0] score_bus,  // from reg_GPU_bus7

    output reg  [6:0]  seg,        // segments a..g (active-low)
    output reg  [3:0]  an,         // digit enables (active-low)
    output wire        dp          // decimal point (active-low)
);

    // =========================================================
    // 1. Digit extraction from score_bus
    // =========================================================
    wire [3:0] ones      = score_bus[3:0];
    wire [3:0] tens      = score_bus[7:4];
    wire [3:0] hundreds  = score_bus[11:8];
    wire [3:0] thousands = score_bus[15:12];

    // Current digit value being displayed (BCD)
    reg  [3:0] curr_digit;

    // =========================================================
    // 2. Refresh / multiplexing counter
    // =========================================================
    //
    // Use upper bits of a free-running counter to scan through
    // the 4 digits fast enough to appear steady to the eye.
    // With a 100MHz clock, using bits [16:15] gives each digit
    // an update rate of about 95 Hz (no visible flicker).
    //
    reg [16:0] refresh_cnt;

    always @(posedge clk or posedge reset) begin
        if (reset)
            refresh_cnt <= 0;
        else
            refresh_cnt <= refresh_cnt + 1;
    end

    wire [1:0] scan_sel = refresh_cnt[16:15];

    // =========================================================
    // 3. BCD -> 7-seg decoder (active-low segments)
    // =========================================================
    //
    // seg = {a,b,c,d,e,f,g}, all ACTIVE-LOW.
    //
    function [6:0] bcd_to_7seg;
        input [3:0] digit;
        begin
            case (digit)
                4'd0: bcd_to_7seg = 7'b1000000; // 0
                4'd1: bcd_to_7seg = 7'b1111001; // 1
                4'd2: bcd_to_7seg = 7'b0100100; // 2
                4'd3: bcd_to_7seg = 7'b0110000; // 3
                4'd4: bcd_to_7seg = 7'b0011001; // 4
                4'd5: bcd_to_7seg = 7'b0010010; // 5
                4'd6: bcd_to_7seg = 7'b0000010; // 6
                4'd7: bcd_to_7seg = 7'b1111000; // 7
                4'd8: bcd_to_7seg = 7'b0000000; // 8
                4'd9: bcd_to_7seg = 7'b0010000; // 9
                default:
                    bcd_to_7seg = 7'b1111111;   // blank for anything else
            endcase
        end
    endfunction

    // =========================================================
    // 4. Digit selection & segment driving
    // =========================================================
    //
    // an[0] = rightmost digit (ones)
    // an[3] = leftmost digit (thousands)
    //
    always @(*) begin
        case (scan_sel)
            2'b00: begin
                an         = 4'b1110;   // enable digit 0 (rightmost)
                curr_digit = ones;
            end
            2'b01: begin
                an         = 4'b1101;   // enable digit 1
                curr_digit = tens;
            end
            2'b10: begin
                an         = 4'b1011;   // enable digit 2
                curr_digit = hundreds;
            end
            2'b11: begin
                an         = 4'b0111;   // enable digit 3 (leftmost)
                curr_digit = thousands;
            end
            default: begin
                an         = 4'b1111;
                curr_digit = 4'd0;
            end
        endcase

        seg = bcd_to_7seg(curr_digit);
    end

    // Decimal point off (1 = off on Basys3, since active-low)
    assign dp = 1'b1;

endmodule
