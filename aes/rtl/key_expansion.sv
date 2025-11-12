module key_expansion (
  input  logic         ready,        // each posedge steps to next key
  input  logic [127:0] key_in,
  output logic  [3:0]  index,        // valid only when ready=1
  output logic [127:0] round_key     // valid only when ready=1
);
  timeunit 1ns/1ps;

  logic         loaded;
  logic [127:0] curr_key;
  logic [3:0]   rnum;
  logic [127:0] emitted_key;
  logic [3:0]   emitted_idx;

  // Power-up init 
  initial begin
    loaded      = 1'b0;
    curr_key    = '0;
    rnum        = '0;
    emitted_key = '0;
    emitted_idx = '0;
  end

  
  wire [127:0] base_key = loaded ? curr_key : key_in;
  wire [3:0]   base_idx = loaded ? rnum     : 4'd0;

  // RotWord/SubWord on last word of base_key
  wire [31:0] w0 = base_key[127:96];
  wire [31:0] w1 = base_key[95:64];
  wire [31:0] w2 = base_key[63:32];
  wire [31:0] w3 = base_key[31:0];

  wire [7:0] rw0 = w3[23:16], rw1 = w3[15:8], rw2 = w3[7:0], rw3 = w3[31:24];
  logic [7:0] sw0, sw1, sw2, sw3;
  s_box u0 (.in(rw0), .out(sw0));
  s_box u1 (.in(rw1), .out(sw1));
  s_box u2 (.in(rw2), .out(sw2));
  s_box u3 (.in(rw3), .out(sw3));
  wire [31:0] subword = {sw0, sw1, sw2, sw3};

  // Rcon lookup 
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

  // Outputs only when ready=1
  assign index     = ready ? emitted_idx : 4'd0;
  assign round_key = ready ? emitted_key : emitted_key; //128'd0;

  // Step on each ready pulse
  always @(posedge ready) begin
    // Emit current/base key
    emitted_key <= base_key;
    emitted_idx <= base_idx;

    // Prepare next
    if (base_idx < 4'd10) begin
      curr_key <= next_key;
      rnum     <= base_idx + 4'd1;
      loaded   <= 1'b1;
    end
  end
endmodule
