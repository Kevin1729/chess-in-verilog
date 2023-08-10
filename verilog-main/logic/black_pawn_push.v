module Black_Pawn_Push(
    //inputs
    occupied,
    black_pawn,
    //outputs
    black_pawn_push
);
input [63:0] occupied;
input [63:0] black_pawn;
output reg [63:0] black_pawn_push;

reg [63:0] single_push;

always @* begin
    single_push = (black_pawn >> 8) & ~occupied;
    black_pawn_push = single_push | ((single_push >> 8) & ~occupied & 64'h000000FF00000000);
end
endmodule