module tb_pipeline_reg ();
    logic clk, reset_n;
    logic [127:0] q, d;

    pipeline_reg dut (.d(d), .q(q), .clk(clk), .reset_n(reset_n));

    always #5 clk = ~clk;

    initial begin
        $dumpfile("wave.vcd");
        $dumpvars(0, tb_pipeline_reg);
    end

    task automatic check_output(logic [127:0] expected_q);
        if (q !== expected_q) begin
            $display("FAILED: Output state missmatch!");
            $display("Expected: %b\nGot: %b", q, expected_q);
        end
        else $display("PASS");
    endtask //automatic

    initial begin
        clk = 1;
        reset_n = 1;

        #6;
        d = 128'hFFFFFFFFFFFFFFFF;
        reset_n = 0;

        #5;
        check_output(0);
        reset_n = 1;

        #10;
        check_output(128'hFFFFFFFFFFFFFFFF);
        d = 128'hFFFFFFFFFFFFFF11;

        #10;
        check_output(128'hFFFFFFFFFFFFFF11);
        #10;
        $finish();
    end
    
endmodule