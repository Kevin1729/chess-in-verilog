//`include "masks.v"
`include "utility.v"
module Line_Attack(
    //inputs
    occupied,
    file,
    rank,
    //outputs
    line_attack
);

input [63:0] occupied;
input [2:0] file;
input [2:0] rank;
output reg [63:0] line_attack;
reg [63:0] rook;
reg [63:0] vertical_mask;
reg [63:0] horizontal_mask;
wire [64*8-1:0] fileMasks;
wire [64*8-1:0] rankMasks;
assign fileMasks = 512'h80808080808080804040404040404040202020202020202010101010101010100808080808080808040404040404040402020202020202020101010101010101;
assign rankMasks = 512'hFF0000000000000000FF0000000000000000FF0000000000000000FF0000000000000000FF0000000000000000FF0000000000000000FF0000000000000000FF;
always @* begin
    rook = 64'h1 << (rank * 8 + file);
    vertical_mask = fileMasks[file*64 +: 64];
    horizontal_mask = rankMasks[rank*64 +: 64]; 
    line_attack = file_ray_attack(occupied, rook, vertical_mask) | rotate_counterclockwise(file_ray_attack(rotate_clockwise(occupied), rotate_clockwise(rook), rotate_clockwise(horizontal_mask))) | rotate_clockwise(file_ray_attack(rotate_counterclockwise(occupied), rotate_counterclockwise(rook), rotate_counterclockwise(horizontal_mask))) | vertical_flip(file_ray_attack(vertical_flip(occupied), vertical_flip(rook), vertical_mask));
    //line_attack =(occupied ^ ((occupied & vertical_mask) - 2 * rook)) & vertical_mask;
end
function automatic [63:0] file_ray_attack(input [63:0] occupied, input [63:0] rook, input[63:0] mask);
reg [63:0] occ;
begin
    occ = occupied & mask;
    file_ray_attack = (occupied ^ (occ - 2 * rook)) & mask;
end
endfunction

endmodule