module tb;

wire [768-1:0] position;
assign position = 768'h00000000000000100000000000400000000000000000008100000000000001000000000080001000000000402110460040000000000000000800000000000000200000000000000004400000000000000008000000000000002040890e000000;
/*
..bq.rk.
...n.pb.
......p.
p..p..Pp
Pppp.P.N
....P.Q.
BPP.N.P.
R...K..R
*/
wire is_valid;
wire [3:0] piece;
wire [768-1:0] new_position;
wire [63:0] all_new;
wire [63:0] all_position;
wire [63:0] diagonal_attack;
wire [63:0] new_en_passant;
wire [63:0] white_attack_set;
wire [63:0] black_attack_set;
wire [768-1:0] castled;
wire [63:0] all_castled;
wire castling_is_valid;
Complete_Move_Verifier cmv(1, 3, 0, 3, 1'h0, position, 64'h0000000000010000, is_valid, piece, new_position, new_en_passant);
All_Position ap(new_position, all_new);
All_Position ap1(position, all_position);
Complete_Attack_Set casw1(position, 1, white_attack_set);
Complete_Attack_Set casb1(position, 0, black_attack_set);
Castling_Checker cc(4, 0, 5, 0, 1, position, castling_is_valid, castled);
All_Position ap2(castled, all_castled);
//Diagonal_Attack da(all_position, 3, 7, diagonal_attack);
always begin
    $display("Is castling valid? %d", castling_is_valid);
    print(all_castled);
    #10;
    $stop;
end

task automatic print(input [63:0] bitboard);
    integer i;
    integer j;
    begin
        $display("----------");
        for(i = 56; i>=0; i = i - 8) begin
            for(j = 0; j < 8; j = j + 1) begin
                $write("%d", bitboard[i+j]);
            end
            $write("\n");
        end 
        $display("------------");
    end
endtask

endmodule