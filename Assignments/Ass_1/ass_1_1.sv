module ass_1_1 #(
    parameter  W = 3, N = 10
) (
    input logic clk, rst,
    input logic [W-1 : 0] s_data,
    output logic [1:0][6:0] m_data
);
    //Count
    logic [$clog2(N) - 1 : 0] count, count_next;
    assign count_next = (count == N - 1) ? 0 : count + 1;

    always @(posedge clk or negedge rst) begin
        if (!rst) count <= 0;
        else      count <= count_next;
    end
    //Check if state assigning in count can be done in always block alone,
    //may reduce count_next as well

    //Accumilator
    localparam W_SUM = W + $clog2(N);
    logic [W_SUM-1 : 0] sum;

    always @(posedge clk) begin                         //Since count is reseted by reset no need to reset sum here again
        if (count == 0)    sum <= s_data;
        else               sum <= sum + s_data;
    end

    logic [$clog2(10) - 1 : 0] ones, tens;
    assign ones = sum % 10;
    assign tens = (sum % 100) / 10;

    logic [9 : 0][6 : 0] sev_seg_lut = '{
        7'b1111_110, //0
        7'b0110_000, //1
        7'b1101_101, //2
        7'b1111_001, //3
        7'b0110_011, //4
        7'b1011_011, //5
        7'b1011_111, //6
        7'b1110_000, //7
        7'b1111_111, //8
        7'b1110_011 //9
    };
    assign m_data ={ sev_seg_lut[tens], sev_seg_lut[ones]}; 
endmodule
