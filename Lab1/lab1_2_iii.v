/* CSED273 lab1 experiment 2_iii */
/* lab1_2_iii.v */


module lab1_2_iii(outAND, outOR, outNOT, inA, inB);
    output wire outAND, outOR, outNOT;
    input wire inA, inB;

    AND andGate(outAND, inA, inB);
    OR orGate(outOR, inA, inB);
    NOT notGate(outNOT, inA);

endmodule


/* Implement AND, OR, and NOT modules with {NAND}
 * You are only allowed to wire modules below
 * i.e.) No and, or, not, etc. Only nand, AND, OR, NOT are available*/
module AND(outAND, inA, inB);
    output wire outAND;
    input wire inA, inB; 

    nand(Z, inA, inB);
    nand(outAND, Z, 1);

endmodule

module OR(outOR, inA, inB);
    output wire outOR;
    input wire inA, inB; 
    
    nand(a, inA, 1);
    nand(b, inB, 1);
    nand(outOR, a, b);

endmodule

module NOT(outNOT, inA);
    output wire outNOT;
    input wire inA; 

    nand(outNOT, inA, 1);

endmodule