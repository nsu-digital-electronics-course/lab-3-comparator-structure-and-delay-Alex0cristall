`timescale 1ns / 1ps

module comp(
    input [31:0] a,
    input [31:0] b,
    output logic gt,
    output logic eq,
    output logic lt
    );
    

    logic [31:0] bit_gt; 
    logic [31:0] bit_lt; 
    logic [31:0] bit_eq;  

    genvar i;
    generate
        for (i = 0; i < 32; i++) begin : bit_comp
            assign bit_gt[i] =  a[i] & ~b[i];
            assign bit_lt[i] = ~a[i] &  b[i];
            assign bit_eq[i] = a[i] ^~ b[i];
        end
    endgenerate


    logic [31:0] higher_eq;

    assign higher_eq[31] = 1'b1;  

    generate
        for (i = 30; i >= 0; i--) begin : higher_eq_chain
            assign higher_eq[i] = higher_eq[i+1] & bit_eq[i+1];
        end
    endgenerate


    logic [31:0] first_gt;
    logic [31:0] first_lt;

    generate
        for (i = 0; i < 32; i++) begin : first_diff
            assign first_gt[i] = higher_eq[i] & bit_gt[i];
            assign first_lt[i] = higher_eq[i] & bit_lt[i];
        end
    endgenerate

   
    assign gt = |first_gt;       
    assign lt = |first_lt;       
    assign eq = ~(gt | lt);      
    
endmodule
