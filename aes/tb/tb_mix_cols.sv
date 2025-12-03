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
        input_state_encrypt = 128'hd4bf5d30e0b452aeb84111f11e2798e5;
        #1;
        check_output(output_state_encrypt , 128'h046681e5e0cb199a48f8d37a2806264c);

        input_state_decrypt = 128'h046681e5e0cb199a48f8d37a2806264c;
        #1;
        check_output(output_state_decrypt , 128'hd4bf5d30e0b452aeb84111f11e2798e5);
    end

    initial begin
        $dumpfile("wave.vcd");
        $dumpvars(0, tb_mix_cols);
    end

endmodule
