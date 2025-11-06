module tb_mix_cols ();

    logic [127:0] input_state_encrypt;
    logic [127:0] output_state_encrypt;

    logic [127:0] input_state_decrypt;
    logic [127:0] output_state_decrypt;

    mix_cols #(.INVERSE(0)) dut_encrypt (.input_state(input_state_encrypt), .output_state(output_state_encrypt));
    mix_cols #(.INVERSE(1)) dut_decrypt (.input_state(input_state_decrypt), .output_state(output_state_decrypt));

    task check_output(logic [127:0] output_state, logic [127:0] expected_output_state);
        if (output_state !== expected_output_state) begin
            $display("FAILED: Output state missmatch!");
            $display("Expected: %h\nGot: %h", expected_output_state, output_state);
        end
        else $display("PASS");
    endtask

    initial begin
        input_state_encrypt = 128'h89c2abb23688ac1c675eb2d4cf2a263e;
        #1;
        check_output(output_state_encrypt , 128'h365e26b2672aab1ccfc2acd48988b23e);

        input_state_decrypt = 128'h365e26b2672aab1ccfc2acd48988b23e;
        #1;
        check_output(output_state_decrypt , 128'h89c2abb23688ac1c675eb2d4cf2a263e);
    end

    initial begin
        $dumpfile("wave.vcd");
        $dumpvars(0, tb_mix_cols);
    end

endmodule
