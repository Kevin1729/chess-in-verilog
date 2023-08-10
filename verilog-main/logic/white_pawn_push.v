module White_Pawn_Push(
    //inputs
    occupied,
    white_pawn,
    //outputs
    white_pawn_push
);
input [63:0] occupied;
input [63:0] white_pawn;
output reg [63:0] white_pawn_push;

reg [63:0] single_push;

always @* begin
    single_push = (white_pawn << 8) & ~occupied;
    white_pawn_push = single_push | ((single_push << 8) & ~occupied & 64'h00000000FF000000);
end
endmodule