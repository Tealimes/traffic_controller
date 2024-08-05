`include "state_machine.v"
`timescale 1s/1s

module state_machine_tb();
    logic iClk;
    logic iRstN;
    logic [2:0] main_st;
    logic [2:0] cross_st;

    state_machine u_state_machine (
        .iClk(iClk),
        .iRstN(iRstN),
        .main_st(main_st),
        .cross_st(cross_st)
    );

    always #5 iClk = ~iClk;

    initial begin
        $dumpfile("state_machine_tb.vcd"); $dumpvars;
        iClk = 0;
        iRstN = 0;
        main_st = 0;
        cross_st = 0;

        #10;
        iRstN = 1;

        #1000;

        $finish;
    end
endmodule
