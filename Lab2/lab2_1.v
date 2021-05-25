/* CSED273 lab2 experiment 1 */
/* lab2_1.v */

/* Unsimplifed equation
 * You are allowed to use keword "assign" and operator "&","|","~",
 * or just implement with gate-level-modeling (and, or, not) */
module lab2_1(
    output wire outGT, outEQ, outLT,
    input wire [1:0] inA,
    input wire [1:0] inB
    );

    CAL_GT cal_gt(outGT, inA, inB);
    CAL_EQ cal_eq(outEQ, inA, inB);
    CAL_LT cal_lt(outLT, inA, inB);
    
endmodule

/* Implement output about "A>B" */
module CAL_GT(
    output wire outGT,
    input wire [1:0] inA,
    input wire [1:0] inB
    );

    wire x1, x2, x3, x4, x5, x6;
    assign x1 = ~inA[1] & inA[0] & ~inB[1] & ~inB[0];
    assign x2 = inA[1] & inA[0] & ~inB[1] & ~inB[0];
    assign x3 = inA[1] & ~inA[0] & ~inB[1] & ~inB[0];
    assign x4 = inA[1] & inA[0] & ~inB[1] & inB[0];
    assign x5 = inA[1] & ~inA[0] & ~inB[1] & inB[0];
    assign x6 = inA[1] & inA[0] & inB[1] & ~inB[0];
    assign outGT = x1 | x2 | x3 | x4 | x5 | x6;

endmodule

/* Implement output about "A=B" */
module CAL_EQ(
    output wire outEQ,
    input wire [1:0] inA, 
    input wire [1:0] inB
    );

    wire x1, x2, x3, x4;
    assign x1 = ~inA[1] & ~inA[0] & ~inB[1] & ~inB[0];
    assign x2 = ~inA[1] & inA[0] & ~inB[1] & inB[0];
    assign x3 = inA[1] & inA[0] & inB[1] & inB[0];
    assign x4 = inA[1] & ~inA[0] & inB[1] & ~inB[0];
    assign outEQ = x1 | x2 | x3 | x4;

endmodule

/* Implement output about "A<B" */
module CAL_LT(
    output wire outLT,
    input wire [1:0] inA, 
    input wire [1:0] inB
    );

    wire x1, x2, x3, x4, x5, x6;
    assign x1 = ~inA[1] & ~inA[0] & ~inB[1] & inB[0];
    assign x2 = ~inA[1] & ~inA[0] & inB[1] & inB[0];
    assign x3 = ~inA[1] & inA[0] & inB[1] & inB[0];
    assign x4 = inA[1] & ~inA[0] & inB[1] & inB[0];
    assign x5 = ~inA[1] & ~inA[0] & inB[1] & ~inB[0];
    assign x6 = ~inA[1] & inA[0] & inB[1] & ~inB[0];
    assign outLT = x1 | x2 | x3 | x4 | x5 | x6;

endmodule