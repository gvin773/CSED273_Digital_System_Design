/* CSED273 lab6 experiment 3 */
/* lab6_3.v */

`timescale 1ps / 1fs

/* Implement 369 game counter (0, 3, 6, 9, 13, 6, 9, 13, 6 ...)
 * You must first implement D flip-flop in lab6_ff.v
 * then you use D flip-flop of lab6_ff.v */
module counter_369(input reset_n, input clk, output [3:0] count);

    wire da, db, dc, dd;
    assign da = (count[3] & ~count[2]) | (count[1] & ~count[0]);
    assign db = count[0];
    assign dc = (~count[3] & ~count[2]) | (count[2] & ~count[1]);
    assign dd = (~count[3] & ~count[0]) | (count[3] & ~count[2]);
    
    wire qa, qa_, qb, qb_, qc, qc_, qd, qd_;
    edge_trigger_D_FF DA(reset_n, da, clk, qa, qa_);
    edge_trigger_D_FF DB(reset_n, db, clk, qb, qb_);
    edge_trigger_D_FF DC(reset_n, dc, clk, qc, qc_);
    edge_trigger_D_FF DD(reset_n, dd, clk, qd, qd_);
    
    assign count[3] = qa;
    assign count[2] = qb;
    assign count[1] = qc;
    assign count[0] = qd;
	
endmodule
