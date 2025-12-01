module key_expansion (
  input  logic         ready,        // posedge steps to NEXT key
  input  logic         restart,      // pulse: restart rounds for next block
  input  logic [127:0] key_in,
  output logic [127:0] round_key
);
  timeunit 1ns/1ps;

  logic         loaded;
  logic [127:0] curr_key;
  logic [3:0]   rnum;

  initial begin
    loaded   = 1'b0;
    curr_key = '0;
    rnum     = 4'd0;
  end

  // Before first step: base_key = key_in (K0)
  // After first step:  base_key = curr_key (K1..K10)
  wire [127:0] base_key = loaded ? curr_key : key_in;
  wire [3:0]   base_idx = loaded ? rnum     : 4'd0;

  // Split base_key
  wire [31:0] w0 = base_key[127:96];
  wire [31:0] w1 = base_key[95:64];
  wire [31:0] w2 = base_key[63:32];
  wire [31:0] w3 = base_key[31:0];

  // RotWord/SubWord on w3
  wire [7:0] rw0 = w3[23:16],
             rw1 = w3[15:8],
             rw2 = w3[7:0],
             rw3 = w3[31:24];

  logic [7:0] sw0, sw1, sw2, sw3;
  s_box u0 (.in(rw0), .out(sw0));
  s_box u1 (.in(rw1), .out(sw1));
  s_box u2 (.in(rw2), .out(sw2));
  s_box u3 (.in(rw3), .out(sw3));

  wire [31:0] subword = {sw0, sw1, sw2, sw3};

  // Rcon
  localparam logic [7:0] RCON [0:10] = '{
    8'h00, 8'h01, 8'h02, 8'h04, 8'h08, 8'h10,
    8'h20, 8'h40, 8'h80, 8'h1B, 8'h36
  };

  function automatic logic [7:0] rcon8(input logic [3:0] j);
    rcon8 = (j <= 4'd10) ? RCON[j] : 8'h00;
  endfunction

  // Next key
  wire [31:0] temp      = subword ^ {rcon8(base_idx + 4'd1), 24'h0};
  wire [31:0] w0_next   = w0 ^ temp;
  wire [31:0] w1_next   = w1 ^ w0_next;
  wire [31:0] w2_next   = w2 ^ w1_next;
  wire [31:0] w3_next   = w3 ^ w2_next;
  wire [127:0] next_key = {w0_next, w1_next, w2_next, w3_next};

  // Current round key:
  // - before first step or after restart: K0 = key_in
  // - after steps: K1..K10
  assign round_key = loaded ? curr_key : key_in;

  // Step or restart
  always @(posedge ready or posedge restart) begin
    if (restart) begin
      // Go back to "before K0": output = key_in, index = 0
      loaded   <= 1'b0;
      rnum     <= 4'd0;
      curr_key <= '0;
    end else begin
      if (!loaded) begin
        // First step: K0 -> K1
        curr_key <= next_key;   // K1
        rnum     <= 4'd1;
        loaded   <= 1'b1;
      end else if (rnum < 4'd10) begin
        // Subsequent steps: K1->K2->...->K10
        curr_key <= next_key;
        rnum     <= rnum + 4'd1;
      end
      // At rnum==10, stay at K10
    end
  end

endmodule
