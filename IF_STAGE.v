module IF_STAGE(
  input         clk,
  input         rst,
  input         instr_fetch_enable,
  input [5:0]   imm_branch_offset,
  input         branch_enable,
  input         jump,
  output [7:0]  pc,
  output [15:0] instr
);
        
  wire[7:0] PCI;
  wire[7:0] PCO;
  wire[7:0] PCAdd1O;
  wire[7:0] PC1AddBr8;
  wire[7:0] Br8;
  wire[1:0] Mux4Select;
  
  assign Mux4Select = {jump, branch_enable};
  
  SixToEightExtend mySixToEight(
      .In(imm_branch_offset),
      .Out(Br8)
  );
  
  PC myPC(
      .clock(clk), 
      .reset(rst), 
      .PCEn(instr_fetch_enable),
      .in(PCI), 
      .out(PCO)
  );
  
  Add myPCByOne( 
    .a(PCO),
    .b(8'b00000001),
    .out(PCAdd1O)
  );
  
  Add myPC1ByBz( 
    .a(Br8),
    .b(PCAdd1O),
    .out(PC1AddBr8)
  );
  
  MUX4#(8) myIfMux4(
  .SLCT(Mux4Select), 
  .IN3(), 
  .IN2(Br8), 
  .IN1(PC1AddBr8), 
  .IN0(PCAdd1O), 
  .OT(PCI)
  );
  
  InstructionMemory#(256) myInstMem( 
    .reset(rst),
    .addr(PCO),
    .inst(instr)
  );
  
  assign pc = PCO;
  
endmodule
                  
