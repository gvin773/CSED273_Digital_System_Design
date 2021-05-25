/* CSED273 lab5 experiment 2 */
/* lab5_2.v */

`timescale 1ns / 1ps

/* Implement srLatch */
module srLatch(
    input s, r,
    output q, q_
    );

    nor(q, q_, r);
    nor(q_, q, s);

endmodule

/* Implement master-slave JK flip-flop with srLatch module */
module lab5_2(
    input reset_n, j, k, clk,
    output q, q_
    );

    wire J1, K1, S1, R1, P, P_;
    assign K1 = q & k & clk;
    assign J1 = clk & j & q_;
    assign R1 = K1 | ~reset_n;
    assign S1 = J1 & reset_n;
    srLatch master(S1, R1, P, P_);
    
    wire S2, R2, Q, Q_;
    assign R2 = P_ & ~clk;
    assign S2 = P & ~clk;
    srLatch slave(S2, R2, Q, Q_);
    
    assign q = Q;
    assign q_ = Q_;
    
endmodule