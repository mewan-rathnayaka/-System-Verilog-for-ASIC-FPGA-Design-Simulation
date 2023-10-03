`timescale 1ns/1ps
module axi_stream_adder_tb();

    parameter N = 6, W = 4, 
    W_SUM = W + $clog2(N);

    logic clk = 0, rstn = 0;

    localparam CLK_PERIOD = 10;
    initial forever #(CLK_PERIOD/2) clk <= ~clk;

    logic s_valid=0, m_ready=1;
    logic [W-1:0] s_data = 0;
    logic m_valid, s_ready;
    logic [1:0][6:0] m_data;

    axi_stream_adder #(.N(N), .W(W), .W_SUM(W_SUM)) dut(.*);

    int total, ones, tens, result;

    // function to convert 7 segment output back to numbers
    function automatic [3:0] seg_to_digit (input logic [6:0] seg);
        logic [3:0] digit;
        case (seg)
            7'b0111111: digit = 0;
            7'b0000110: digit = 1;
            7'b1011011: digit = 2;
            7'b1001111: digit = 3;
            7'b1100110: digit = 4;
            7'b1101101: digit = 5;
            7'b1111101: digit = 6;
            7'b0000111: digit = 7;
            7'b1111111: digit = 8;
            7'b1101111: digit = 9;
            default: digit = 15;
        endcase
        return digit;
    endfunction

    initial begin
        $dumpfile("dump.vcd");
        $dumpvars(0, dut);

        @(posedge clk) #1 rstn <= 1;

        repeat (10) begin
            total = 0;
            m_ready = 0;    // try making receiver ready after a random delay
            repeat (N) begin
                wait (s_ready);
                @(posedge clk) #1 s_data = $urandom_range(1,15); s_valid = 1;
                total = total + s_data;     // sum up numbers for verification
                @(posedge clk) #1 s_valid = 0;
                wait (s_ready);
            end
            wait (m_valid);
            repeat ($urandom_range(0,5)) @(posedge clk); // ready after random delay
            #1 m_ready = 1;
            @(posedge clk);
            
            #1 ones = seg_to_digit(m_data[0]);
            tens = seg_to_digit(m_data[1]);
            result = tens * 10 + ones;

            assert (result == total % 100) $display("OK, sum = %d", total); 
            else $error("Sum is %d, expected %d", result, total);
        end 
        $finish();
    end

endmodule