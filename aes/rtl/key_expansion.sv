
module key_expansion (
  input  logic         clk,
  input  logic         rst,          // posedge reset
  input  logic         start,        // pulse to start generation
  input  logic [127:0] key_in,       // initial cipher key (K0)

  output logic         valid,        // 1 while K0..K10 are streaming
  output logic         done,         // 1-cycle pulse when K10 is emitted
  output logic  [3:0]  index,        // 0..10 (K0..K10)
  output logic [127:0] round_key     
);
timeunit 1ns/1ps;

  logic        running;
  logic [3:0]  rnum;        // which key is being output (0..10)
  logic [127:0] curr_key;

  logic [7:0] sw0, sw1, sw2, sw3;

  // RotWord takes the last word (w3) of curr_key and rotates bytes
  wire [31:0] w0 = curr_key[127:96];
  wire [31:0] w1 = curr_key[95:64];
  wire [31:0] w2 = curr_key[63:32];
  wire [31:0] w3 = curr_key[31:0];

  // RotWord(w3)
  wire [7:0] rw0 = w3[23:16];
  wire [7:0] rw1 = w3[15:8];
  wire [7:0] rw2 = w3[7:0];
  wire [7:0] rw3 = w3[31:24];

  s_box u0(.in(rw0), .out(sw0));
  s_box u1(.in(rw1), .out(sw1));
  s_box u2(.in(rw2), .out(sw2));
  s_box u3(.in(rw3), .out(sw3));

  wire [31:0] subword = {sw0, sw1, sw2, sw3};

 
  // Rcon lookup
  
  function automatic logic [7:0] rcon8(input logic [3:0] i);
    case (i)
      4'd1:  rcon8 = 8'h01;
      4'd2:  rcon8 = 8'h02;
      4'd3:  rcon8 = 8'h04;
      4'd4:  rcon8 = 8'h08;
      4'd5:  rcon8 = 8'h10;
      4'd6:  rcon8 = 8'h20;
      4'd7:  rcon8 = 8'h40;
      4'd8:  rcon8 = 8'h80;
      4'd9:  rcon8 = 8'h1B;
      4'd10: rcon8 = 8'h36;
      default: rcon8 = 8'h00;
    endcase
  endfunction


  // Next round key (purely combinational from curr_key & rnum)
  //   temp = SubWord(RotWord(w3)) ^ {Rcon,24'h0}  (for next round)
  //   w0' = w0 ^ temp;  w1' = w1 ^ w0';  w2' = w2 ^ w1';  w3' = w3 ^ w2';

  wire [31:0] temp      = subword ^ {rcon8(rnum + 4'd1), 24'h000000};
  wire [31:0] w0_next   = w0 ^ temp;
  wire [31:0] w1_next   = w1 ^ w0_next;
  wire [31:0] w2_next   = w2 ^ w1_next;
  wire [31:0] w3_next   = w3 ^ w2_next;
  wire [127:0] next_key = {w0_next, w1_next, w2_next, w3_next};


  always_ff @(posedge clk or posedge rst) begin
    if (rst) begin
      running   <= 1'b0;
      rnum      <= 4'd0;
      curr_key  <= '0;
      round_key <= '0;
      index     <= 4'd0;
      valid     <= 1'b0;
      done      <= 1'b0;
    end else begin
      done <= 1'b0;

      if (start) begin
        // o/p K0 immediately
        running   <= 1'b1;
        rnum      <= 4'd0;
        curr_key  <= key_in;
        round_key <= key_in;
        index     <= 4'd0;
        valid     <= 1'b1;

      end else if (running) begin
        if (rnum == 4'd10) begin
          // K10 last cycle stop streaming
          running <= 1'b0;
          valid   <= 1'b0;
          // 'done' already pulsed when K10 was emitted
        end else begin
          // Advance to next key and emit it this cycle
          curr_key  <= next_key;
          round_key <= next_key;
          rnum      <= rnum + 4'd1;
          index     <= rnum + 4'd1;
          valid     <= 1'b1;

          if ((rnum + 4'd1) == 4'd10) begin
            done <= 1'b1; // pulse when K10 is emitted
          end
        end
      end else begin
        valid <= 1'b0;
      end
    end
  end

endmodule
