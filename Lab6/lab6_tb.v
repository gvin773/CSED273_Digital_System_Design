/* CSED273 lab6 experiments */
/* lab6_tb.v */

`timescale 1ps / 1fs

module lab6_tb();

    integer Passed;
    integer Failed;

    /* Define input, output and instantiate module */
    reg reset_n, clk;
    wire [3:0] count;
    reg [3:0] count_expected;
    wire [7:0] count2;
    reg [3:0] count_expected2_dig1;
    reg [3:0] count_expected2_dig10;
    wire [3:0] count3;
    reg [3:0] count_expected3;

    decade_counter lab6_1(
        .reset_n(reset_n),
        .clk(clk),
        .count(count)
    );
    
    decade_counter_2digits lab6_2(
        .reset_n(reset_n),
        .clk(clk),
        .count(count2)
    );
    
    counter_369 lab6_3(
        .reset_n(reset_n),
        .clk(clk),
        .count(count3)
    );

    initial begin
        Passed = 0;
        Failed = 0;

        lab6_1_test;
        lab6_2_test;
        lab6_3_test;

        $display("Lab6 Passed = %0d, Failed = %0d", Passed, Failed);
        $finish;
    end

    /* Implement test task for lab6_1 */
    task lab6_1_test;
        integer i;
        begin
            $display("Lab6_1_test");
            clk = 1;
            reset_n = 0;
            count_expected = 0;
            #5 reset_n = 1;
            for (i=0; i < 38; i = i + 1) begin
                #5 clk = !clk;
                if(i%2 === 0) begin
                    count_expected = (count_expected + 1) % 10;
                    
                    #1;
                    if (count === count_expected) begin
                        Passed = Passed + 1;
                    end
                    else begin
                        $display("Error) in_count: %0b, out_count: %0b (Ans: %0b)", 
                                        i/2, count, count_expected);
                        Failed = Failed + 1;
                    end
                end
            end
        end
    endtask

    /* Implement test task for lab6_2 */
    task lab6_2_test;
        integer i;
        begin
            $display("Lab6_2_test");
            reset_n = 0;
            clk = 1;
            #1 clk = 0;
            #1 clk = 1;
            count_expected2_dig1 = 0;
            count_expected2_dig10 = 0;
            #5 reset_n = 1;
            for (i=0; i < 206; i = i + 1) begin
                #5 clk = !clk;
                if(i%2 === 0) begin
                    count_expected2_dig1 = (count_expected2_dig1 + 1) % 10;
                    if(count_expected2_dig1 === 0) begin
                        count_expected2_dig10 = (count_expected2_dig10 + 1) % 10;
                    end
                    
                    #1;
                    if (count2[3:0] === count_expected2_dig1 && count2[7:4] === count_expected2_dig10) begin
                        Passed = Passed + 1;
                    end
                    else begin
                        $display("Error) in_count: %0b, out_count: %0b (Ans: %0b%0b)", 
                                        i/2, count2, count_expected2_dig10, count_expected2_dig1);
                        Failed = Failed + 1;
                    end
                end
            end
        end
    endtask

    /* Implement test task for lab6_3 */
    task lab6_3_test;
        integer i, before;
        begin
            $display("Lab6_3_test");
            reset_n = 0;
            clk = 1;
            #1 clk = 0;
            #1 clk = 1;
            count_expected3 = 0;
            #5 reset_n = 1;
            for (i=0; i < 20; i = i + 1) begin
                #5 clk = !clk;
                if(i%2 === 0) begin
                    before = count2;
                    if(count_expected3 === 9) begin
                        count_expected3 = 13;
                    end
                    else begin
                        count_expected3 = (count_expected3 + 3) % 10;
                    end
                    
                    #1;
                    if (count3 === count_expected3) begin
                        Passed = Passed + 1;
                    end
                    else begin
                        $display("Error) in_count: %0b, out_count: %0b (Ans: %0b)", 
                                        before, count3, count_expected3);
                        Failed = Failed + 1;
                    end
                end
            end
        end
    endtask

endmodule