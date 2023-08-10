module King_Attack(
    //inputs
    king,
    //outputs,
    king_attack
);
input [63:0] king;
output reg [63:0] king_attack;

reg [63:0] king_set;

always @* begin
    king_set = king;
    king_attack = ((king_set << 1) & 64'hfefefefefefefefe) | ((king_set >> 1) & 64'h7f7f7f7f7f7f7f7f);
    king_set = king_set | king_attack;
    king_attack = king_attack | (king_set << 8) | (king_set >> 8);
end

endmodule