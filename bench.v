module bench();
 
  reg clock;
  reg reset;
   
  Project myPRJ(
      .clock(clock),
      .reset(reset)
  );
       
  initial begin
    clock = 0;
    reset = 0;
    
   #300 
    reset = 1;
   #180 
    reset = 0;
  end
  
  always #100 clock = clock + 1;
endmodule