// ============================================================================
// AES MixColumns / InvMixColumns (GF(2^8), poly x^8 + x^4 + x^3 + x + 1)
// ----------------------------------------------------------------------------
// - input_state/output_state are 128-bit, viewed as 16 bytes.
// - Column-major layout: byte i = state[8*i+:8], where i = 4*col + row.
// - INVERSE = 0 : MixColumns      (for encryption)
// - INVERSE = 1 : InvMixColumns   (for decryption)
// ============================================================================
module mix_cols #(
  parameter bit INVERSE = 1'b0
)(
  input  logic [127:0] input_state,
  output logic [127:0] output_state
);

  // --------- Helper functions for GF(2^8) arithmetic (Rijndael) ----------
  function automatic logic [7:0] xtime(input logic [7:0] x);
    logic [7:0] x_shift;
    begin
      x_shift = {x[6:0],1'b0};
      // If MSB was 1, reduce with 0x1b
      xtime   = x[7] ? (x_shift ^ 8'h1b) : x_shift;
    end
  endfunction

  function automatic logic [7:0] mul2(input logic [7:0] x);
    mul2 = xtime(x);
  endfunction

  function automatic logic [7:0] mul3(input logic [7:0] x);
    mul3 = xtime(x) ^ x;             // 3 = 2 ^ 1
  endfunction

  // Inverse constants
  function automatic logic [7:0] mul9 (input logic [7:0] x); // 9  = 8 ^ 1
    logic [7:0] x2, x4, x8;
    begin
      x2 = xtime(x);
      x4 = xtime(x2);
      x8 = xtime(x4);
      mul9 = x8 ^ x;
    end
  endfunction

  function automatic logic [7:0] mul11(input logic [7:0] x); // 11 = 8 ^ 2 ^ 1
    logic [7:0] x2, x4, x8;
    begin
      x2 = xtime(x);
      x4 = xtime(x2);
      x8 = xtime(x4);
      mul11 = x8 ^ x2 ^ x;
    end
  endfunction

  function automatic logic [7:0] mul13(input logic [7:0] x); // 13 = 8 ^ 4 ^ 1
    logic [7:0] x2, x4, x8;
    begin
      x2 = xtime(x);
      x4 = xtime(x2);
      x8 = xtime(x4);
      mul13 = x8 ^ x4 ^ x;
    end
  endfunction

  function automatic logic [7:0] mul14(input logic [7:0] x); // 14 = 8 ^ 4 ^ 2
    logic [7:0] x2, x4, x8;
    begin
      x2 = xtime(x);
      x4 = xtime(x2);
      x8 = xtime(x4);
      mul14 = x8 ^ x4 ^ x2;
    end
  endfunction

  // ----------------------- Byte unpack/pack -------------------------------
  logic [7:0] s [0:15];
  logic [7:0] t [0:15];

  genvar gi;
  generate
    for (gi = 0; gi < 16; gi++) begin : UNPACK
      assign s[gi] = input_state[8*gi +: 8];
    end
  endgenerate

  // ----------------------- Column-wise transform --------------------------
  // Each column: a0,a1,a2,a3 -> b0..b3
  genvar c;
  generate
    for (c = 0; c < 4; c++) begin : COL
      wire [7:0] a0 = s[4*c + 0];
      wire [7:0] a1 = s[4*c + 1];
      wire [7:0] a2 = s[4*c + 2];
      wire [7:0] a3 = s[4*c + 3];

      if (!INVERSE) begin : ENC
        // MixColumns (encryption)
        wire [7:0] b0 = mul2(a0)    ^ mul3(a1) ^ a2        ^ a3;
        wire [7:0] b1 = a0          ^ mul2(a1) ^ mul3(a2)  ^ a3;
        wire [7:0] b2 = a0          ^ a1       ^ mul2(a2)  ^ mul3(a3);
        wire [7:0] b3 = mul3(a0)    ^ a1       ^ a2        ^ mul2(a3);
        assign t[4*c + 0] = b0;
        assign t[4*c + 1] = b1;
        assign t[4*c + 2] = b2;
        assign t[4*c + 3] = b3;
      end else begin : DEC
        // InvMixColumns (decryption)
        wire [7:0] b0 = mul14(a0) ^ mul11(a1) ^ mul13(a2) ^ mul9(a3);
        wire [7:0] b1 = mul9 (a0) ^ mul14(a1) ^ mul11(a2) ^ mul13(a3);
        wire [7:0] b2 = mul13(a0) ^ mul9 (a1) ^ mul14(a2) ^ mul11(a3);
        wire [7:0] b3 = mul11(a0) ^ mul13(a1) ^ mul9 (a2) ^ mul14(a3);
        assign t[4*c + 0] = b0;
        assign t[4*c + 1] = b1;
        assign t[4*c + 2] = b2;
        assign t[4*c + 3] = b3;
      end
    end
  endgenerate

  // ----------------------- Pack back into 128-bit -------------------------
  generate
    for (gi = 0; gi < 16; gi++) begin : PACK
      assign output_state[8*gi +: 8] = t[gi];
    end
  endgenerate

endmodule
