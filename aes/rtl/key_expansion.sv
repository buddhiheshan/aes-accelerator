module key_expansion (
    
    input  logic [127:0] key_in,         // Master Key Input


    input  logic         set_new_key,    // Rising Edge: Loads Key 0, Invalidates old schedule

   
    input  logic         start_enc,      // High: Resets Enc Pointer to 0 (Replay Mode)
    input  logic         ready_enc,      // Rising Edge: Steps to Next Key (Acts as Clock)
    output logic [127:0] key_enc,        // Output Encryption Key

   
    input  logic         start_dec,      // High: Resets Dec Pointer to 10
    input  logic         ready_dec,      // Rising Edge: Steps to Prev Key (Acts as Clock)
    output logic [127:0] key_dec         // Output Decryption Key
);
timeunit 1ns/1ps;

    // Storage & Signals

    logic [127:0] key_storage [0:10]; // register to store keys
    logic [3:0]   enc_ptr;            // Pointer 0..10
    logic [3:0]   dec_ptr;            // Pointer 10..0
    logic         schedule_valid;     // Flag: 1 if all keys are stored
    
    // Internal latch for the math seed
    logic [127:0] last_calc_key;

    // Combinational Math (S-Box / Rcon)
    
    logic [127:0] next_key_math;
    wire [31:0] w0 = last_calc_key[127:96];
    wire [31:0] w1 = last_calc_key[95:64];
    wire [31:0] w2 = last_calc_key[63:32];
    wire [31:0] w3 = last_calc_key[31:0];

    // RotWord
    wire [31:0] rot_w3 = {w3[23:0], w3[31:24]};
    
    // SubWord
    logic [31:0] sub_w3;
    s_box s0 (.in(rot_w3[31:24]), .out(sub_w3[31:24]));
    s_box s1 (.in(rot_w3[23:16]), .out(sub_w3[23:16]));
    s_box s2 (.in(rot_w3[15:8]),  .out(sub_w3[15:8]));
    s_box s3 (.in(rot_w3[7:0]),   .out(sub_w3[7:0]));

    // Rcon (Based on the NEXT round)
    logic [7:0] rcon;
    always_comb begin
        case(enc_ptr + 1)
            1:  rcon = 8'h01; 2:  rcon = 8'h02; 3:  rcon = 8'h04;
            4:  rcon = 8'h08; 5:  rcon = 8'h10; 6:  rcon = 8'h20;
            7:  rcon = 8'h40; 8:  rcon = 8'h80; 9:  rcon = 8'h1B;
            10: rcon = 8'h36; default: rcon = 8'h00;
        endcase
    end

    // XOR Chain
    wire [31:0] w0_next = w0 ^ sub_w3 ^ {rcon, 24'd0};
    wire [31:0] w1_next = w1 ^ w0_next;
    wire [31:0] w2_next = w2 ^ w1_next;
    wire [31:0] w3_next = w3 ^ w2_next;
    assign next_key_math = {w0_next, w1_next, w2_next, w3_next};


    // Asynchronous Control Logic

    // Block A: Master Reset / Load - Triggered by set_new_key
    always @(posedge set_new_key) begin
        // When toggles this signal, we force load Key 0
        key_storage[0] <= key_in;
        last_calc_key  <= key_in;
        schedule_valid <= 1'b0;  // Mark schedule as "Dirty" (needs recalc)
    end

    //Block B: Encryption Stepper (Triggered by ready_enc)
    // start_enc acts as an asynchronous reset for this counter
    always @(posedge ready_enc or posedge start_enc or posedge set_new_key) begin
        if (set_new_key || start_enc) begin
            enc_ptr <= 4'd0; // Reset pointer to start
        end
        else begin
            // On rising edge of ready_enc...
            if (enc_ptr < 4'd10) begin
                if (schedule_valid) begin
                    // REPLAY MODE: Just move the pointer
                    enc_ptr <= enc_ptr + 1;
                end 
                else begin
                    // GENERATION MODE: Calculate and Store
                    key_storage[enc_ptr + 1] <= next_key_math;
                    last_calc_key            <= next_key_math; // Update seed
                    enc_ptr                  <= enc_ptr + 1;
                    
                    // Check if we are done
                    if (enc_ptr == 4'd9) schedule_valid <= 1'b1;
                end
            end
        end
    end

    //Block C: Decryption Stepper (Triggered by ready_dec) 
    // start_dec acts as an asynchronous reset for this counter
    always @(posedge ready_dec or posedge start_dec) begin
        if (start_dec) begin
            dec_ptr <= 4'd10; // Reset pointer to end
        end
        else begin
            // On rising edge of ready_dec...
            if (dec_ptr > 0) begin
                dec_ptr <= dec_ptr - 1;
            end
        end
    end

    // 4. Output Assignments
    assign key_enc = key_storage[enc_ptr];
    assign key_dec = key_storage[dec_ptr];

endmodule

