/* CSED273 lab4 experiment 4 */
/* lab4_4.v */

/* Implement 5x3 Binary Mutliplier
 * You must use lab4_2 module in lab4_2.v
 * You cannot use fullAdder or halfAdder module directly
 * You may use keword "assign" and bitwise opeartor
 * or just implement with gate-level modeling*/
module lab4_4(
    input [4:0]in_a,
    input [2:0]in_b,
    output [7:0]out_m
    );
    
    wire [4:0] x1;
    wire [4:0] x2;
    wire [4:0] x3;
    wire [4:0] x4;
    
    assign out_m[0] = in_a[0] & in_b[0];
    
    assign x1 = {1'b0, in_a[4]&in_b[0], in_a[3]&in_b[0], in_a[2]&in_b[0], in_a[1]&in_b[0]};
    assign x2 = {in_a[4]&in_b[1], in_a[3]&in_b[1], in_a[2]&in_b[1], in_a[1]&in_b[1], in_a[0]&in_b[1]};
    
    lab4_2 inst1(x1, x2, 1'b0, {x3[3], x3[2], x3[1], x3[0], out_m[1]}, x3[4]);
    
    assign x4 = {in_a[4]&in_b[2], in_a[3]&in_b[2], in_a[2]&in_b[2], in_a[1]&in_b[2], in_a[0]&in_b[2]};
    
    lab4_2 inst2(x3, x4, 1'b0, {out_m[6], out_m[5], out_m[4], out_m[3], out_m[2]}, out_m[7]);
    
endmodule