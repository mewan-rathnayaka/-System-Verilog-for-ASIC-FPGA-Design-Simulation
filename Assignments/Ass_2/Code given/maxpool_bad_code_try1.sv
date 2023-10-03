
package types; // Packages and enums are good practice. Dont change them
  typedef enum {S1, S2, S3} state_t;
endpackage

module maxpool  
    import types::*;
    #(parameter R=10, W=8) 
  (
    input  logic clk, rstn,
    input  logic s_valid,m_ready,
    output logic s_ready,m_valid,
    input  logic [R  -1:0][W-1:0] s_data,
    output logic [R/2-1:0][W-1:0] m_data
  );

  state_t state,next_state;
  always_comb 
    unique case (state)
    S1: next_state = s_valid && s_ready ? S2 : S1;
    S2: next_state = s_valid && s_ready ? S3 : S2;
    S3: next_state = m_ready            ? S1 : S3;  
  endcase  

  always_ff @(posedge clk or negedge rstn) begin
    state <= !rstn ? S1 : next_state;    
  end
  
  //Don't feel good here
  logic en = s_ready && s_valid;
  genvar r;
  for (r=0; r<R/2; r++)
    max_2x2 #(.W(W)) UNIT (clk, en, rstn, state, {s_data[2*r+1], s_data[2*r]}, m_data [r]);

  assign s_ready = m_ready && (state != S3);
  assign m_valid = state == S3; 
endmodule



module max_2x2 
  import types::*;
  #( parameter W=8 )(
    input  logic clk, rstn, en,
    input  state_t state,
    input  logic [1:0][W-1:0] s_data,
    output logic      [W-1:0] m_data
  );

  logic [W-1:0] comp_in_1, comp_in_2, comp_out;
  logic [W-1:0] max_1, max_2;

  // Set comp out
  always_ff @(posedge clk) begin
    if (en)
      if      (state == S1) max_1  <= comp_out;
      else if (state == S2) max_2  <= comp_out;

    if (state == S3) m_data <= comp_out;
  end

  // Set comp_in
  always_ff @(posedge clk)// Error, updated here not next clock
    if      (state == S1) {comp_in_1, comp_in_2} = {s_data[0], s_data[1]};
    else if (state == S2) {comp_in_1, comp_in_2} = {s_data[0], s_data[1]};
    else if (state == S3) {comp_in_1, comp_in_2} = {max_1    , max_2};

  // comparator
  assign comp_out = (comp_in_1 > comp_in_2) ? comp_in_1 : comp_in_2; // unsigned

endmodule