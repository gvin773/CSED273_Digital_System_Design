/* CSED273 lab5 experiment 1 */
/* lab5_1.v */

`timescale 1ps / 1fs

module halfAdder(
    input in_a,
    input in_b,
    output out_s,
    output out_c
    );

    assign out_s = in_a ^ in_b;
    assign out_c = in_a & in_b;

endmodule

module fullAdder(
    input in_a,
    input in_b,
    input in_c,
    output out_s,
    output out_c
    );

    wire S, C, C2;
    halfAdder inst1(in_a, in_b, S, C);
    halfAdder inst2(S, in_c, out_s, C2);
    assign out_c = C | C2;

endmodule

/* Implement adder 
 * You must not use Verilog arithmetic operators */
module adder(
    input [3:0] x,
    input [3:0] y,
    input c_in,             // Carry in
    output [3:0] out,
    output c_out            // Carry out
); 

    wire [3:0] c;
    fullAdder inst1(x[0], y[0], c_in, out[0], c[1]);
    fullAdder inst2(x[1], y[1], c[1], out[1], c[2]);
    fullAdder inst3(x[2], y[2], c[2], out[2], c[3]);
    fullAdder inst4(x[3], y[3], c[3], out[3], c_out);

endmodule

/* Implement arithmeticUnit with adder module
 * You must use one adder module.
 * You must not use Verilog arithmetic operators */
module arithmeticUnit(
    input [3:0] x,
    input [3:0] y,
    input [2:0] select,
    output [3:0] out,
    output c_out            // Carry out
);

    wire [3:0] A;
    assign A[0] = (select[2] & ~y[0]) | (select[1] & y[0]);
    assign A[1] = (select[2] & ~y[1]) | (select[1] & y[1]);
    assign A[2] = (select[2] & ~y[2]) | (select[1] & y[2]);
    assign A[3] = (select[2] & ~y[3]) | (select[1] & y[3]);
    
    adder add(x, A, select[0], out, c_out);

endmodule

/* Implement 4:1 mux */
module mux4to1(
    input [3:0] in,
    input [1:0] select,
    output out
);

    wire [3:0] data;
    assign data[0] = ~select[0] & ~select[1] & in[0];
    assign data[1] = select[0] & ~select[1] & in[1];
    assign data[2] = ~select[0] & select[1] & in[2];
    assign data[3] = select[0] & select[1] & in[3];
    
    assign out = data[0] | data[1] | data[2] | data[3];

endmodule

/* Implement logicUnit with mux4to1 */
module logicUnit(
    input [3:0] x,
    input [3:0] y,
    input [1:0] select,
    output [3:0] out
);

    wire [3:0] in0;
    assign in0[0] = x[0] & y[0];
    assign in0[1] = x[0] | y[0];
    xor(in0[2], x[0], y[0]);
    assign in0[3] = ~x[0];
    mux4to1 mux0(in0, select, out[0]);
    
    wire [3:0] in1;
    assign in1[0] = x[1] & y[1];
    assign in1[1] = x[1] | y[1];
    xor(in1[2], x[1], y[1]);
    assign in1[3] = ~x[1];
    mux4to1 mux1(in1, select, out[1]);
    
    wire [3:0] in2;
    assign in2[0] = x[2] & y[2];
    assign in2[1] = x[2] | y[2];
    xor(in2[2], x[2], y[2]);
    assign in2[3] = ~x[2];
    mux4to1 mux2(in2, select, out[2]);
    
    wire [3:0] in3;
    assign in3[0] = x[3] & y[3];
    assign in3[1] = x[3] | y[3];
    xor(in3[2], x[3], y[3]);
    assign in3[3] = ~x[3];
    mux4to1 mux3(in3, select, out[3]);

endmodule

/* Implement 2:1 mux */
module mux2to1(
    input [1:0] in,
    input  select,
    output out
);

    wire [1:0] data;
    assign data[0] = ~select & in[0];
    assign data[1] = select & in[1];
    
    assign out = data[0] | data[1];

endmodule

/* Implement ALU with mux2to1 */
module lab5_1(
    input [3:0] x,
    input [3:0] y,
    input [3:0] select,
    output [3:0] out,
    output c_out            // Carry out
);

    wire [3:0] d0;
    arithmeticUnit aunit(x, y, select[2:0], d0, c_out);
    wire [3:0] d1;
    logicUnit lunit(x, y, select[1:0], d1);
    
    wire [1:0] Q0;
    assign Q0[0] = d0[0];
    assign Q0[1] = d1[0];
    mux2to1 mux_output0(Q0, select[3], out[0]);
    wire [1:0] Q1;
    assign Q1[0] = d0[1];
    assign Q1[1] = d1[1];
    mux2to1 mux_output1(Q1, select[3], out[1]);
    wire [1:0] Q2;
    assign Q2[0] = d0[2];
    assign Q2[1] = d1[2];
    mux2to1 mux_output2(Q2, select[3], out[2]);
    wire [1:0] Q3;
    assign Q3[0] = d0[3];
    assign Q3[1] = d1[3];
    mux2to1 mux_output3(Q3, select[3], out[3]);

endmodule
