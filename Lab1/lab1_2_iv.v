/* CSED273 lab1 experiment 2_iv */
/* lab1_2_iv.v */


module lab1_2_iv(outAND, outOR, outNOT, inA, inB);
    output wire outAND, outOR, outNOT;
    input wire inA, inB;

    AND andGate(outAND, inA, inB);
    OR orGate(outOR, inA, inB);
    NOT notGate(outNOT, inA);

endmodule


/* Implement AND, OR, and NOT modules with {NOR}
 * You are only allowed to wire modules below
 * i.e.) No and, or, not, etc. Only nor, AND, OR, NOT are available*/
module AND(outAND, inA, inB);
    output wire outAND;
    input wire inA, inB; 

    nor(a, inA, 0);
    nor(b, inB, 0);
    nor(outAND, a, b);

endmodule

module OR(outOR, inA, inB); 
    output wire outOR;
    input wire inA, inB;

    nor(Z, inA, inB);
    nor(outOR, Z, 0);

endmodule

module NOT(outNOT, inA);
    output wire outNOT;
    input wire inA; 

    nor(outNOT, inA, 0);

endmodule