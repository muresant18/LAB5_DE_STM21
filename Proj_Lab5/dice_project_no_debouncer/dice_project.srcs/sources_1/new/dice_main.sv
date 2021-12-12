`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03.12.2021 15:19:28
// Design Name: 
// Module Name: dice_main
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


module dice_main(
    input clk,
    input reset_ni,
    input trig_i,
    output dice_done_o,
    output [2:0] dice_dout_o
    );
    
    `define LSF_reg_size 8
    
    // signals for the LSF register
    logic [`LSF_reg_size:0] LSF_reg = 8'b_0000_0001;
    logic x1, x2, x3 = 1'b0;
    logic dice_value_valid = 1'b0;
    
    // signals/variables for the MODULO-counter
    logic [2:0] mod_cnt_val = 3'd1;
    logic mod_cnt_en = 1'b0;
    
    // signals/variables for the DOWN-counter
    logic [`LSF_reg_size:0] n_value = 8'b0;
    logic [`LSF_reg_size:0] down_cnt_value = 8'b0;
    
    // internal signal which will be assigned to the output
    logic [2:0] dice_dout_value = 3'b0;
    
    // =================================================== LSFR ===================================
    // sequential part of the LSF register
    always_ff @(posedge clk) begin  
    
        if (!reset_ni)
            LSF_reg <= `LSF_reg_size'b_0000_0001;
        else begin
            if (trig_i) begin
                //shift the LSFR once
                LSF_reg[0] <= LSF_reg[1];
                LSF_reg[1] <= LSF_reg[2];
                LSF_reg[2] <= LSF_reg[3];
                LSF_reg[3] <= LSF_reg[4];
                LSF_reg[4] <= LSF_reg[5];
                LSF_reg[5] <= LSF_reg[6];
                LSF_reg[6] <= LSF_reg[7];
                LSF_reg[7] <= x3;
            end
        end
    end //ff

    // combinational part of the LSF register
    always_comb begin
        x1 <= LSF_reg[0] ^ LSF_reg[2];
        x2 <= x1 ^ LSF_reg[3];
        x3 <= x2 ^ LSF_reg[4];
        n_value <= LSF_reg;
    end
    
        
    // ====================================== DOWN COUUNTER ===================================
    always_ff @(posedge clk) begin  
        
        dice_value_valid <= 1'b0;
        
        if (!reset_ni) begin
            down_cnt_value <= `LSF_reg_size'b0;
            dice_value_valid <= 1'b0;
            
        end else begin
        
            if (down_cnt_value > 8'b0) begin
                mod_cnt_en <= 1'b1;
                down_cnt_value <= down_cnt_value - 1;
                dice_value_valid <= 1'b0;
                
            end else if(down_cnt_value == 8'b0) begin
                dice_value_valid <= 1'b1;
                if (trig_i) begin
                    down_cnt_value <= n_value;
                end              
            end
        end //reset    
    end //ff
    
    
    // =============================================== MODULO COUNTER ===================================
    always_ff @(posedge clk) begin  
    
        if (!reset_ni) begin
            mod_cnt_val <= 3'd1;
        end else begin
            
            if(mod_cnt_en && (!dice_value_valid)) begin
                if(mod_cnt_val >= 3'd6) begin
                    mod_cnt_val <= 3'd1;
                end else begin
                    mod_cnt_val <= mod_cnt_val + 1;
                end
            end
        end
    end    

    // =============================================== OTHER SIGNALS ====================================
    always_comb begin
        if (dice_value_valid)
            dice_dout_value <= mod_cnt_val;
        else 
            dice_dout_value <= 3'b0;
    end

    // assign the internal signals to the output
    assign dice_dout_o = dice_dout_value;
    assign dice_done_o = dice_value_valid;
    
endmodule
