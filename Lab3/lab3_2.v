/* CSED273 lab3 experiment 2 */
/* lab3_2.v */


/* Implement Prime Number Indicator & Multiplier Indicator
 * You may use keword "assign" and operator "&","|","~",
 * or just implement with gate-level-modeling (and, or, not) */
 
/* 11: out_mul[4], 7: out_mul[3], 5: out_mul[2],
 * 3: out_mul[1], 2: out_mul[0] */
module lab3_2(
    input wire [3:0] in,
    output wire out_prime,
    output wire [4:0] out_mul
    );
    
    wire x1, x2, x3, x4;
    assign x1 = ~in[3] & ~in[2] & in[1];
    assign x2 = ~in[2] & in[1] & in[0];
    assign x3 = ~in[3] & in[2] & in[0];
    assign x4 = in[2] & ~in[1] & in[0];
    assign out_prime = x1 | x2 | x3 | x4;
    
    wire m2_1, m2_2;
    assign m2_1 = ~in[1] & ~in[0];
    assign m2_2 = in[1] & ~in[0];
    assign out_mul[0] = m2_1 | m2_2;
    
    wire m3_1, m3_2, m3_3, m3_4, m3_5;
    assign m3_1 = in[3] & in[2] & ~in[1] & ~in[0];
    assign m3_2 = in[3] & ~in[2] & ~in[1] & in[0];
    assign m3_3 = ~in[3] & ~in[2] & in[1] & in[0];
    assign m3_4 = in[3] & in[2] & in[1] & in[0];
    assign m3_5 = ~in[3] & in[2] & in[1] & ~in[0];
    assign out_mul[1] = m3_1 | m3_2 | m3_3 | m3_4 | m3_5;
    
    wire m5_1, m5_2, m5_3;
    assign m5_1 = ~in[3] & in[2] & ~in[1] & in[0];
    assign m5_2 = in[3] & in[2] & in[1] & in[0];
    assign m5_3 = in[3] & ~in[2] & in[1] & ~in[0];
    assign out_mul[2] = m5_1 | m5_2 | m5_3;
    
    wire m7_1, m7_2;
    assign m7_1 = ~in[3] & in[2] & in[1] & in[0];
    assign m7_2 = in[3] & in[2] & in[1] & ~in[0];
    assign out_mul[3] = m7_1 | m7_2;
    
    assign out_mul[4] = in[3] & ~in[2] & in[1] & in[0];
    
endmodule