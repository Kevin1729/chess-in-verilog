/*
Checks whether king is in check. Can be used in conjuction with Move_Verify (to deal with pins and whatnot)
*/
module Check_Checker(
    //inputs
    is_white,
    piece_bitboards_flattened,
    //outputs
    is_in_check
);
input is_white;
input [64*12-1:0] piece_bitboards_flattened;
output reg is_in_check;

wire [63:0] king_bitboard;
wire [2:0] king_rank;
wire [2:0] king_file;
wire [5:0] rankfile = bitboard_to_filerank(king_bitboard);

assign king_bitboard = (is_white ? piece_bitboards_flattened[11*64 +: 64] : piece_bitboards_flattened[5*64 +: 64]);
assign king_rank = rankfile[2:0]; 
assign king_file = rankfile[5:3]; 
//with the exception of pawns, if an enemy piece is attacking the king,
//then the king is attacking the enemy piece if the king had its attack pattern.
//This arises because all the attack patterns (w/ the exception of pawns) are rotationally
//symmetric, laterally symmetric, and vertically symmetric.
wire [63:0] white_position;
wire [63:0] black_position;
wire [63:0] all_position;
reg [63:0] opposite_side_pawn_position;

White_Position wp(piece_bitboards_flattened, white_position);
Black_Position bp(piece_bitboards_flattened, black_position);
All_Position ap(piece_bitboards_flattened, all_position);

wire [63:0] white_pawn_attack;
wire [63:0] black_pawn_attack;
wire [63:0] diagonal_attack;
wire [63:0] line_attack;
wire [63:0] knight_attack;
wire [63:0] king_attack;

White_Pawn_Attack wpa(piece_bitboards_flattened[6*64 +: 64], white_pawn_attack);
Black_Pawn_Attack bpa(piece_bitboards_flattened[0*64 +: 64], black_pawn_attack);
Diagonal_Attack da(all_position, king_file, king_rank, diagonal_attack);
Line_Attack la(all_position, king_file, king_rank, line_attack);
Knight_Attack na(king_bitboard, knight_attack);
King_Attack ka(king_bitboard, king_attack);

integer index_offset;
always @* begin
    if(is_white) begin
        opposite_side_pawn_position = black_pawn_attack;
        index_offset = 0; // we view black pieces as enemies
    end
    else begin
        opposite_side_pawn_position = white_pawn_attack;
        index_offset = 6; // we view white pieces as enemies
    end
    // if pawns attack
    if(opposite_side_pawn_position & king_bitboard) begin
        is_in_check = 1;
    end
    // if knights attack
    else if(knight_attack & piece_bitboards_flattened[64 * (index_offset + 1) +: 64]) begin
        is_in_check = 1;
    end
    // if bishops attack
    else if(diagonal_attack & piece_bitboards_flattened[64 * (index_offset + 2) +: 64]) begin
        is_in_check = 1;
    end
    // if rooks attack
    else if(line_attack & piece_bitboards_flattened[64 * (index_offset + 3) +: 64]) begin
        is_in_check = 1;
    end
    // if queens attack
    else if((diagonal_attack | line_attack) & piece_bitboards_flattened[64 * (index_offset + 4) +: 64]) begin
        is_in_check = 1;
    end
    // if other king attacks
    else if(king_attack & piece_bitboards_flattened[64 * (index_offset + 5) +: 64]) begin
        is_in_check = 1;
    end
    else begin
        is_in_check = 0;
    end
    
end
function automatic [5:0] bitboard_to_filerank(input [63:0] bitboard);
integer i;
integer j;
begin
    for(i = 0; i < 8; i = i + 1) begin
        //check per row
        if(bitboard[8*i +: 8]) begin
            bitboard_to_filerank[2:0] = i;
            j = i;
        end
    end
    for(i = 0; i < 8; i = i + 1) begin
        //check per column within row
        if(bitboard[8*j + i]) begin
            bitboard_to_filerank[5:3] = i;
        end
    end
end
endfunction

endmodule