`timescale 1ns / 1ps

module elevator_tb();
    reg [3:0] u;
    reg [3:0] d;
    reg [3:0] i;
    reg reset_n, clk;
    
    wire [2:0] F;
    wire [1:0] dir;
    wire door;
    wire [5:0] out;
    
    elevator Elevator(
            .u(u),
            .d(d),
            .i(i),
            .F(F),
            .dir(dir),
            .door(door),
            .out(out),
            .reset_n(reset_n),
            .clk(clk)
    );
    
    initial begin
        
        up_test; //From F2 to F4, [0ns,30ns]
        down_test; //From F3 to F1, [30ns,70ns]
        up_up_test; //From F1 to F4, From F2 to F3 [70ns,110ns]
        up_down_test; //From F1 to F4, From F3 to F2 [110ns,150ns]
        down_up_test; //From F4 to F2, From F2 to F4 [150ns,200ns]
        down_down_test; //From F3 to F2, From F2 to F1 [200ns, 250ns]
        
    end
    
    task up_test; //From F2 to F4, [0ns,30ns]
        integer j;
        begin
            u = 4'b0000;
            d = 4'b0000;
            i = 4'b0000;
            clk = 1;
            reset_n = 0;
            #2 reset_n = 1;
            //reset
            
            u = 4'b0010; //call from F2
            for(j = 0; j < 28; j = j + 1) begin
                #1 clk = !clk;
                if(j === 7) begin
                    u[1] = 0;
                    i[3] = 1; //target: F4
                    end
                if(j === 19) i[3] = 0;
                end
        end
    endtask
    
    task down_test; //From F3 to F1, [30ns,70ns]
        integer j;
        begin
            u = 4'b0000;
            d = 4'b0000;
            i = 4'b0000;
            clk = 1;
            reset_n = 0;
            #1 clk = 0;
            #0.5 reset_n = 1;
            #0.5 clk = 1;
            //reset
            
            d = 4'b0100; //call from F3
            for(j = 0; j < 38; j = j + 1) begin
                #1 clk = !clk;
                if(j === 19) begin
                    d[2] = 0;
                    i[0] = 1; //target: F1
                    end
                if(j === 31) i[0] = 0;
                end
        end
    endtask
    
    task up_up_test; //From F1 to F4, From F2 to F3 [70ns,110ns]
        integer j;
        begin
            u = 4'b0000;
            d = 4'b0000;
            i = 4'b0000;
            clk = 1;
            reset_n = 0;
            #1 clk = 0;
            #0.5 reset_n = 1;
            #0.5 clk = 1;
            //reset
            
            u = 4'b0001; //call from F1
            for(j = 0; j < 38; j = j + 1) begin
                #1 clk = !clk;
                if(j === 2) begin
                    u[0] = 0;
                    i[3] = 1; //target: F4
                    end
                if(j === 4) u = u | 4'b0010; //call from F2
                if(j === 9) begin
                    u[1] = 0;
                    i[2] = 1; //target: F3
                    end
                if(j === 17) i[2] = 0;
                if(j === 25) i[3] = 0;
                end
        end
    endtask
    
    task up_down_test; //From F1 to F4, From F3 to F2 [110ns,150ns]
        integer j;
        begin
            u = 4'b0000;
            d = 4'b0000;
            i = 4'b0000;
            clk = 1;
            reset_n = 0;
            #1 clk = 0;
            #0.5 reset_n = 1;
            #0.5 clk = 1;
            //reset
            
            u = 4'b0001; //call from F1
            for(j = 0; j < 38; j = j + 1) begin
                #1 clk = !clk;
                if(j === 2) begin
                    u[0] = 0;
                    i[3] = 1; //target: F4
                    end
                if(j === 4) d = 4'b0100; //call from F3
                if(j === 17) i[3] = 0;
                if(j === 25) begin
                    d[2] = 0;
                    i[1] = 1; //target: F2
                    end
                if(j === 33) i[1] = 0;
                end
        end
    endtask
    
    task down_up_test; //From F4 to F2, From F2 to F4 [150ns,200ns]
        integer j;
        begin
            u = 4'b0000;
            d = 4'b0000;
            i = 4'b0000;
            clk = 1;
            reset_n = 0;
            #1 clk = 0;
            #0.5 reset_n = 1;
            #0.5 clk = 1;
            //reset
            
            d = 4'b1000; //call from F4
            for(j = 0; j < 48; j = j + 1) begin
                #1 clk = !clk;
                if(j === 15) begin
                    d[3] = 0;
                    i[1] = 1; //target: F2
                    end
                if(j === 18) u = 4'b0010; //call from F2
                if(j === 27) begin
                    i[1] = 0;
                    u[1] = 0;
                    i[3] = 1; //target: F4
                    end
                if(j === 39) i[3] = 0;
                end
        end
    endtask
    
    task down_down_test; //From F3 to F2, From F2 to F1 [200ns,250ns]
        integer j;
        begin
            u = 4'b0000;
            d = 4'b0000;
            i = 4'b0000;
            clk = 1;
            reset_n = 0;
            #1 clk = 0;
            #0.5 reset_n = 1;
            #0.5 clk = 1;
            //reset
            
            d = 4'b0100; //call from F3
            for(j = 0; j < 48; j = j + 1) begin
                #1 clk = !clk;
                if(j === 19) begin
                    d[2] = 0;
                    i[1] = 1; //target: F2
                    end
                if(j === 21) d = d | 4'b0010; //call from F2
                if(j === 27) begin
                    i[1] = 0;
                    d[1] = 0;
                    i[0] = 1; //target: F1
                    end
                if(j === 36) i[0] = 0;
                end
        end
    endtask
    
endmodule
