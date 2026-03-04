`timescale 1ns / 1ps

module comp(
    input [31:0] a,
    input [31:0] b,
    output logic gt,
    output logic eq,
    output logic lt
    );
    
    logic [31:0] eq_bit;
    logic [32:0] eq_prefix;  // Дополнительный бит для удобства
    
    assign eq_bit = ~(a ^ b);
    
    // eq_prefix[i] = 1 если все биты от i до 31 равны
    // eq_prefix[32] = 1 для упрощения логики (пустое множество битов)
    assign eq_prefix[32] = 1'b1;
    
    generate
        genvar i;
        for (i = 31; i >= 0; i--) begin : eq_prefix_gen
            assign eq_prefix[i] = eq_bit[i] & eq_prefix[i+1];
        end
    endgenerate
    
    logic [31:0] gt_temp;
    logic [31:0] lt_temp;
    
    generate
        for (i = 0; i < 32; i++) begin : gt_lt_gen
            // a[i] > b[i] и все старшие биты равны
            assign gt_temp[i] = a[i] & ~b[i] & eq_prefix[i+1];
            // a[i] < b[i] и все старшие биты равны  
            assign lt_temp[i] = ~a[i] & b[i] & eq_prefix[i+1];
        end
    endgenerate
    
    assign gt = |gt_temp;
    assign lt = |lt_temp;
    assign eq = &eq_bit;
    
endmodule
