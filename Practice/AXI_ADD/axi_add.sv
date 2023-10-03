//The state machine operate in 3 states
//ACCEPT    - Waiting for data
//ADD       - Add when valid data received
//DISPLAY   - Show the display output
//RESET     - Reset the data in system

//ACCEPT -> ADD     : When valid data received
//ADD -> ACCEPT     : When more data is yet to receive
//ADD -> DISPLAY    : When all data added and data ready to display 
//DISPLAY -> RESET  : Starting

//Any moment if reset goes high system enter to RESET state 
//and then to ACCEPT state
//After all data received state remains in ADD state

module axi_add #(
    parameter   WIDTH = 4,          //width of a number
                NUM_COUNT = 8      //Count of numbers that are added
) (
    input logic s_valid, reset, clk, m_ready,
    output logic s_ready, m_valid,
    input logic [WIDTH-1:0] data,
    output logic [6:0] m_data_ones, m_data_tens
);
    enum {ACCEPT, ADD, DISPLAY, RESET} state, next_state;

    logic [$clog2(NUM_COUNT)-1 :0] count;
    logic [(WIDTH + $clog2(WIDTH))-1 :0] sum;
    logic [WIDTH-1:0] data_temp;

    logic [3 : 0] tens, ones;

    //Next state decorder
    always_comb begin : next_state_decoder
        unique case (state)
            ACCEPT  : next_state = s_valid ? ADD : ACCEPT;

            ADD     : next_state = (count < NUM_COUNT - 1) ? ACCEPT : DISPLAY;

            DISPLAY : next_state = reset ? RESET : DISPLAY;

            RESET   : next_state = ACCEPT;      
        endcase
    end

    //State sequencer
    always_ff @( posedge clk or negedge reset ) begin : state_sequencer
        state <= !reset ? RESET : next_state;        
    end

    //Output decorder
    assign ones = sum % 10;
    assign tens = (sum % 100) / 10;     //For numbers greater than 99


    //Probbably better go with the state change
    

    always_ff @( posedge clk) begin
        unique case (state)
        ADD    :begin 
                s_ready <= 0;
                count <= count + 1'd1;
                sum   <= sum + data_temp;  
                end          
                
        ACCEPT :if (s_valid) begin
                    s_ready <= 1;
                    data_temp <= data;
                end
                else begin
                    s_ready <= 1;
                    data_temp <= 0;
                end
            
        DISPLAY:if (m_ready) begin
                    m_valid <= 1;
                    sev_seg_disp ones_disp (.int_ger(ones), .out_array(m_data_ones));
                    sev_seg_disp tens_disp (.int_ger(tens), .out_array(m_data_tens));
                end
                else begin
                    m_valid <= 0;
                    //To show invalid output
                    sev_seg_disp ones_disp (.int_ger(4'd11), .out_array(m_data_ones));
                    sev_seg_disp tens_disp (.int_ger(4'd11), .out_array(m_data_tens));
                end

        RESET  :begin
                s_ready = 0;
                m_valid = 0;
                count <= 0;
                sum   <= 0;  
                end  
        endcase   
    end
endmodule

module sev_seg_disp #(
    parameter WIDTH=4
) (
    input logic signed [WIDTH-1 :0] int_ger,
    output logic [6:0] out_array
    //Outarray reflects a,b,c,d,e,f,g from 0 to 6 order.
);
always_comb begin 
    unique case (int_ger)
    'b0000  : out_array = 'b1111110;
    'b0001  : out_array = 'b0110000;
    'b0010  : out_array = 'b1101101;
    'b0011  : out_array = 'b1111001;
    'b0100  : out_array = 'b0110011;
    'b0101  : out_array = 'b1011011;
    'b0110  : out_array = 'b1011111;
    'b0111  : out_array = 'b1110000;
    'b1000  : out_array = 'b1111111;
    'b1001  : out_array = 'b1111011;
    default : out_array = 'b0000001;
    //in default, or error only g lights up showing no number.        
    endcase  
end   
endmodule