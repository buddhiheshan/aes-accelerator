module tb_add_roundkey ();

    logic [127:0] input_state;
    logic [127:0] key;
    logic [127:0] output_state;

    add_roundkey dut(.*);

    task check_output(logic [127:0] expected_output_state);
        if (output_state !== expected_output_state) begin
            $display("FAILED: Output state missmatch!");
            $display("Expected: %h\nGot: %h", expected_output_state, output_state);
        end
        else $display("PASS");
    endtask

    initial begin
        input_state = 128'h89c2abb23688ac1c675eb2d4cf2a263e;
        key = 128'h636a224c2c3d021f797f4f5e2b36011b;
        #1;
        check_output(128'heaa889fe1ab5ae031e21fd8ae41c2725);
    end

    initial begin
        $dumpfile("wave.vcd");
        $dumpvars(0, tb_add_roundkey);
    end

endmodule