/* CSED273 lab4 experiment 1 */
/* lab4_1.v */


/* Implement Half Adder
 * You may use keword "assign" and bitwise opeartor
 * or just implement with gate-level modeling*/
module halfAdder(
    input in_a,
    input in_b,
    output out_s,
    output out_c
    );

    assign out_s = in_a ^ in_b;
    assign out_c = in_a & in_b;

endmodule

/* Implement Full Adder
 * You must use halfAdder module
 * You may use keword "assign" and bitwise opeartor
 * or just implement with gate-level modeling*/
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