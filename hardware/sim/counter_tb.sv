`timescale 1ns/1ps

module counter_tb();
   // Create necessary variables
   logic aclk;
   logic enable;
   logic aresetn;
   logic inc_dec;
   logic [7:0] start_value;
   logic [7:0] count_out;
    
    // Create Device Under Test (DUT)
   counter uut_1 (
       .aclk(aclk),
       .enable(enable),
       .aresetn(aresetn),
       .inc_dec(inc_dec),
       .start_value(start_value),
       .count_out(count_out)
   );

      // Define clock
   always begin
       #5 aclk = ~aclk;  // Generates a 100MHz clock
   end
   
      // Random test generator
   task random_test();
       fork
           // Randomly drive enable
           forever #10 enable = $urandom_range(0, 1);
           // Randomly set increment or decrement
           forever #15 inc_dec = $urandom_range(0, 1);
           // Randomly change start_value
           forever #25 start_value = $urandom_range(0, 255);
       join
   endtask

   // Functional Coverage
   covergroup cg_counter @(posedge aclk);
       coverpoint enable {
           bins enable_on = {1};
           bins enable_off = {0};
       }
       coverpoint inc_dec {
           bins inc = {0};
           bins dec = {1};
       }
       coverpoint start_value {
           bins start_ranges[] = {[0:50], [51:100], 
                  [101:150], [151:200], [201:255]};
       }
// Cross of enable and increment/decrement
       cross enable, inc_dec; 
   endgroup

   cg_counter cg;

   initial begin
       cg = new();
       // Initial conditions
       aresetn = 0;
       enable = 0;
       aclk = 0;
       start_value = 8'haf;
       inc_dec = 0;

       #100 aresetn = 1;
       #20 enable = 1;

       #100;
       aresetn = 0;
       start_value = 8'hc0;
       aresetn = 1;

       #50 enable = 0;
       #50 enable = 1;
       inc_dec = 1;
       
       // Start random testing after the initial deterministic scenario
       random_test();

       // Sample coverage
       forever begin
           @(posedge aclk) cg.sample();
       end
   end
   
   // Finish simulation after a certain duration
   initial begin
       #1000;  // Run simulation for 1000ns
       $display("Simulation complete.");
       $finish;
   end

endmodule