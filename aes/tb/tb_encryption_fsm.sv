module tb_encryption_fsm ();
    logic clk, reset_n,start;

    import fsm4_pkg::*;

    encryption_fsm dut (.clk(clk), .reset_n(reset_n), .start(start));

    always #5 clk = ~clk;

    initial begin
        $dumpfile("wave.vcd");
        $dumpvars(0, tb_encryption_fsm);
    end

    task check_state(state_e expected_state);
        if (dut.state !== expected_state) begin
            $display("FAIL Time=%0t Expected: State=%s | Got: State=%s \tround=%d, \tround_cycle_count=%d", $time, expected_state.name(), dut.state.name(), dut.round_count, dut.round_cycle_count);
        end else begin
            $display("PASS Time=%0t State=%s \tround=%d, \tround_cycle_count=%d", $time, dut.state.name(), dut.round_count, dut.round_cycle_count);
        end
    endtask

    initial begin
        clk = 1;
        reset_n = 1;
        start = 0;

        #6;
        reset_n = 0;

        #10;
        reset_n = 1;
        check_state(IDLE);

        #10
        start = 1;
        check_state(IDLE);

        #10
        check_state(INITIAL_ROUND);

        repeat (27) begin
            #10
            check_state(MID_ROUND);
        end

        #10
        check_state(LAST_ROUND);

        #10
        check_state(LAST_ROUND);

        #10
        check_state(IDLE);

        
        $finish();
    end
    
endmodule