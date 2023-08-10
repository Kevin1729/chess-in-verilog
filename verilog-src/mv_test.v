module tb;

wire [768-1:0] ex_position;
assign ex_position = 768'h00000000000000100000000000400000000000000000008100000000000001000000000080001000000000402110460040000000000000000800000000000000200000000000000004400000000000000008000000000000002040890e000000;
/*
..bq.rk.
...n.pb.
......p.
p..p..Pp
Pppp.P.N
....P.Q.
BPP.N.P.
R...K..R
*/
reg [768-1:0] position;

wire is_valid;
wire [3:0] piece;
wire [768-1:0] new_position;
wire [63:0] all_new;
wire [63:0] all_position;
wire [63:0] diagonal_attack;
wire [63:0] new_en_passant;
wire [63:0] white_attack_set;
wire [63:0] black_attack_set;
wire [768-1:0] castled;
wire [63:0] all_castled;
wire castling_is_valid;
reg [2:0] old_file = 0;
reg [2:0] old_rank = 0;
reg [2:0] new_file = 0;
reg [2:0] new_rank = 0;
reg is_white = 1;
Complete_Move_Verifier cmv(old_file, old_rank, new_file, new_rank, is_white, position, 64'h0, is_valid, piece, new_position, new_en_passant);
All_Position ap(new_position, all_new);
All_Position ap1(position, all_position);
Complete_Attack_Set casw1(position, 1, white_attack_set);
Complete_Attack_Set casb1(position, 0, black_attack_set);
Castling_Checker cc(old_file, old_rank, new_file, new_rank, is_white, position, castling_is_valid, castled);
All_Position ap2(castled, all_castled);
wire [2:0] old_file_order [0:6];
assign old_file_order[0] = 4;
assign old_file_order[1] = 4;
assign old_file_order[2] = 5;
assign old_file_order[3] = 1;
assign old_file_order[4] = 3;
assign old_file_order[5] = 6;
assign old_file_order[6] = 7;
wire [2:0] old_rank_order [0:6];
assign old_rank_order[0] = 1;
assign old_rank_order[1] = 6;
assign old_rank_order[2] = 0;
assign old_rank_order[3] = 7;
assign old_rank_order[4] = 0;
assign old_rank_order[5] = 7;
assign old_rank_order[6] = 4;
wire [2:0] new_file_order [0:6];
assign new_file_order[0] = 4;
assign new_file_order[1] = 4;
assign new_file_order[2] = 2;
assign new_file_order[3] = 2;
assign new_file_order[4] = 7;
assign new_file_order[5] = 5;
assign new_file_order[6] = 5;
wire [2:0] new_rank_order [0:6];
assign new_rank_order[0] = 3;
assign new_rank_order[1] = 4;
assign new_rank_order[2] = 3;
assign new_rank_order[3] = 5;
assign new_rank_order[4] = 4;
assign new_rank_order[5] = 5;
assign new_rank_order[6] = 6;
integer i;
//Diagonal_Attack da(all_position, 3, 7, diagonal_attack);
initial begin
    position = 768'h00000000000000100000000000000008000000000000008100000000000000240000000000000042000000000000ff001000000000000000080000000000000081000000000000002400000000000000420000000000000000ff000000000000;
    i = 0;
    old_file <= old_file_order[i];
    old_rank <= old_rank_order[i];
    new_file <= new_file_order[i];
    new_rank <= new_rank_order[i];
end
always begin
    // $display("Is castling valid? %d", castling_is_valid);
    // print(all_castled);
    if(is_valid) begin
        i = i + 1;
        old_file <= old_file_order[i];
        old_rank <= old_rank_order[i];
        new_file <= new_file_order[i];
        new_rank <= new_rank_order[i];
        is_white <= !is_white;
        position = new_position;
    end
    else if(castling_is_valid) begin
        i = i + 1;
        old_file <= old_file_order[i];
        old_rank <= old_rank_order[i];
        new_file <= new_file_order[i];
        new_rank <= new_rank_order[i];
        is_white <= !is_white;
        position = castled;
    end
    else begin
        $display("BAD MOVE: %d", i);
    end
    $display("------\n%s\n------", print_position(position));
    #10;
    $stop;
end

task automatic print(input [63:0] bitboard);
    integer i;
    integer j;
    begin
        $display("----------");
        for(i = 56; i>=0; i = i - 8) begin
            for(j = 0; j < 8; j = j + 1) begin
                $write("%d", bitboard[i+j]);
            end
            $write("\n");
        end 
        $display("------------");
    end
endtask


//                  V---- Change this 9 to 10 if a \r is required
function automatic [9*8*8-1:0] print_position(input [768-1:0] positions);
    reg [7:0] character;
    reg [0:12*8-1] character_list = "pnbrqkPNBRQK";
    integer i;
    integer file;
    integer rank;
    integer num_chars_per_line;
    begin
        num_chars_per_line = 9; //change this 9 to 10 if a \r is required
        print_position = "........\n........\n........\n........\n........\n........\n........\n........\n";
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
    end
endfunction

endmodule