`ifndef state_machine
`define state_machine

module state_machine(
    input wire iRstN,
    input wire iClk,
    output reg [2:0] main_st,
    output reg [2:0] cross_st
);

    //define states
    parameter main_g_cross_r = 2'b00;
    parameter main_y_cross_r = 2'b01;
    parameter main_r_cross_g = 2'b10;
    parameter main_r_cross_y = 2'b11;

    //state register 
    reg [1:0] state_reg; //4 states = 2 bits

    //timer for light changes
    reg [4:0] light_counter = 0;    //main green = 15 sec
                                    //main yellow = 3 sec
                                    //cross green = 10 sec
                                    //cross yellow = 3 sec
                                    //total seconds = 31
    //next state logic
    always@(posedge iClk or negedge iRstN) begin
        if(~iRstN)
            state_reg <= main_g_cross_r; //reset state
        else 
            case(state_reg)
                main_g_cross_r : if(light_counter == 15)    state_reg <= main_y_cross_r;
                main_y_cross_r : if(light_counter == 18)    state_reg <= main_r_cross_g;
                main_r_cross_g : if(light_counter == 28)    state_reg <= main_r_cross_y;
                main_r_cross_y : if(light_counter == 31)    state_reg <= main_g_cross_r;
                default : state_reg <= main_g_cross_r;
            endcase
    end

    //light counter control
    always@(posedge iClk or negedge iRstN) begin
        if(~iRstN)
            light_counter <= 0;
        else 
            if(light_counter == 31)
                light_counter <= 0;
            else 
                light_counter <= light_counter + 1;
    end

    always@(posedge iClk) begin
        case(state_reg)
            main_g_cross_r : begin
                                main_st <= 3'b001; //green 
                                cross_st <= 3'b100; //red
                             end
            main_y_cross_r : begin
                                main_st <= 3'b010; //yellow 
                                cross_st <= 3'b100; //red
                             end
            main_r_cross_g : begin
                                main_st <= 3'b100; //red 
                                cross_st <= 3'b001; //green
                             end
            main_r_cross_y : begin
                                main_st <= 3'b100; //red 
                                cross_st <= 3'b010; //yellow
                             end

        endcase
    end

endmodule

`endif
