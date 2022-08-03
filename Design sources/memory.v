`timescale 1ns / 1ps

module memory(input clk, input MemRead, input MemWrite, Sign, input [11:0] addr, input [31:0] data_in, input[1:0] type, output reg [31:0] data_out);
parameter memSize=256;
parameter offset=200;

reg [7:0] mem [0 : memSize-1];
parameter byte = 0;
parameter half = 1;
parameter word = 2;

reg [11:0] datamemvalue;
always @(*)begin
    if(~clk)
    datamemvalue = offset + addr;
end
always @(*)begin
    if (clk)
        data_out = {mem[addr+3], mem[addr+2], mem[addr+1], mem[addr]};
    else begin
    if(MemRead)begin
        case(type)
        byte: begin
            if(Sign)begin
                data_out = { {24{mem[datamemvalue][7]}} , mem[datamemvalue]};
            end
            else begin
                data_out = {24'd0, mem[datamemvalue]};
            end
        end
        half: begin
            if(Sign)begin
                data_out = { {16{mem[1+datamemvalue][7]}} , mem[1+datamemvalue], mem[datamemvalue]};
            end
            else begin
                data_out = {16'd0, mem[1+datamemvalue], mem[datamemvalue]};
            end
        end
        
        word: data_out = {mem[datamemvalue+3], mem[datamemvalue+2], mem[datamemvalue+1], mem[datamemvalue]};
        default: data_out = 0;
    endcase
    end
    else begin
        data_out = {32{1'b0}};
    end
end
end

always @(negedge clk)begin
    if(MemWrite == 1) begin
        case(type)
        byte: mem[datamemvalue] = data_in[7:0];
        half: {mem[1+datamemvalue], mem[datamemvalue]} = data_in[15:0];
        word: {mem[datamemvalue+3], mem[2+datamemvalue], mem[1+datamemvalue], mem[datamemvalue]} = data_in;
    endcase
    end
end





 



initial begin
//{mem[3], mem[2],mem[1], mem[0]}=32'b0000000_00000_00000_000_00000_0110011 ; //add x0, x0, x0   
//  //added to be skipped since PC starts with 4 after reset              
//  {mem[7], mem[6],mem[5], mem[4]}=32'h01400a13;//b000000000000_00000_010_00001_0000011 ; //lw x1, 0(x0)      x1->17   
//  {mem[11], mem[10],mem[9], mem[8]}=32'h000a0ab3;//b000000000100_00000_010_00010_0000011 ; //lw x2, 4(x0)      x2->9
//  {mem[15], mem[14],mem[13], mem[12]}=32'h001acb13;//b000000001000_00000_010_00011_0000011 ; //lw x3, 8(x0)      x3->25
////    {mem[7], mem[6],mem[5], mem[4]}=32'h06402083;//b000000000000_00000_010_00001_0000011 ; //lw x1, 0(x0)      x1->17   
////  {mem[11], mem[10],mem[9], mem[8]}=32'h06802103;//b000000000100_00000_010_00010_0000011 ; //lw x2, 4(x0)      x2->9
////  {mem[15], mem[14],mem[13], mem[12]}=32'h06c02183;//b000000001000_00000_010_00011_0000011 ; //lw x3, 8(x0)      x3->25
//  {mem[19], mem[18],mem[17], mem[16]}=32'h015a0663;//b0000000_00010_00001_110_00100_0110011 ; //or x4, x1, x2    x4->25
//  {mem[23], mem[22],mem[21], mem[20]}=32'h015a8ab3;//015a8ab; //beq x4, x3, 4                                  branch taken
//  {mem[27], mem[26],mem[25], mem[24]}=32'h016b0b33;
//  {mem[31], mem[30],mem[29], mem[28]}=32'h00200093;//b0000000_00010_00001_000_00011_0110011 ; //add x3, x1, x2   x3->26
//  {mem[35], mem[34],mem[33], mem[32]}=32'h001a1133;//b0000000_00010_00011_000_00101_0110011 ; //add x5, x3, x2   branch here x5->34
//  {mem[39], mem[38],mem[37], mem[36]}=32'h401151b3;//06502823;//b0000000_00101_00000_010_01100_0100011; //sw x5, 12(x0)     store 34 in Mem[12]
//   {mem[43], mem[42],mem[41], mem[40]}=32'h01419663;//07002303;//b000000001100_00000_010_00110_0000011 ; //lw x6, 12(x0)    load x6->34
//   {mem[47], mem[46],mem[45], mem[44]}=32'h001101b3;//b0000000_00001_00110_111_00111_0110011 ; //and x7, x6, x1 x7->0
//    {mem[51], mem[50],mem[49], mem[48]}=32'h00218193;//b0100000_00010_00001_000_01000_0110011 ; //sub x8, x1, x2 x8->8
//   {mem[55], mem[54],mem[53], mem[52]}=32'h00100073;//b0000000_00010_00001_000_00000_0110011 ; //add x0, x1, x2 x0->0
////   {mem[55], mem[54],mem[53], mem[52]}=32'b0000000_00001_00000_000_01001_0110011 ; //add x9, x0, x1 x9->17
//   {mem[59], mem[58],mem[57], mem[56]} = 32'h00500293;
    $readmemh("hexfile2.hex", mem);
    
    
//    {mem[503], mem[502], mem[501] ,mem[500]}=32'd17;
//    {mem[507], mem[506], mem[505] ,mem[504]}=32'd9; 
//    {mem[511], mem[510], mem[509] ,mem[508]}=32'd25;
// {mem[103], mem[102], mem[101] ,mem[100]}=32'd17;
//{mem[107], mem[106], mem[105] ,mem[104]}=32'd9; 
//{mem[111], mem[110], mem[109] ,mem[108]}=32'd25;
end
endmodule