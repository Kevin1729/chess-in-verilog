module White_Pawn_Attack(
    //inputs
    white_pawns,
    //outputs
    white_pawn_attack);

input [63:0] white_pawns;
output reg [63:0] white_pawn_attack;

always @* begin
    white_pawn_attack = ((white_pawns << 9) & 64'hfefefefefefefefe) | ((white_pawns << 7) & 64'h7f7f7f7f7f7f7f7f);
end

endmodule