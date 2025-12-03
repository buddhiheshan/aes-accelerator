module tb_shift_rows ();

    logic [127:0] input_state_encrypt;
    logic [127:0] output_state_encrypt;

    logic [127:0] input_state_decrypt;
    logic [127:0] output_state_decrypt;

    shift_rows #(.INVERSE(0)) dut_encrypt (.input_state(input_state_encrypt), .output_state(output_state_encrypt));
    shift_rows #(.INVERSE(1)) dut_decrypt (.input_state(input_state_decrypt), .output_state(output_state_decrypt));

    task check_output(logic [127:0] output_state, logic [127:0] expected_output_state);
        if (output_state !== expected_output_state) begin
            $display("FAILED: Output state missmatch!");
            $display("Expected: %h\nGot: %h", expected_output_state, output_state);
        end
        else $display("PASS");
    endtask

    initial begin
        input_state_encrypt = 128'hd42711aee0bf98f1b8b45de51e415230;
        #1;
        check_output(output_state_encrypt , 128'hd4bf5d30e0b452aeb84111f11e2798e5);

        input_state_decrypt = 128'hd4bf5d30e0b452aeb84111f11e2798e5;
        #1;
        check_output(output_state_decrypt , 128'hd42711aee0bf98f1b8b45de51e415230);
    end

    initial begin
        $dumpfile("wave.vcd");
        $dumpvars(0, tb_shift_rows);
    end

endmodule
