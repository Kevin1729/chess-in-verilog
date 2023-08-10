module White_Position(
    //inputs
    piece_bitboards_flattened,
    //outputs
    white_positions
);
input [12*64-1:0] piece_bitboards_flattened;
output reg [63:0] white_positions;
integer i;

always @* begin
    white_positions = 0;
    i = 0;
    for (i = 6; i < 12; i = i + 1)
        white_positions = white_positions | piece_bitboards_flattened[64*i +: 64];
end

endmodule