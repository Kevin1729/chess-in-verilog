`ifndef _utility_vh_ 
`define _utility_vh_
// function automatic [63:0] vertical_flip(input [63:0] input_bits);
// reg [63:0] bitsCopy;
// reg [63:0] k1;
// reg [63:0] k2;
// begin
//     bitsCopy = input_bits;
//     k1 = 64'h00FF00FF00FF00FF;
//     k2 = 64'h0000FFFF0000FFFF;
//     bitsCopy = ((bitsCopy >> 8) & k1) | ((bitsCopy & k1) << 8);
//     bitsCopy = ((bitsCopy >> 16) & k2) | ((bitsCopy & k2) << 16);
//     bitsCopy = (bitsCopy >> 32) | (bitsCopy << 32);
//     vertical_flip = bitsCopy;
// end
// endfunction
function automatic [63:0] vertical_flip(input [63:0] input_bits);
integer file;
integer rank;
begin
    for(rank = 0; rank < 8; rank = rank + 1) begin
        for(file = 0; file < 8; file = file + 1) begin
            vertical_flip[(8 * (7-rank) + file)] = input_bits[8 * (rank) + file];
        end
    end
end
endfunction

// function automatic [63:0] diagonal_flip(input [63:0] input_bits);
// reg [63:0] bitsCopy;
// reg [63:0] t;
// reg [63:0] k1;
// reg [63:0] k2;
// reg [63:0] k4;
// begin
//     bitsCopy = input_bits;
//     k1 = 64'h5500550055005500;
//     k2 = 64'h3333000033330000;
//     k4 = 64'h0f0f0f0f00000000;
//     t = k4 & (bitsCopy ^ (bitsCopy << 28));
//     bitsCopy ^= t ^ (t >> 28);
//     t = k2 & (bitsCopy ^ (bitsCopy << 14));
//     bitsCopy ^= t ^ (t >> 14);
//     t = k1 & (bitsCopy ^ (bitsCopy << 7));
//     bitsCopy ^= t ^ (t >> 7);
//     diagonal_flip = bitsCopy;
// end
// endfunction

function automatic [63:0] diagonal_flip(input [63:0] input_bits);
integer file;
integer rank;
begin
for(rank = 0; rank < 8; rank = rank + 1) begin
    for(file = 0; file < 8; file = file + 1) begin
        diagonal_flip[8 * (file) + rank] = input_bits[8 * (rank) + file];
    end
end
end
endfunction

// function automatic [63:0] antidiagonal_flip(input [63:0] input_bits);
// reg [63:0] bitsCopy;
// reg [63:0] t;
// reg [63:0] k1;
// reg [63:0] k2;
// reg [63:0] k4;
// begin
//     bitsCopy = input_bits;
//     k1 = 64'haa00aa00aa00aa00;
//     k2 = 64'hcccc0000cccc0000;
//     k4 = 64'hf0f0f0f00f0f0f0f;
//     t = bitsCopy ^ (bitsCopy << 36);
//     bitsCopy ^= k4 & (t ^ (bitsCopy >> 36));
//     t = k2 & (bitsCopy ^ (bitsCopy << 18));
//     bitsCopy ^= t ^ (t >> 18);
//     t = k1 & (bitsCopy ^ (bitsCopy << 9));
//     bitsCopy ^= t ^ (t >> 9);
//     antidiagonal_flip = bitsCopy;
// end
// endfunction

function automatic [63:0] antidiagonal_flip(input [63:0] input_bits);
integer file;
integer rank;
for(rank = 0; rank < 8; rank = rank + 1) begin
    for(file = 0; file < 8; file = file + 1) begin
        antidiagonal_flip[8 * (7 - file) + 7 - rank] = input_bits[8 * rank + file];
    end
end
endfunction

// function automatic [63:0] rotate_clockwise(input [63:0] input_bits);
// begin
//     rotate_clockwise = antidiagonal_flip(vertical_flip(input_bits));
// end
// endfunction
function automatic [63:0] rotate_clockwise(input [63:0] input_bits);
integer file;
integer rank;
for(rank = 0; rank < 8; rank = rank + 1) begin
    for(file = 0; file < 8; file = file + 1) begin
        rotate_clockwise[8 * (7 - file) + rank] = input_bits[8 * rank + file];
    end
end
endfunction

// function automatic [63:0] rotate_counterclockwise(input [63:0] input_bits);
// begin
//     rotate_counterclockwise = diagonal_flip(vertical_flip(input_bits));
// end
// endfunction
function automatic [63:0] rotate_counterclockwise(input [63:0] input_bits);
integer file;
integer rank;
for(rank = 0; rank < 8; rank = rank + 1) begin
    for(file = 0; file < 8; file = file + 1) begin
        rotate_counterclockwise[8 * file + 7 - rank] = input_bits[8 * rank + file];
    end
end
endfunction
`endif