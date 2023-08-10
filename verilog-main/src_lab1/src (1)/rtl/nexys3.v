module nexys3 (/*AUTOARG*/
   // Outputs
   RsTx, Led,
   // Inputs
   RsRx, sw, btnS, btnU, btnL, btnD, btnR, clk
   );

`include "seq_definitions.v"
   
   // USB-UART
   input        RsRx;
   output       RsTx;

   // Misc.
   input  [7:0] sw;
   output [7:0] Led;
   input        btnS;
   input        btnU;
   input        btnL;
   input        btnD;
   input        btnR;
   
   // Logic
   input        clk;                  // 100MHz
   
   /*AUTOWIRE*/
   // Beginning of automatic wires (for undeclared instantiated-module outputs)
   wire [seq_dp_width-1:0] seq_tx_data;         // From seq_ of seq.v
   wire                 seq_tx_valid;           // From seq_ of seq.v
   wire [7:0]           uart_rx_data;           // From uart_top_ of uart_top.v
   wire                 uart_rx_valid;          // From uart_top_ of uart_top.v
   wire                 uart_tx_busy;           // From uart_top_ of uart_top.v
   // End of automatics
   
   wire [17:0] clk_dv_inc;

   reg [16:0]  clk_dv;
   
   reg         clk_en;
   reg         clk_en_d;
      
   reg [7:0]   inst_wd;
   //reg         inst_vld;

   reg [2:0]   stepS;
   reg [2:0]   stepU;
   reg [2:0]   stepL;
   reg [2:0]   stepD;
   reg [2:0]   stepR;
   
   reg         bS;
   reg         bU;
   reg         bL;
   reg         bD;
   reg         bR;

   reg [7:0]   inst_cnt;

   // ===========================================================================
   // 763Hz timing signal for clock enable
   // ===========================================================================

   assign clk_dv_inc = clk_dv + 1;
   
   always @ (posedge clk)
     if (rst)
       begin
          clk_dv   <= 0;
          clk_en   <= 1'b0;
          clk_en_d <= 1'b0;
       end
     else
       begin
          clk_dv   <= clk_dv_inc[16:0];
          clk_en   <= clk_dv_inc[17];
          clk_en_d <= clk_en;
       end
   
   // ===========================================================================
   // Instruction Stepping Control
   // ===========================================================================
   
   always @ (posedge clk) begin
     if (clk_en)
       begin
          inst_wd[7:0] <= sw[7:0];
          stepS[2:0]  <= {btnS, stepS[2:1]};
          stepU[2:0]  <= {btnU, stepU[2:1]};
          stepL[2:0]  <= {btnL, stepL[2:1]};
          stepD[2:0]  <= {btnD, stepD[2:1]};
          stepR[2:0]  <= {btnR, stepR[2:1]};
       end
     bS <= ~stepS[0] & stepS[1] & clk_en_d;
     bU <= ~stepU[0] & stepU[1] & clk_en_d;
     bL <= ~stepL[0] & stepL[1] & clk_en_d;
     bD <= ~stepD[0] & stepD[1] & clk_en_d;
     bR <= ~stepR[0] & stepR[1] & clk_en_d;
   end
/*
   always @ (posedge clk)
     if (inst_vld)
       inst_cnt <= inst_cnt + 1;*/

   reg bSflip = 0;
   reg bUflip = 0;
   reg bLflip = 0;
   reg bDflip = 0;
   reg bRflip = 0;
   always @ (posedge bS)
     bSflip = !bSflip;
   always @ (posedge bU)
     bUflip = !bUflip;
   always @ (posedge bL)
     bLflip = !bLflip;
   always @ (posedge bD)
     bDflip = !bDflip;
   always @ (posedge bR)
     bRflip = !bRflip;
   //assign Led[7:0] = inst_cnt[7:0];
   //assign Led[7:0] = inst_wd[7:0];
   assign Led[0] = bSflip;
   assign Led[1] = bUflip;
   assign Led[2] = bLflip;
   assign Led[3] = bDflip;
   assign Led[4] = bRflip;
   assign Led[5] = bSflip;
   assign Led[6] = bSflip;
   assign Led[7] = bSflip;

   reg [2:0] txData;
   always @ (posedge clk)
     if (bS) txData <= 0;
     else if (bU) txData <= 1;
     else if (bL) txData <= 2;
     else if (bD) txData <= 3;
     else if (bR) txData <= 4;
   //assign seq_tx_data[seq_dp_width-1:0] = txData;
   //assign seq_tx_valid = (bS | bU | bL | bD | bR) & ~uart_tx_busy;
   //assign seq_tx_data[seq_dp_width-1:0] = "rnbqkbnr\n\rpppppppp\n\r........\n\r........\n\r........\n\r........\n\rPPPPPPPP\n\rRNBQKBNR";
   assign seq_tx_data[seq_dp_width-1:0] = print_position(board_state, cursor_file, cursor_rank);
   assign seq_tx_valid = bS & ~uart_tx_busy;
   // ===========================================================================
   // Sequencer
   // ===========================================================================
/*
   seq seq_ (// Outputs
             .o_tx_data                 (seq_tx_data[seq_dp_width-1:0]),
             .o_tx_valid                (seq_tx_valid),
             // Inputs
             .i_tx_busy                 (uart_tx_busy),
             .i_inst                    (inst_wd[seq_in_width-1:0]),
             .i_inst_valid              (inst_vld),
             // AUTOINST
             // Inputs
             .clk                       (clk),
             .rst                       (rst));
   */
   
   // ===========================================================================
   // CHUSSSSSSS
   // ===========================================================================
   
wire [2:0] cursor_file;
wire [2:0] cursor_rank;
wire [767:0] board_state;
wire is_white;

chess c_module(.board_state(board_state),
               .cursor_file(cursor_file),
               .cursor_rank(cursor_rank),
               .is_white_output(is_white),
               .sw(inst_wd),
               .btnS(bS), 
               .btnU(bU), 
               .btnL(bL), 
               .btnD(bD), 
               .btnR(bR), 
               .clk(clk));

   
   // ===========================================================================
   // UART controller
   // ===========================================================================

   uart_top uart_top_ (// Outputs
                       .o_tx            (RsTx),
                       .o_tx_busy       (uart_tx_busy),
                       .o_rx_data       (uart_rx_data[7:0]),
                       .o_rx_valid      (uart_rx_valid),
                       // Inputs
                       .i_rx            (RsRx),
                       .i_tx_data       (seq_tx_data[seq_dp_width-1:0]),
                       .i_tx_stb        (seq_tx_valid),
                       /*AUTOINST*/
                       // Inputs
                       .clk             (clk),
                       .rst             (rst));
function automatic [10*8*8-1:0] print_position(input [768-1:0] positions, input [2:0] cursor_file, input [2:0] cursor_rank);
reg [7:0] character;
reg [0:12*8-1] character_list;
integer i;
integer file;
integer rank;
integer num_chars_per_line;
begin
    character_list = "pnbrqkPNBRQK";
    num_chars_per_line = 10; //change this 9 to 10 if a \r is required
    print_position = "........\n\r........\n\r........\n\r........\n\r........\n\r........\n\r........\n\r........\n\r";
    for(i = 0; i < 12; i = i + 1) begin
        character = character_list[i * 8 +: 8];
        for(rank = 7; rank >= 0; rank = rank - 1) begin
            for(file = 0; file < 8; file = file + 1) begin
                if(positions[i * 64 +: 64] & (64'h1 << (rank * 8 + file))) begin
                    print_position[(rank * num_chars_per_line + num_chars_per_line - 1 - file) * 8 +: 8] = character; 
                end
            end
        end
    end
    print_position[(cursor_rank * num_chars_per_line + num_chars_per_line - 1 - cursor_file) * 8 +: 8] = "@";
end
endfunction
endmodule // nexys3
// Local Variables:
// verilog-library-flags:("-f ../input.vc")
// End:
