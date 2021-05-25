/* CSED273 lab2 experiment 2 */
/* lab2_2.v */

/* Simplifed equation by K-Map method
 * You are allowed to use keword "assign" and operator "&","|","~",
 * or just implement with gate-level-modeling (and, or, not) */
module lab2_2(
    output wire outGT, outEQ, outLT,
    input wire [1:0] inA,
    input wire [1:0] inB
    );

    CAL_GT_2 cal_gt2(outGT, inA, inB);
    CAL_EQ_2 cal_eq2(outEQ, inA, inB);
    CAL_LT_2 cal_lt2(outLT, inA, inB);

endmodule

/* Implement output about "A>B" */
module CAL_GT_2(
    output wire outGT,
    input wire [1:0] inA,
    input wire [1:0] inB
    );

    wire x1, x2, x3;
    assign x1 = inA[1] & ~inB[1];
    assign x2 = inA[0] & ~inB[1] & ~inB[0];
    assign x3 = inA[1] & inA[0] & ~inB[0];
    assign outGT = x1 | x2 | x3;

endmodule

/* Implement output about "A=B" */
module CAL_EQ_2(
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
module CAL_LT_2(
    output wire outLT,
    input wire [1:0] inA, 
    input wire [1:0] inB
    );

    wire x1, x2, x3;
    assign x1 = ~inA[1] & inB[1];
    assign x2 = ~inA[1] & ~inA[0] & inB[0];
    assign x3 = ~inA[0] & inB[1] & inB[0];
    assign outLT = x1 | x2 | x3;

endmodule