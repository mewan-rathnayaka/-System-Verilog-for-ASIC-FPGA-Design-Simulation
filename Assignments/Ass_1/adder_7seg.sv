// get axi stream input numbers one number at a time (but parallel)
// add them and output the cumulative sum to display using a 7 segment

// State machine
// ADD - add the incoming number
// OUT - increment counter and signal m_valid when all numbers are added
// ENDD - reset everything

// State transitions:
// ADD -> OUT when s_valid (a valid number was added)
// OUT -> ADD if there are more numbers to add
// OUT -> END if m_ready and all numbers have been added
// END -> ADD always happens in the next cycle

module axi_stream_adder #(
    parameter N = 5,    // No. of numbers
    W = 4,           // Width of a number
    W_SUM = W + $clog2(N)   // Width of sum
) (
    input logic s_valid, m_ready,
    input logic [W-1:0] s_data,
    input logic clk, rstn,
    output logic m_valid, s_ready,
    output logic [1:0][6:0] m_data
);
    // Make a LUT to convert digits to 7 segment output
    // Input - 4 bits, output - 7 bits
    logic [15:0][6:0] lut_7seg;

    // Output is gfedcba
    assign lut_7seg[0] = 7'b0111111;
    assign lut_7seg[1] = 7'b0000110;
    assign lut_7seg[2] = 7'b1011011;
    assign lut_7seg[3] = 7'b1001111;
    assign lut_7seg[4] = 7'b1100110;
    assign lut_7seg[5] = 7'b1101101;
    assign lut_7seg[6] = 7'b1111101;
    assign lut_7seg[7] = 7'b0000111;
    assign lut_7seg[8] = 7'b1111111;
    assign lut_7seg[9] = 7'b1101111;
    assign lut_7seg[15:10] = 7'b0;    // unused

    logic [W_SUM-1:0] sum_reg;
    logic [3:0] tens, ones; // single digits

    // Convert sum to 7 segment
    assign ones = sum_reg % 10;
    assign tens = (sum_reg / 10) % 10;

    assign m_data[0] = lut_7seg[ones];
    assign m_data[1] = lut_7seg[tens];

    logic [$clog2(N)-1:0] count;
    enum {ADD, OUT, ENDD} state;

    always_ff @( posedge clk or negedge rstn ) begin

        m_valid <= 0;
        
        if (!rstn) begin
            sum_reg <= 0;
            count <= 0;
            state <= ADD;

        end else begin
            unique case (state) 
                ADD: 
                    if (s_valid) begin
                        sum_reg <= sum_reg + s_data;
                        state <= OUT;
                    end 
                OUT:
                    if (count == N-1) begin // can read output in this cycle
                        m_valid <= 1; 
                        if (m_ready) state <= ENDD; 
                    end else begin 
                        count <= count + 1;
                        state <= ADD;
                    end
                ENDD: begin  // reset everything
                        count <= 0;
                        sum_reg <= 0;
                        state <= ADD;
                    end
            endcase
        end
    end

    assign s_ready = !(m_valid && !m_ready);

endmodule

/*
Seven segment display
    a
f       b
    g
e       c
    d
*/