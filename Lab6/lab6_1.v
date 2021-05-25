/* CSED273 lab6 experiment 1 */
/* lab6_1.v */

`timescale 1ps / 1fs

/* Implement synchronous BCD decade counter (0-9)
 * You must use JK flip-flop of lab6_ff.v */
module decade_counter(input reset_n, input clk, output [3:0] count);

    wire qa, q_a, qb, q_b, qc, q_c, qd, q_d;
    wire Ja, Ka, Jb, Kb, Jc, Kc, Jd, Kd;
    
    assign Ja = count[2] & count[1] & count[0];
    assign Ka = count[3] & count[0];
    assign Jb = count[1] & count[0];
    assign Kb = count[1] & count[0];
    assign Jc = ~count[3] & count[0];
    assign Kc = ~count[3] & count[0];
    assign Jd = 1;
    assign Kd = 1;
    
    edge_trigger_JKFF outA(reset_n, Ja, Ka, clk, qa, q_a);
    edge_trigger_JKFF outB(reset_n, Jb, Kb, clk, qb, q_b);
    edge_trigger_JKFF outC(reset_n, Jc, Kc, clk, qc, q_c);
    edge_trigger_JKFF outD(reset_n, Jd, Kd, clk, qd, q_d);
    
    assign count[3] = qa;
    assign count[2] = qb;
    assign count[1] = qc;
    assign count[0] = qd;
	
endmodule