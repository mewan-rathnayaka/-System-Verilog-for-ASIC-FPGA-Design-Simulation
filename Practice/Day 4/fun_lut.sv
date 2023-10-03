// Code your design here
module funtion_lut #(parameter W_x = 4, W_y = 8,
                    parameter signed A = 1, B = 10, C = -10)
                    (input logic signed [W_x -1 : 0] xf , xq,
                    input logic signed [W_y - 1 : 0] yiq,
                    output logic signed [W_y - 1 : 0] yf, yq_lut, yq_fun,
                    output logic signed [W_x - 1 : 0] xiq);

    function automatic [W_y - 1: 0] factorial(
        input logic [W_x - 1 : 0] n);
        factorial = (n==1) ? 1 : n * factorial(n-1);
        
    endfunction

    function automatic signed [W_y - 1: 0] quadratic( 
        input logic signed [W_x - 1: 0] x);
        return A * x **2 + B * x + C;
        
    endfunction

    /*FInding inverse quad is not straight forward
      Because the output should also be an integer*/


    function automatic signed [W_x - 1: 0] inverse_quadratic(
        input logic signed [W_y - 1: 0] y);
        logic signed [W_y - 1: 0] result, quad;
        int error, min_error = 2**W_y;

        //Hence go on checking the x values in range to give the asked y value
      for (int ux = 0; ux < 2**W_x; ux++) begin
            logic signed [W_x - 1: 0] x = ux;
            quad = quadratic(x);
            

            //Now find the closest

            error = (y - quad);
            error = error > 0 ? error : -error; //To get absoulte value

            if (error < min_error) begin
                min_error = error;
                result = x;
            end
        end    
    endfunction

    //LUT generation
    genvar i;
    logic signed [2**W_x - 1: 0][W_y - 1: 0] lut_factorial;
    logic signed [2**W_x - 1: 0][W_y - 1: 0] lut_quadratic;
    logic signed [2**W_y - 1: 0][W_x - 1: 0] lut_inverse_quadratic;


    for (i = 0; i < 2**W_x ; i++ ) begin
        assign lut_factorial[i] = factorial(i);
    end

    
    for (i = 0; i < 2**W_x ; i++ ) begin
        assign lut_quadratic[i] = quadratic(i);
    end

    for (i = 0; i < 2**W_x ; i++ ) begin
        assign lut_inverse_quadratic[i] = inverse_quadratic(i);
    end

    assign yf = lut_factorial[xf];
    assign xiq = lut_inverse_quadratic[yiq];
    assign yq_lut = lut_quadratic[xq];

    assign yq_fun = quadratic(xq);

    
endmodule