module All_Position(
    //inputs
    piece_bitboards_flattened,
    //outputs
    all_positions
);
input [12*64-1:0] piece_bitboards_flattened;
output reg [63:0] all_positions;
integer i;

always @* begin
    all_positions = 0;
    i = 0;
    for (i = 0; i < 12; i = i + 1)
        all_positions = all_positions | piece_bitboards_flattened[64*i +: 64];
end

endmodule