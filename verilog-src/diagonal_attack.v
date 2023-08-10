//`include "masks.v"
`include "utility.v"
module Diagonal_Attack(
    //inputs
    occupied,
    file,
    rank,
    //outputs
    diagonal_attack
);

input [63:0] occupied;
input [2:0] file;
input [2:0] rank;
output reg [63:0] diagonal_attack;
reg [63:0] bishop;
reg [63:0] diagonal_mask;
reg [63:0] antidiagonal_mask;
wire [64*15-1:0] diagonalMasks;
wire [64*15-1:0] antidiagonalMasks;
assign diagonalMasks = 960'h000000000000008000000000000080400000000000804020000000008040201000000080402010080000804020100804008040201008040280402010080402014020100804020100201008040201000010080402010000000804020100000000040201000000000002010000000000000100000000000000;
assign antidiagonalMasks = 960'h800000000000000040800000000000002040800000000000102040800000000008102040800000000408102040800000020408102040800001020408102040800001020408102040000001020408102000000001020408100000000001020408000000000001020400000000000001020000000000000001;
always @* begin
    bishop = 1 << (rank * 8 + file);
    diagonal_mask = diagonalMasks[(4'h7 - rank + file)*64 +: 64];
    antidiagonal_mask = antidiagonalMasks[(file + rank)*64 +: 64]; 

    diagonal_attack = diagonal_ray_attack(occupied, bishop, diagonal_mask) | diagonal_ray_attack(occupied, bishop, antidiagonal_mask);
end
function automatic [63:0] diagonal_ray_attack(input [63:0] occupied, input [63:0] bishop, input[63:0] mask);
reg [63:0] forward;
reg [63:0] reverse;
begin
    forward =  0 ;
    reverse =  0 ;
    forward = (occupied & ~bishop) & mask;
    reverse = vertical_flip(forward);
    forward -= bishop;
    reverse -= vertical_flip(bishop);
    forward ^= vertical_flip(reverse);
    forward &= mask;
    diagonal_ray_attack = forward;
end
endfunction

endmodule