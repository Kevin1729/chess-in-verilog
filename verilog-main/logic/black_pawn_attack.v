module Black_Pawn_Attack(
    //inputs
    black_pawns,
    //outputs
    black_pawn_attack);

input [63:0] black_pawns;
output reg [63:0] black_pawn_attack;

always @* begin
    black_pawn_attack = ((black_pawns >> 7) & 64'hfefefefefefefefe) | ((black_pawns >> 9) & 64'h7f7f7f7f7f7f7f7f);
end

endmodule