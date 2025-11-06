module tb_shift_rows ();

    logic [127:0] input_state;
    logic [127:0] output_state;

    shift_rows dut(.*);

    task check_output(logic [127:0] expected_output_state);
        if (output_state !== expected_output_state) begin
            $display("FAILED: Output state missmatch!");
            $display("Expected: %h\nGot: %h", expected_output_state, output_state);
        end
        else $display("PASS");
    endtask

    initial begin
        input_state = 128'h89c2abb23688ac1c675eb2d4cf2a263e;
        #1;
        check_output(128'h365e26b2672aab1ccfc2acd48988b23e);
    end

    initial begin
        $dumpfile("wave.vcd");
        $dumpvars(0, tb_shift_rows);
    end

endmodule
