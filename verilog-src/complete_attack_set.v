module Complete_Attack_Set(
    //inputs
    piece_bitboards_flattened,
    is_white,
    //output
    attack_set
);

input [64*12-1:0] piece_bitboards_flattened;
input is_white;
output reg [63:0] attack_set;

wire [63:0] king_attack;
wire [63:0] knight_attack;
wire [63:0] bishop_attack;
wire [63:0] black_pawn_attack;
wire [63:0] white_pawn_attack;
wire [63:0] rook_attack;
wire [63:0] queen_attack;
wire [63:0] all_position;
wire [63:0] black_position;
wire [63:0] white_position;

wire [3:0] index_offset;
assign index_offset = is_white ? 6 : 0;

King_Attack k1(piece_bitboards_flattened[(index_offset + 5) * 64 +: 64], king_attack);
Knight_Attack n1(piece_bitboards_flattened[(index_offset + 1) * 64 +: 64], knight_attack);
Black_Pawn_Attack bpa(piece_bitboards_flattened[0*64 +: 64], black_pawn_attack);
White_Pawn_Attack wpa(piece_bitboards_flattened[6*64 +: 64], white_pawn_attack);
All_Position ap(piece_bitboards_flattened, all_position);
Black_Position bp(piece_bitboards_flattened, black_position);
White_Position wp(piece_bitboards_flattened, white_position); 

assign bishop_attack = noEaAttacks(piece_bitboards_flattened[(index_offset + 2) * 64 +: 64], ~all_position) | 
noWeAttacks(piece_bitboards_flattened[(index_offset + 2) * 64 +: 64], ~all_position) | 
soEaAttacks(piece_bitboards_flattened[(index_offset + 2) * 64 +: 64], ~all_position) | 
soWeAttacks(piece_bitboards_flattened[(index_offset + 2) * 64 +: 64], ~all_position); 

assign rook_attack = nortAttacks(piece_bitboards_flattened[(index_offset + 3) * 64 +: 64], ~all_position) |
soutAttacks(piece_bitboards_flattened[(index_offset + 3) * 64 +: 64], ~all_position) |
westAttacks(piece_bitboards_flattened[(index_offset + 3) * 64 +: 64], ~all_position) |
eastAttacks(piece_bitboards_flattened[(index_offset + 3) * 64 +: 64], ~all_position); 

assign queen_attack = noEaAttacks(piece_bitboards_flattened[(index_offset + 4) * 64 +: 64], ~all_position) | 
noWeAttacks(piece_bitboards_flattened[(index_offset + 4) * 64 +: 64], ~all_position) | 
soEaAttacks(piece_bitboards_flattened[(index_offset + 4) * 64 +: 64], ~all_position) | 
soWeAttacks(piece_bitboards_flattened[(index_offset + 4) * 64 +: 64], ~all_position) |
nortAttacks(piece_bitboards_flattened[(index_offset + 4) * 64 +: 64], ~all_position) |
soutAttacks(piece_bitboards_flattened[(index_offset + 4) * 64 +: 64], ~all_position) |
westAttacks(piece_bitboards_flattened[(index_offset + 4) * 64 +: 64], ~all_position) |
eastAttacks(piece_bitboards_flattened[(index_offset + 4) * 64 +: 64], ~all_position); 



always @* begin
    if(is_white) begin
        attack_set = white_pawn_attack;
    end
    else begin
        attack_set = black_pawn_attack;
    end
    attack_set = attack_set | king_attack | knight_attack | bishop_attack | rook_attack | queen_attack;
    if(is_white) begin
        attack_set = attack_set & ~white_position;
    end
    else begin
        attack_set = attack_set & ~black_position;
    end
    // attack_set = rook_attack;
end


//Dumb7Fill algorithms
function automatic [63:0] soutAttacks(input [63:0] rooks, input [63:0] empty);
begin
   soutAttacks = rooks;
   rooks = (rooks >> 8) & empty;
   soutAttacks = soutAttacks | rooks;
   rooks = (rooks >> 8) & empty;
   soutAttacks = soutAttacks | rooks;
   rooks = (rooks >> 8) & empty;
   soutAttacks = soutAttacks | rooks;
   rooks = (rooks >> 8) & empty;
   soutAttacks = soutAttacks | rooks;
   rooks = (rooks >> 8) & empty;
   soutAttacks = soutAttacks | rooks;
   soutAttacks = soutAttacks | (rooks >> 8) & empty;
   soutAttacks = soutAttacks >> 8;
end
endfunction
function automatic [63:0] nortAttacks(input [63:0] rooks, input [63:0] empty);
begin
   nortAttacks = rooks;
   rooks = (rooks << 8) & empty;
   nortAttacks = nortAttacks | rooks;
   rooks = (rooks << 8) & empty;
   nortAttacks = nortAttacks | rooks;
   rooks = (rooks << 8) & empty;
   nortAttacks = nortAttacks | rooks;
   rooks = (rooks << 8) & empty;
   nortAttacks = nortAttacks | rooks;
   rooks = (rooks << 8) & empty;
   nortAttacks = nortAttacks | rooks;
   nortAttacks = nortAttacks | (rooks << 8) & empty;
   nortAttacks = nortAttacks << 8;
end
endfunction
function automatic [63:0] eastAttacks(input [63:0] rooks, input [63:0] empty);
begin
   eastAttacks = rooks;
   empty &= 64'hfefefefefefefefe;
   rooks = (rooks << 1) & empty;
   eastAttacks = eastAttacks | rooks;
   rooks = (rooks << 1) & empty;
   eastAttacks = eastAttacks | rooks;
   rooks = (rooks << 1) & empty;
   eastAttacks = eastAttacks | rooks;
   rooks = (rooks << 1) & empty;
   eastAttacks = eastAttacks | rooks;
   rooks = (rooks << 1) & empty;
   eastAttacks = eastAttacks | rooks;
   eastAttacks = eastAttacks | (rooks << 1) & empty;
   eastAttacks = (eastAttacks << 1) & 64'hfefefefefefefefe;
end
endfunction

function automatic [63:0] noEaAttacks(input [63:0] bishops, input [63:0] empty);
begin
   noEaAttacks = bishops;
   empty &= 64'hfefefefefefefefe;
   bishops = (bishops << 9) & empty;
   noEaAttacks = noEaAttacks | bishops;
   bishops = (bishops << 9) & empty;
   noEaAttacks = noEaAttacks | bishops;
   bishops = (bishops << 9) & empty;
   noEaAttacks = noEaAttacks | bishops;
   bishops = (bishops << 9) & empty;
   noEaAttacks = noEaAttacks | bishops;
   bishops = (bishops << 9) & empty;
   noEaAttacks = noEaAttacks | bishops;
   noEaAttacks = noEaAttacks | (bishops << 9) & empty;
   noEaAttacks = (noEaAttacks << 9) & 64'hfefefefefefefefe;
end
endfunction

function automatic [63:0] soEaAttacks(input [63:0] bishops, input [63:0] empty);
begin
   soEaAttacks = bishops;
   empty &= 64'hfefefefefefefefe;
   bishops = (bishops >> 7) & empty;
   soEaAttacks = soEaAttacks | bishops;
   bishops = (bishops >> 7) & empty;
   soEaAttacks = soEaAttacks | bishops;
   bishops = (bishops >> 7) & empty;
   soEaAttacks = soEaAttacks | bishops;
   bishops = (bishops >> 7) & empty;
   soEaAttacks = soEaAttacks | bishops;
   bishops = (bishops >> 7) & empty;
   soEaAttacks = soEaAttacks | bishops;
   soEaAttacks = soEaAttacks | (bishops >> 7) & empty;
   soEaAttacks = (soEaAttacks >> 7) & 64'hfefefefefefefefe;
end
endfunction

function automatic [63:0] westAttacks(input [63:0] rooks, input [63:0] empty);
begin
   westAttacks = rooks;
   empty &= 64'h7f7f7f7f7f7f7f7f;
   rooks = (rooks >> 1) & empty;
   westAttacks = westAttacks | rooks;
   rooks = (rooks >> 1) & empty;
   westAttacks = westAttacks | rooks;
   rooks = (rooks >> 1) & empty;
   westAttacks = westAttacks | rooks;
   rooks = (rooks >> 1) & empty;
   westAttacks = westAttacks | rooks;
   rooks = (rooks >> 1) & empty;
   westAttacks = westAttacks | rooks;
   westAttacks = westAttacks | (rooks >> 1) & empty;
   westAttacks = (westAttacks >> 1) & 64'h7f7f7f7f7f7f7f7f;
end
endfunction

function automatic [63:0] soWeAttacks(input [63:0] bishops, input [63:0] empty);
begin
   soWeAttacks = bishops;
   empty &= 64'h7f7f7f7f7f7f7f7f;
   bishops = (bishops >> 9) & empty;
   soWeAttacks = soWeAttacks | bishops;
   bishops = (bishops >> 9) & empty;
   soWeAttacks = soWeAttacks | bishops;
   bishops = (bishops >> 9) & empty;
   soWeAttacks = soWeAttacks | bishops;
   bishops = (bishops >> 9) & empty;
   soWeAttacks = soWeAttacks | bishops;
   bishops = (bishops >> 9) & empty;
   soWeAttacks = soWeAttacks | bishops;
   soWeAttacks = soWeAttacks | (bishops >> 9) & empty;
   soWeAttacks = (soWeAttacks >> 9) & 64'h7f7f7f7f7f7f7f7f;
end
endfunction

function automatic [63:0] noWeAttacks(input [63:0] bishops, input [63:0] empty);
begin
   noWeAttacks = bishops;
   empty &= 64'h7f7f7f7f7f7f7f7f;
   bishops = (bishops << 7) & empty;
   noWeAttacks = noWeAttacks | bishops;
   bishops = (bishops << 7) & empty;
   noWeAttacks = noWeAttacks | bishops;
   bishops = (bishops << 7) & empty;
   noWeAttacks = noWeAttacks | bishops;
   bishops = (bishops << 7) & empty;
   noWeAttacks = noWeAttacks | bishops;
   bishops = (bishops << 7) & empty;
   noWeAttacks = noWeAttacks | bishops;
   noWeAttacks = noWeAttacks | (bishops << 7) & empty;
   noWeAttacks = (noWeAttacks << 7) & 64'h7f7f7f7f7f7f7f7f;
end
endfunction


endmodule