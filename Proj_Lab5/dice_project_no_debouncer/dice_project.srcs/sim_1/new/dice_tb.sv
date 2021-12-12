`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03.12.2021 16:04:40
// Design Name: 
// Module Name: dice_tb
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module dice_tb();

    // TB signals have similar names to the DUT signals
    logic clk                = 1'b0;
    logic reset_ni           = 1'b1;
    logic trig_i             = 1'b0;
    logic dice_done_o        = 1'b0;
    logic [2:0] dice_dout_o;
    
    shortint unsigned itterations_cnt = 0;
 
    // toglge the clock (f=100MHz, T=10ns, Duty Cycle 50%)
    always #5ns clk = ~clk;

    dice_main dice_main_i (.clk        (clk        ),
                           .reset_ni   (reset_ni   ),
                           .trig_i     (trig_i     ),
                           .dice_done_o(dice_done_o),
                           .dice_dout_o(dice_dout_o)  );


    initial begin
    
        // reset pulse
        #201ns;
        reset_ni = 1'b0;
        #15ns;
        reset_ni = 1'b1;
        #200ns;

        repeat(400) begin
        
            itterations_cnt = itterations_cnt + 1;
        
            // trigger the trig_i for longer than a clock clycle
            trig_i <= 1'b1;
            #15ns;
            trig_i <= 1'b0;
            #15ns;
    
            /*  Wait until the previous randomization is complete, then start again.
            
             *  The next wait-statement waits until the first risign edge of the 
                clk occurs "if and only if" the dice_output value is not zero.
                
             *  Our DUT is so written, that the dcie_output is always zero while
                the randomized value is not valid yet.
                
             * The additional 1us delay is just to allow us to see the value in the waveform.     
            */ 
            @(posedge clk iff (dice_dout_o != 3'b0) );  
            #1us;
        end
        $display("Simulation Succesful. %d itterations done.", itterations_cnt);
        $finish();
    end // inital

endmodule
