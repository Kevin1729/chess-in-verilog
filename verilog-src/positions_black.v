module Black_Position(
    //inputs
    piece_bitboards_flattened,
    //outputs
    black_positions
);
input [12*64-1:0] piece_bitboards_flattened;
output reg [63:0] black_positions;
integer i;

always @* begin
    black_positions = 0;
    i = 0;
    for (i = 0; i < 6; i = i + 1)
        black_positions = black_positions | piece_bitboards_flattened[64*i +: 64];
end

endmodule