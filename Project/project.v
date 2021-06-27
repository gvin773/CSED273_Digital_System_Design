`timescale 1ps / 1fs

/* Negative edge triggered JK flip-flop */
module edge_trigger_JKFF(input reset_n, input j, input k, input clk, output reg q, output reg q_);  
    initial begin
      q = 0;
      q_ = ~q;
    end
    
    always @(negedge clk) begin
        q = reset_n & (j&~q | ~k&q);
        q_ = ~reset_n | ~q;
    end

endmodule

/* Negative edge triggered D flip-flop */
module D_FF(input reset_n, input d, input clk, output q, output q_);

    edge_trigger_JKFF neg_D_FF(reset_n, d, ~d, clk, q, q_);

endmodule

module elevator(
    input [3:0] u, //up button ex) u[2] === 1 -> up button of F3 is on, u[0] === 1 -> up button of F1 is on
    input [3:0] d, //down button ex) d[3] === 1 -> down button of F4 is on, d[1] === 1 -> down button of F2 is on
    input [3:0] i, //button in elevator ex) i[2] === 1 -> F3 button in elevator is on, i[0] === 1 -> F1 button in elevator is on
    output [2:0] F, //floor: 000 - F1, 001 - F2, 010 - F3, 011 - F4, 100 - F1.5, 101 - F2.5, 110 - F3.5
    output [1:0] dir, //direction: 0x - stopped, 10 - moving down, 11 - moving up
    output door, //door: 1 - opened, 0 - closed
    output [5:0] out, //abdcef : abc - floor, de - direction, f - door
    input reset_n,
    input clk
    );
    
    floor get_next_floor(u, d, i, F, dir, door, reset_n, clk); //get next floor state
    direction get_next_direction(u, d, i, F, dir, door, reset_n, clk); //get next direction state
    door_checker get_next_door(u, d, i, F, dir, door, reset_n, clk); //get next door state
    
    assign out[5] = F[2];
    assign out[4] = F[1];
    assign out[3] = F[0];
    assign out[2] = dir[1];
    assign out[1] = dir[0];
    assign out[0] = door;
    //update output
    
endmodule

module floor(
    input [3:0] u,
    input [3:0] d,
    input [3:0] i,
    output [2:0] F,
    input [1:0] dir,
    input door,
    input reset_n,
    input clk
    );
    
    wire D_in2;
    assign D_in2 = (F === 3'b000 && dir === 2'b11 && door === 0) //S2->S3
                || ((F === 3'b001 && dir === 2'b10 && door === 0) && ((d[1] | i[1]) !== 1)) //S8->S4
                || ((F === 3'b001 && dir === 2'b11 && door === 0) && ((u[1] | i[1]) !== 1)) //S7->S9
                || ((F === 3'b010 && dir === 2'b10 && door === 0) && ((d[2] | i[2]) !== 1)) //S14->S10
                || ((F === 3'b010 && dir === 2'b11 && door === 0) && ((u[2] | i[2]) !== 1)) //S13->S15
                || (F === 3'b011 && dir === 2'b10 && door === 0); //S19->S16
    wire D_in1;
    assign D_in1 = (F === 3'b011 || F === 3'b110) //present state: 4F, 3.5F
                || (F === 3'b010 && !(dir === 2'b10 && door === 0 && ((d[2] | i[2]) !== 1))) //present state: 3F except S14->S10
                || (F === 3'b101 && dir === 2'b11 && door === 0); //present state: S9
     
    wire D_in0;
    assign D_in0 = (F === 3'b100 && dir === 2'b11 && door === 0) //present state: 1.5F
                || (F === 3'b001 && !(dir === 2'b10 && door === 0 && ((d[1] | i[1]) !== 1))) //present state: 2F except S8->S4
                || (F === 3'b101 && dir === 2'b10 && door === 0) //present state: 2.5F(down)
                || (F === 3'b010 && dir === 2'b10 && door === 0 && ((d[2] | i[2]) !== 1)) //S14->S10
                || (F === 3'b110 && dir === 2'b11 && door === 0) //present state: 3.5F(up)
                || (F === 3'b011 && dir !== 2'b10); //present state: 4F except S19
    
    wire dummy2, dummy1, dummy0;
    D_FF for_F2(reset_n, D_in2, clk, F[2], dummy2);
    D_FF for_F1(reset_n, D_in1, clk, F[1], dummy1);
    D_FF for_F0(reset_n, D_in0, clk, F[0], dummy0);
    
endmodule

module direction(
    input [3:0] u,
    input [3:0] d,
    input [3:0] i,
    output [2:0] F,
    output [1:0] dir,
    output door,
    input reset_n,
    input clk
    );
    
    wire D_in1;
    assign D_in1 = !((F === 3'b000 && dir[1] === 0 && door === 0 && ((u === 4'b0000 && d === 4'b0000 && i === 4'b0000) || ((u[0] | d[0] | i[0]) === 1))) //S0->S0 or S0->S1
                || (F === 3'b000 && dir[1] === 0 && door === 1 && u === 4'b0000 && d === 4'b0000 && i === 4'b0000) //S1->S0
                || (F === 3'b100 && dir === 2'b10 && door === 0 && ((u[0] | d[0] | i[0]) === 1)) //S4->S0
                || (F === 3'b001 && dir[1] === 0 && door === 0 && ((u === 4'b0000 && d === 4'b0000 && i === 4'b0000) || ((u[1] | d[1] | i[1]) === 1))) //S5->S5 or S5->S6
                || (F === 3'b001 && dir[1] === 0 && door === 1 && u === 4'b0000 && d === 4'b0000 && i === 4'b0000) //S6->S5
                || (F === 3'b001 && dir === 2'b11 && door === 0 && ((u[1] | i[1]) === 1)) //S7->S6
                || (F === 3'b001 && dir === 2'b10 && door === 0 && ((d[1] | i[1]) === 1)) //S8->S6
                || (F === 3'b010 && dir[1] === 0 && door === 0 && ((u === 4'b0000 && d === 4'b0000 && i === 4'b0000) || ((u[2] | d[2] | i[2]) === 1))) //S11->S11 or S11->S12
                || (F === 3'b010 && dir[1] === 0 && door === 1 && u === 4'b0000 && d === 4'b0000 && i === 4'b0000) //S12->S11
                || (F === 3'b010 && dir === 2'b11 && door === 0 && ((u[2] | i[2]) === 1)) //S13->S12
                || (F === 3'b010 && dir === 2'b10 && door === 0 && ((d[2] | i[2]) === 1)) //S14->S12
                || (F === 3'b110 && dir === 2'b11 && door === 0 && ((u[3] | d[3] | i[3]) === 1)) //S15->S17
                || (F === 3'b011 && dir[1] === 0 && door === 0 && ((u === 4'b0000 && d === 4'b0000 && i === 4'b0000) || ((u[3] | d[3] | i[3]) === 1))) //S17->S17 or S17->S18
                || (F === 3'b011 && dir[1] === 0 && door === 1 && u === 4'b0000 && d === 4'b0000 && i === 4'b0000)); //S18->S17
    
    wire D_in0;
    assign D_in0 = (F === 3'b000 && dir[1] === 0 && door === 0 && !(u === 4'b0000 && d === 4'b0000 && i === 4'b0000) && ((u[0] | d[0] | i[0]) !== 1)) //S0->S2
                || (F === 3'b000 && dir[1] === 0 && door === 1 && !(u === 4'b0000 && d === 4'b0000 && i === 4'b0000)) //S1->S2
                || (F === 3'b100 && dir === 2'b10 && door === 0 && ((u[0] | d[0] | i[0]) !== 1)) //S4->S2
                || ((F === 3'b000 && dir === 2'b11 && door === 0) || (F === 3'b100 && dir === 2'b11 && door === 0)) //S2->S3 or S3->S7
                || (F === 3'b001 && dir[1] === 0 && door === 0 && (((u[2] | d[2] | i[2]) === 1)) || ((u[3] | d[3] | i[3]) === 1)) //S5->S7
                || (F === 3'b001 && dir[1] === 0 && door === 1 && !(u === 4'b0000 && d === 4'b0000 && i === 4'b0000) && ((u[0] | d[0] | i[0]) !== 1)) //S6->S7
                || (F === 3'b001 && dir === 2'b11 && door === 0 && ((u[1] | i[1]) !== 1)) //S7->S9
                || (F === 3'b101 && dir === 2'b11 && door === 0) //S9->S13
                || (F === 3'b010 && dir[1] === 0 && door === 0 && ((u[3] | d[3] | i[3]) === 1)) //S11->S13
                || (F === 3'b010 && dir[1] === 0 && door === 1 && ((u[3] | d[3] | i[3]) === 1)) //S12->S13
                || (F === 3'b010 && dir === 2'b11 && door === 0 && ((u[2] | i[2]) !== 1)); //S13->S15
    
    wire dummy0, dummy1;
    D_FF for_dir1(reset_n, D_in1, clk, dir[1], dummy1);
    D_FF for_dir0(reset_n, D_in0, clk, dir[0], dummy0);

endmodule

module door_checker(
    input [3:0] u,
    input [3:0] d,
    input [3:0] i,
    output [2:0] F,
    output [1:0] dir,
    output door,
    input reset_n,
    input clk
    );
    
    wire D_in;
    assign D_in = (F === 3'b000 && dir[1] === 0 && door === 0 && ((u[0] | d[0] | i[0]) === 1)) //S0->S1
               || (F === 3'b001 && dir[1] === 0 && door === 0 && ((u[1] | d[1] | i[1]) === 1)) //S5->S6
               || (F === 3'b001 && dir === 2'b11 && door === 0 && ((u[1] | i[1]) === 1)) //S7->S6
               || (F === 3'b001 && dir === 2'b10 && door === 0 && ((d[1] | i[1]) === 1)) //S8->S6
               || (F === 3'b010 && dir[1] === 0 && door === 0 && ((u[2] | d[2] | i[2]) === 1)) //S11->S12
               || (F === 3'b010 && dir === 2'b11 && door === 0 && ((u[2] | i[2]) === 1)) //S13->S12
               || (F === 3'b010 && dir === 2'b10 && door === 0 && ((d[2] | i[2]) === 1)) //S14->S12
               || (F === 3'b011 && dir[1] === 0 && door === 0 && ((u[3] | d[3] | i[3]) === 1)); //S17->S18
    
    wire dummy;
    D_FF for_door(reset_n, D_in, clk, door, dummy);
    
endmodule
