module Knight_Attack(
    //inputs
    knights,
    //outputs
    knight_attack
);

input [63:0] knights;
output reg [63:0] knight_attack;

reg [63:0] l1;
reg [63:0] l2;
reg [63:0] r1;
reg [63:0] r2;
reg [63:0] h1;
reg [63:0] h2;

always @* begin
    l1 <= (knights >> 1) & (64'h7f7f7f7f7f7f7f7f);
    l2 <= (knights >> 2) & (64'h3f3f3f3f3f3f3f3f);
    r1 <= (knights << 1) & (64'hfefefefefefefefe);
    r2 = (knights << 2) & (64'hfcfcfcfcfcfcfcfc);
    h1 <= l1 | r1;
    h2 = l2 | r2;
    knight_attack = (h1<<16) | (h1>>16) | (h2<<8) | (h2>>8);
end

endmodule