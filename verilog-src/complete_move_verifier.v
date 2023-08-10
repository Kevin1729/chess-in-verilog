/* NOTE: Haven't added castling yet (en passant is added) */
module Complete_Move_Verifier(
    //inputs
    old_file, old_rank,
    new_file, new_rank,
    is_white,
    piece_bitboards_flattened,
    en_passant_bitboard,
    //outputs
    move_is_valid,
    piece,
    new_piece_bitboards_flattened,
    potential_en_passant_bitboard
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
output reg [63:0] potential_en_passant_bitboard;

// these maybe_ wires will come out of Move_Verify, which doesn't check for checks.
wire maybe_move_is_valid;
wire [3:0] maybe_piece;
wire [12*64-1:0] maybe_new_piece_bitboards_flattened;
wire is_in_check;

Move_Verify mv(old_file, old_rank, new_file, new_rank, is_white, piece_bitboards_flattened, en_passant_bitboard, maybe_move_is_valid, maybe_piece, maybe_new_piece_bitboards_flattened);
Check_Checker cc1(is_white, maybe_new_piece_bitboards_flattened, is_in_check);

always @* begin
    if(maybe_move_is_valid && !is_in_check) begin
        move_is_valid = 1;
        piece = maybe_piece;
        new_piece_bitboards_flattened = maybe_new_piece_bitboards_flattened;
        // update en passant bitboard
        if(piece == 0 && ((old_rank - new_rank) == 2)) begin // if the piece moved was a black pawn and has been double pushed down
            potential_en_passant_bitboard = 64'h1 << (8 * (new_rank + 1) + new_file);
        end
        else if(piece == 6 && ((new_rank - old_rank) == 2)) begin // if the piece moved was a white pawn and has been double pushed up
            potential_en_passant_bitboard = 64'h1 << (8 * (new_rank - 1) + new_file);
        end
        else begin
            potential_en_passant_bitboard = 64'h0;
        end
    end
    else begin
        move_is_valid = 0;
        piece = 13;
        new_piece_bitboards_flattened = piece_bitboards_flattened;
        potential_en_passant_bitboard = en_passant_bitboard;
    end
    // move_is_valid = is_in_check;
end

endmodule