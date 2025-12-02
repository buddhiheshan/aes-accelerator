module tb_key_expansion;
timeunit 1ns/1ps;

    logic [127:0] key_in;
    logic         set_new_key;
    

    logic         start_enc;
    logic         ready_enc;
    logic [127:0] key_enc;
    
    logic         start_dec;
    logic         ready_dec;
    logic [127:0] key_dec;

    key_expansion u_dut (
        .key_in      (key_in),
        .set_new_key (set_new_key),
        .start_enc   (start_enc),
        .ready_enc   (ready_enc),
        .key_enc     (key_enc),
        .start_dec   (start_dec),
        .ready_dec   (ready_dec),
        .key_dec     (key_dec)
    );

initial begin
    $fsdbDumpfile("dump.fsdb");  
    $fsdbDumpvars;
  end

    // Test Sequence 
    initial begin
        // 1. Initialize to safe defaults
        key_in      = 128'h0; 
        set_new_key = 0;
        start_enc   = 0;
        ready_enc   = 0;
        start_dec   = 0;
        ready_dec   = 0;
        


        // PHASE 1: LOAD MASTER KEY 
        #20;
        // Set the Master Key value
        key_in = 128'h000102030405060708090a0b0c0d0e0f; 
        #10;
        
        // Pulse 'set_new_key' to load it
        set_new_key = 1; 
        #10;
        set_new_key = 0;
        
        // CHECKPOINT 1: 
        // Look at 'key_enc'. It should now be equal to 'key_in' (Round 0).
        // The internal "schedule_valid" flag is now 0 (Dirty).

        // PHASE 2: GENERATE ENCRYPTION KEYS (Time: 50ns+)
        // We need 10 pulses to generate Round 1 -> Round 10.
        
        repeat (10) begin
            #20 ready_enc = 1; // Rising edge triggers calculation
            #20 ready_enc = 0;
        end
        
        // CHECKPOINT 2:
        // 'key_enc' should have changed 10 times.
        // It should now hold the final Round 10 key.
        // The internal "schedule_valid" flag is now 1 (Valid).

        // PHASE 3: DECRYPTION (Time: ~450ns        #50;
        
        // 1. Reset Decryption Pointer to Round 10
        start_dec = 1;
        #10 start_dec = 0;
        
        // CHECKPOINT 3:
        // 'key_dec' should immediately jump to Round 10 Key.
        
        // 2. Walk backwards to Round 0
        repeat (10) begin
            #20 ready_dec = 1; // Rising edge steps backwards
            #20 ready_dec = 0;
        end
        
        // CHECKPOINT 4:
        // 'key_dec' should now match your original 'key_in'.

        // PHASE 4: REPLAY ENCRYPTION
        #50;
        
        // Use 'start_enc' (NOT set_new_key) to restart without recalculating
        start_enc = 1;
        #10 start_enc = 0;
        
        // CHECKPOINT 5:
        // 'key_enc' jumps back to Round 0 Key instantly.
        
        repeat (5) begin
            #20 ready_enc = 1;
            #20 ready_enc = 0;
        end
        
        #100;
        $finish;
    end

endmodule
