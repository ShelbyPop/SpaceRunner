`timescale 1ns / 1ps

module pixel_gen(
    input clk,              
    input [9:0] x,          
    input [9:0] y,          
    input video_on,         

    // Game State
    input [31:0] reg_player_pos, 
    input [31:0] reg_gamestate,  

    // Platforms (Packed Dual-Layer Format)
    input [31:0] reg_plat0_pos,
    input [31:0] reg_plat1_pos,
    input [31:0] reg_plat2_pos,
    input [31:0] reg_plat3_pos,
    input [31:0] reg_plat4_pos, 
    input [31:0] reg_plat5_pos,   // 6th platform via GPU_BUS6

    // GPU Buses
    input [31:0] reg_GPU_bus0,    // Player Sprite
    input [31:0] reg_GPU_bus1,    // Enemy Pos
    input [31:0] reg_GPU_bus2,    // Enemy Sprite
    input [31:0] reg_GPU_bus3,    // Bullet 0
    input [31:0] reg_GPU_bus4,    // Bullet 1
    input [31:0] reg_GPU_bus5,    // Bullet 2
    
    output reg [11:0] rgb
    );

    // =============================================================
    // 1. PLAYER SPRITE RAM
    // =============================================================
    (* ram_style = "block" *)
    reg [11:0] player_ram [0:1023]; 
    
    wire        p_cmd_we  = reg_GPU_bus0[31]; 
    wire [4:0]  p_cmd_y   = reg_GPU_bus0[21:17];
    wire [4:0]  p_cmd_x   = reg_GPU_bus0[16:12];
    wire [11:0] p_cmd_col = reg_GPU_bus0[11:0];
    
    reg p_cmd_we_prev;
    always @(posedge clk) p_cmd_we_prev <= p_cmd_we;
    wire p_do_write = (p_cmd_we && !p_cmd_we_prev); 

    always @(posedge clk) begin
        if (p_do_write)
            player_ram[{p_cmd_y, p_cmd_x}] <= p_cmd_col;
    end
    
    // =============================================================
    // 2. PLAYER RENDERING
    // =============================================================
    wire [15:0] p_x = reg_player_pos[15:0];
    wire [15:0] p_y = reg_player_pos[27:16];
    wire [3:0]  player_type = reg_player_pos[31:28];
    wire        player_flip = |player_type;

    localparam PLAYER_SIZE = 128;
    
    wire [6:0] rel_x_full = x - p_x;
    wire [6:0] rel_y_full = y - p_y;

    wire player_on;
    assign player_on =
        (x >= p_x) && (x < p_x + PLAYER_SIZE) &&
        (y >= p_y) && (y < p_y + PLAYER_SIZE);

    wire [4:0] spr_x_base = rel_x_full[6:2]; 
    wire [4:0] spr_y_base = rel_y_full[6:2];
    wire [4:0] spr_y = player_flip ? (5'd31 - spr_y_base) : spr_y_base;
    wire [4:0] spr_x = spr_x_base;

    reg [11:0] sprite_color;
    always @(posedge clk)
        sprite_color <= player_ram[{spr_y, spr_x}];

    // =============================================================
    // 3. PLATFORM LOGIC (DUAL-LAYER PACKED)
    // =============================================================
    localparam PLAT_W = 128;
    localparam PLAT_H = 32; 

    // Hardcoded Y-levels (Must match C defines)
    localparam [15:0] ZONE_TOP_Y = 16'd48;
    localparam [15:0] ZONE_MID_Y = 16'd240;
    localparam [15:0] ZONE_BOT_Y = 16'd432;

    // Decode Zone ID to Y-coordinate
    function [15:0] get_zone_y;
        input [1:0] z_id;
        begin
            case (z_id)
                2'd0: get_zone_y = ZONE_TOP_Y;
                2'd1: get_zone_y = ZONE_MID_Y;
                2'd2: get_zone_y = ZONE_BOT_Y;
                default: get_zone_y = ZONE_BOT_Y;
            endcase
        end
    endfunction

    // Check layer collision
    function is_inside_layer;
        input [9:0]  vga_x, vga_y;
        input [9:0]  plat_x;
        input [1:0]  zone_id;
        input        active;
        reg [15:0]   py;
        reg [9:0]    diff_x; // Create a variable for the difference
        begin
            if (!active) begin
                is_inside_layer = 0;
            end else begin
                py = get_zone_y(zone_id);
                
                // Calculate the distance. 
                // Because these are 10-bit registers, this handles the "wrap around" automatically.
                // Example: If vga_x = 0 and plat_x = 1023 (-1), result is 1.
                diff_x = vga_x - plat_x; 
                
                is_inside_layer = 
                    (diff_x < PLAT_W) &&       // Check if horizontal diff is within width
                    (vga_y >= py)     &&       // Check vertical normally
                    (vga_y < py + PLAT_H);
            end
        end
    endfunction
    
    reg [3:0] current_type;
    reg [9:0] plat_rel_x, plat_rel_y;
    reg       any_plat_on;
    
    reg [31:0] p_data;
    reg [9:0]  px;
    reg [1:0]  zA, zB;
    reg [3:0]  tA, tB;
    reg        enA, enB;
    integer    i;
 
    always @* begin
        any_plat_on = 0;
        current_type = 0;
        plat_rel_x   = 0;
        plat_rel_y   = 0;

        // Loop through 6 platforms
        for (i = 0; i < 6; i = i + 1) begin
            
            // 1. Select Register
            case (i)
                0: p_data = reg_plat0_pos;
                1: p_data = reg_plat1_pos;
                2: p_data = reg_plat2_pos;
                3: p_data = reg_plat3_pos;
                4: p_data = reg_plat4_pos;
                5: p_data = reg_plat5_pos; // From GPU_BUS6
                default: p_data = 0;
            endcase

            // 2. Unpack Dual-Layer
            px  = p_data[9:0];

            zA  = p_data[11:10];
            tA  = {1'b0, p_data[14:12]};
            enA = p_data[15];

            zB  = p_data[27:26];
            tB  = {1'b0, p_data[30:28]};
            enB = p_data[31];

            // 3. Check Layer A
            if (is_inside_layer(x, y, px, zA, enA)) begin
                any_plat_on  = 1;
                current_type = tA;
                plat_rel_x   = x - px;
                plat_rel_y   = y - get_zone_y(zA);
            end
            
            // 4. Check Layer B
            if (is_inside_layer(x, y, px, zB, enB)) begin
                any_plat_on  = 1;
                current_type = tB;
                plat_rel_x   = x - px;
                plat_rel_y   = y - get_zone_y(zB);
            end
        end
    end
   
    wire [11:0] plat_texture_color;
    sprite_rom sprites (
        .clk(clk),
        .type_id(current_type), 
        .tile_col(plat_rel_x[4:0]),
        .tile_row(plat_rel_y[4:0]),
        .rgb_out(plat_texture_color)
    );

    // =============================================================
    // 4. ENEMY SPRITE
    // =============================================================
    localparam WYVERN_W = 32;
    localparam WYVERN_H = 32;

    wire [15:0] wy_x    = reg_GPU_bus1[15:0];
    wire [15:0] wy_y    = reg_GPU_bus1[27:16];
    wire [3:0]  wy_type = reg_GPU_bus1[31:28];

    wire wyvern_on =
        (wy_type != 4'd0) &&
        (x >= wy_x) && (x < wy_x + WYVERN_W) &&
        (y >= wy_y) && (y < wy_y + WYVERN_H);

    (* ram_style = "block" *)
    reg [11:0] wyvern_ram [0:1023];

    wire        wy_cmd_we  = reg_GPU_bus2[31];
    wire [4:0]  wy_cmd_y   = reg_GPU_bus2[21:17];
    wire [4:0]  wy_cmd_x   = reg_GPU_bus2[16:12];
    wire [11:0] wy_cmd_col = reg_GPU_bus2[11:0];

    reg wy_cmd_we_prev;
    always @(posedge clk) wy_cmd_we_prev <= wy_cmd_we;
    wire wy_do_write = (wy_cmd_we && !wy_cmd_we_prev);

    always @(posedge clk) begin
        if (wy_do_write)
            wyvern_ram[{wy_cmd_y, wy_cmd_x}] <= wy_cmd_col;
    end

    wire [9:0] wy_x10 = wy_x[9:0];
    wire [9:0] wy_y10 = wy_y[9:0];
    wire [9:0] wy_rel_x_full = x - wy_x10;  
    wire [9:0] wy_rel_y_full = y - wy_y10;  

    wire [4:0] wy_spr_x = wy_rel_x_full[5:1];
    wire [4:0] wy_spr_y = wy_rel_y_full[5:1];

    reg [11:0] wyvern_color;
    always @(posedge clk)
        wyvern_color <= wyvern_ram[{wy_spr_y, wy_spr_x}];

    // =============================================================
    // 5. BULLETS (MULTI-FIRE)
    // =============================================================
    // Reads Bus 3, 4, and 5
    localparam BULLET_W = 8;
    localparam BULLET_H = 4;

    wire [15:0] b0_x = reg_GPU_bus3[15:0];
    wire [15:0] b0_y = reg_GPU_bus3[27:16];
    wire [3:0]  b0_t = reg_GPU_bus3[31:28];

    wire [15:0] b1_x = reg_GPU_bus4[15:0];
    wire [15:0] b1_y = reg_GPU_bus4[27:16];
    wire [3:0]  b1_t = reg_GPU_bus4[31:28];

    wire [15:0] b2_x = reg_GPU_bus5[15:0];
    wire [15:0] b2_y = reg_GPU_bus5[27:16];
    wire [3:0]  b2_t = reg_GPU_bus5[31:28];

    wire bullet0_on = (b0_t != 4'd0) && (x >= b0_x) && (x < b0_x + BULLET_W) && (y >= b0_y) && (y < b0_y + BULLET_H);
    wire bullet1_on = (b1_t != 4'd0) && (x >= b1_x) && (x < b1_x + BULLET_W) && (y >= b1_y) && (y < b1_y + BULLET_H);
    wire bullet2_on = (b2_t != 4'd0) && (x >= b2_x) && (x < b2_x + BULLET_W) && (y >= b2_y) && (y < b2_y + BULLET_H);

    wire any_bullet_on = bullet0_on | bullet1_on | bullet2_on;
    wire [11:0] bullet_color = 12'hFF0;

    // =============================================================
    // 6. TEXT GENERATION
    // =============================================================
    wire [6:0] ascii;
    wire [6:0] a[8:0];
    wire       d[8:0];
    wire       displayContents;

    reg [6:0] readAscii [7:0];
    initial begin
      readAscii[0] = 7'h47; readAscii[1] = 7'h41; readAscii[2] = 7'h4d; readAscii[3] = 7'h45;
      readAscii[4] = 7'h4f; readAscii[5] = 7'h56; readAscii[6] = 7'h45; readAscii[7] = 7'h52;
    end

    assign d[8] = 0; assign a[8] = 0;

    textGeneration c0 (.asciiData(a[0]), .ascii_In(readAscii[0]), .x(x), .y(y), .displayContents(d[0]), .x_desired(10'd80),  .y_desired(10'd80));
    textGeneration c1 (.asciiData(a[1]), .ascii_In(readAscii[1]), .x(x), .y(y), .displayContents(d[1]), .x_desired(10'd88),  .y_desired(10'd80));
    textGeneration c2 (.asciiData(a[2]), .ascii_In(readAscii[2]), .x(x), .y(y), .displayContents(d[2]), .x_desired(10'd96),  .y_desired(10'd80));
    textGeneration c3 (.asciiData(a[3]), .ascii_In(readAscii[3]), .x(x), .y(y), .displayContents(d[3]), .x_desired(10'd104), .y_desired(10'd80));
    textGeneration c4 (.asciiData(a[4]), .ascii_In(readAscii[4]), .x(x), .y(y), .displayContents(d[4]), .x_desired(10'd120), .y_desired(10'd80));
    textGeneration c5 (.asciiData(a[5]), .ascii_In(readAscii[5]), .x(x), .y(y), .displayContents(d[5]), .x_desired(10'd128), .y_desired(10'd80));
    textGeneration c6 (.asciiData(a[6]), .ascii_In(readAscii[6]), .x(x), .y(y), .displayContents(d[6]), .x_desired(10'd136), .y_desired(10'd80));
    textGeneration c7 (.asciiData(a[7]), .ascii_In(readAscii[7]), .x(x), .y(y), .displayContents(d[7]), .x_desired(10'd144), .y_desired(10'd80));
    
    assign displayContents = d[0] ? d[0] : d[1] ? d[1] : d[2] ? d[2] : d[3] ? d[3] : d[4] ? d[4] : d[5] ? d[5] : d[6] ? d[6] : d[7] ? d[7] : 1'b0;
    assign ascii = d[0] ? a[0] : d[1] ? a[1] : d[2] ? a[2] : d[3] ? a[3] : d[4] ? a[4] : d[5] ? a[5] : d[6] ? a[6] : d[7] ? a[7] : 7'h30;

    wire [10:0] rom_addr;
    wire [7:0]  rom_data;
    wire        rom_bit;

    ascii_rom rom1(.clk(clk), .rom_addr(rom_addr), .data(rom_data));
    assign rom_addr = {ascii, y[3:0]}; 
    assign rom_bit  = rom_data[~x[2:0]];

    // =============================================================
    // 7. FINAL MUX
    // =============================================================
    wire hit_edge = reg_gamestate[0];

    always @* begin
        if (~video_on) begin
            rgb = 12'h000;
        end
        else begin
            if (hit_edge) begin
                rgb = rom_bit ? (displayContents ? 12'hF00 : 12'h008) : 12'h008;
            end
            else begin
                rgb = 12'h000;
                // Priority: Player > Enemy > Bullet > Platform
                if (player_on && (sprite_color != 12'h000))
                    rgb = sprite_color;
                else if (wyvern_on && (wyvern_color != 12'h000))
                    rgb = wyvern_color;
                else if (any_bullet_on)
                    rgb = bullet_color;
                else if (any_plat_on)
                    rgb = plat_texture_color;
            end
        end
    end

endmodule