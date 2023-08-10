/*
Only verifies legal moves according to piece moveset (castling and en passant not yet added), does NOT consider checks
*/
module Move_Verify(
    //inputs
    old_file, old_rank,
    new_file, new_rank,
    is_white,
    piece_bitboards_flattened,
    en_passant_bitboard, // has a single 1 set somewhere if en passant is possible; otherwise it is 0
    //outputs
    move_is_valid,
    piece,
    new_piece_bitboards_flattened
);
input [2:0] old_file;
input [2:0] old_rank;
input [2:0] new_file;
input [2:0] new_rank;
input is_white;
input [12*64-1:0] piece_bitboards_flattened;
input [63:0] en_passant_bitboard;
output reg move_is_valid;
output reg [3:0] piece;
output reg [12*64-1:0] new_piece_bitboards_flattened;

wire [63:0] white_position;
wire [63:0] black_position;
wire [63:0] all_position;
reg [63:0] current_side_position;

White_Position wp(piece_bitboards_flattened, white_position);
Black_Position bp(piece_bitboards_flattened, black_position);
All_Position ap(piece_bitboards_flattened, all_position);

wire [63:0] old_square_bitboard; // the square at (old_file, old_rank) will be set to 1, all others 0
wire [63:0] new_square_bitboard; // the square at (new_file, new_rank) will be set to 1, all others 0

assign old_square_bitboard = 64'h1 << (old_rank * 8 + old_file);
assign new_square_bitboard = 64'h1 << (new_rank * 8 + new_file);

wire [63:0] white_pawn_push;
wire [63:0] white_pawn_attack;
wire [63:0] black_pawn_push;
wire [63:0] black_pawn_attack;
wire [63:0] diagonal_attack;
wire [63:0] line_attack;
wire [63:0] knight_attack;
wire [63:0] king_attack;

White_Pawn_Push wpp(all_position, old_square_bitboard, white_pawn_push);
White_Pawn_Attack wpa(old_square_bitboard, white_pawn_attack);
Black_Pawn_Push bpp(all_position, old_square_bitboard, black_pawn_push);
Black_Pawn_Attack bpa(old_square_bitboard, black_pawn_attack);
Diagonal_Attack da(all_position, old_file, old_rank, diagonal_attack);
Line_Attack la(all_position, old_file, old_rank, line_attack);
Knight_Attack na(old_square_bitboard, knight_attack);
King_Attack ka(old_square_bitboard, king_attack);

reg [63:0] en_passanted_pawn; // kill that stupid pawn, probably thought it could be a pass pawn

integer index_offset;
integer found_index;
integer iter;
always @* begin
    en_passanted_pawn = 0;
    if(is_white) begin
        index_offset = 6;
        current_side_position = white_position;
    end
    else begin
        index_offset = 0;
        current_side_position = black_position;
    end
    // if it's a pawn:
    if(old_square_bitboard & piece_bitboards_flattened[64 * (0 + index_offset) +: 64]) begin
        found_index = 0 + index_offset;
        if(is_white) begin
            if(new_square_bitboard & (white_pawn_push | (white_pawn_attack & ~white_position & black_position))) begin
                move_is_valid = 1; //maybe! need to check if king is placed in check
            end
            else if (new_square_bitboard & en_passant_bitboard) begin
                move_is_valid = 1;
                en_passanted_pawn = en_passant_bitboard >> 8; //shift down because it's white turn
            end
            else begin
                move_is_valid = 0;
            end
        end
        else begin
            if(new_square_bitboard & (black_pawn_push | (black_pawn_attack & ~black_position & white_position))) begin
                move_is_valid = 1;
            end
            else if(new_square_bitboard & en_passant_bitboard) begin
                move_is_valid = 1;
                en_passanted_pawn = en_passant_bitboard << 8; //shift up because it's white turn
            end
            else begin
                move_is_valid = 0;
            end
        end
    end 
    // if it's a knight:
    else if(old_square_bitboard & piece_bitboards_flattened[64 * (1 + index_offset) +: 64]) begin
        found_index = 1 + index_offset;
        if(new_square_bitboard & (knight_attack & ~current_side_position)) begin
            move_is_valid = 1;
        end
        else begin
            move_is_valid = 0;
        end
    end
    // if it's a bishop:
    else if(old_square_bitboard & piece_bitboards_flattened[64 * (2 + index_offset) +: 64]) begin
        found_index = 2 + index_offset;
        if(new_square_bitboard & (diagonal_attack & ~current_side_position)) begin
            move_is_valid = 1;
        end
        else begin
            move_is_valid = 0;
        end
    end
    // if it's a rook:
    else if(old_square_bitboard & piece_bitboards_flattened[64 * (3 + index_offset) +: 64]) begin
        found_index = 3 + index_offset;
        if(new_square_bitboard & (line_attack & ~current_side_position)) begin
            move_is_valid = 1;
        end
        else begin
            move_is_valid = 0;
        end
    end
    // if it's a queen:
    else if(old_square_bitboard & piece_bitboards_flattened[64 * (4 + index_offset) +: 64]) begin
        found_index = 4 + index_offset;
        if(new_square_bitboard & ((line_attack | diagonal_attack) & ~current_side_position)) begin
            move_is_valid = 1;
        end
        else begin
            move_is_valid = 0;
        end
    end
    // if it's a king:
    else if(old_square_bitboard & piece_bitboards_flattened[64 * (5 + index_offset) +: 64]) begin
        found_index = 5 + index_offset;
        if(new_square_bitboard & (king_attack & ~current_side_position)) begin
            move_is_valid = 1;
        end
        else begin
            move_is_valid = 0;
        end
    end
    // if it's not anything:
    else begin
        move_is_valid = 0;
        found_index = 13;
    end


    if(move_is_valid) begin
        new_piece_bitboards_flattened = 0;
        for(iter = 0; iter < 12; iter = iter + 1) begin
            if(iter == found_index) begin
                new_piece_bitboards_flattened[64*iter +: 64] = new_piece_bitboards_flattened[64*iter +: 64] | ((piece_bitboards_flattened[64*iter +: 64] & ~old_square_bitboard) | new_square_bitboard);
            end 
            else begin
                new_piece_bitboards_flattened[64*iter +: 64] = new_piece_bitboards_flattened[64*iter +: 64] | ((piece_bitboards_flattened[64*iter +: 64] & (~new_square_bitboard) & (~en_passanted_pawn)));
            end
        end
    end
    else begin
       new_piece_bitboards_flattened = piece_bitboards_flattened;
    end
    piece = found_index;
end

endmodule