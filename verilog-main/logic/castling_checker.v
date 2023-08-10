module Castling_Checker(
    //inputs
    old_file, old_rank,
    new_file, new_rank,
    is_white,
    piece_bitboards_flattened,
    //outputs
    castling_is_valid,
    new_piece_bitboards_flattened
);

input [2:0] old_file;
input [2:0] old_rank;
input [2:0] new_file;
input [2:0] new_rank;
input is_white;
input [12*64-1:0] piece_bitboards_flattened;
output reg castling_is_valid;
output reg [12*64-1:0] new_piece_bitboards_flattened;

wire is_short_castling;
assign is_short_castling = new_file > old_file;

wire [63:0] o_o_check;
wire [63:0] o_o_o_check;
assign o_o_check = 64'h70 << (is_white ? 0 : 56);
assign o_o_o_check = 64'h1c << (is_white ? 0 : 56);

wire [63:0] o_o_empty;
wire [63:0] o_o_o_empty;
assign o_o_empty = 64'he << (is_white ? 0 : 56);
assign o_o_o_empty = 64'h60 << (is_white ? 0 : 56);

wire [63:0] all_position;
All_Position ap(piece_bitboards_flattened, all_position);

wire [63:0] attack_set;
Complete_Attack_Set cas(piece_bitboards_flattened, !is_white, attack_set);

always @* begin
    new_piece_bitboards_flattened = piece_bitboards_flattened;
    // first, check if the squares are vacant
    if((is_short_castling ? o_o_empty : o_o_o_empty) & all_position) begin
        castling_is_valid = 0;
    end
    // then, check if the king will move through check
    else if((is_short_castling ? o_o_check : o_o_o_check) & attack_set) begin
        castling_is_valid = 0;
    end
    // make sure the inputs even look like a castle
    else if(!((old_file == 4 || old_rank == (is_white ? 0 : 7)) && (new_rank == (is_white ? 0 : 7)) && (new_file == 2 || new_file == 6))) begin
        castling_is_valid = 0;
    end
    // make sure there's actually a king on e1/e8 and a rook on a1/a8/h1/h8
    else if(!(piece_bitboards_flattened[(5 + (is_white ? 6 : 0)) * 64 +: 64] & (64'h10 << (is_white ? 0 : 56)))) begin
        castling_is_valid = 0;
    end
    else if(!(piece_bitboards_flattened[(3 + (is_white ? 6 : 0)) * 64 +: 64] & ((is_short_castling ? 64'h80 : 64'h1) << (is_white ? 0 : 56)))) begin
        castling_is_valid = 0;
    end 
    else begin
        castling_is_valid = 1;
        new_piece_bitboards_flattened[(5 + (is_white ? 6 : 0)) * 64 +: 64] = ((is_short_castling ? 64'h40 : 64'h4) << (is_white ? 0 : 56));
        new_piece_bitboards_flattened[(3 + (is_white ? 6 : 0)) * 64 +: 64] = (new_piece_bitboards_flattened[(3 + (is_white ? 6 : 0)) * 64 +: 64]
        & ~((is_short_castling ? 64'h80 : 64'h1) << (is_white ? 0 : 56))) | ((is_short_castling ? 64'h20 : 64'h8) << (is_white ? 0 : 56));

    end
end

endmodule