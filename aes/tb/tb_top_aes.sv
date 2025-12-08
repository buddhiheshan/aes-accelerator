`timescale 1ns/1ps

module tb_top_aes;

  // ----------------------------------------------------------------
  // AXI4-Lite signals
  // ----------------------------------------------------------------
  localparam ADDR_WIDTH = 8;
  localparam DATA_WIDTH = 32;

  logic                     clk;
  logic                     rst_n;           // active-low reset
  logic                     S_AXI_ARESETN;

  // Write address channel
  logic [ADDR_WIDTH-1:0]    S_AXI_AWADDR;
  logic                     S_AXI_AWVALID;
  logic                     S_AXI_AWREADY;

  // Write data channel
  logic [DATA_WIDTH-1:0]    S_AXI_WDATA;
  logic [(DATA_WIDTH/8)-1:0] S_AXI_WSTRB;
  logic                     S_AXI_WVALID;
  logic                     S_AXI_WREADY;

  // Write response channel
  logic [1:0]               S_AXI_BRESP;
  logic                     S_AXI_BVALID;
  logic                     S_AXI_BREADY;

  // Read address channel
  logic [ADDR_WIDTH-1:0]    S_AXI_ARADDR;
  logic                     S_AXI_ARVALID;
  logic                     S_AXI_ARREADY;

  // Read data channel
  logic [DATA_WIDTH-1:0]    S_AXI_RDATA;
  logic [1:0]               S_AXI_RRESP;
  logic                     S_AXI_RVALID;
  logic                     S_AXI_RREADY;

  // ----------------------------------------------------------------
  // DUT: AXI-Lite wrapper + AES core
  // ----------------------------------------------------------------
  top_aes #(
    .ADDR_WIDTH(ADDR_WIDTH),
    .DATA_WIDTH(DATA_WIDTH)
  ) dut (
    .S_AXI_ACLK    (clk),
    .S_AXI_ARESETN (S_AXI_ARESETN),

    .S_AXI_AWADDR  (S_AXI_AWADDR),
    .S_AXI_AWVALID (S_AXI_AWVALID),
    .S_AXI_AWREADY (S_AXI_AWREADY),

    .S_AXI_WDATA   (S_AXI_WDATA),
    .S_AXI_WSTRB   (S_AXI_WSTRB),
    .S_AXI_WVALID  (S_AXI_WVALID),
    .S_AXI_WREADY  (S_AXI_WREADY),

    .S_AXI_BRESP   (S_AXI_BRESP),
    .S_AXI_BVALID  (S_AXI_BVALID),
    .S_AXI_BREADY  (S_AXI_BREADY),

    .S_AXI_ARADDR  (S_AXI_ARADDR),
    .S_AXI_ARVALID (S_AXI_ARVALID),
    .S_AXI_ARREADY (S_AXI_ARREADY),

    .S_AXI_RDATA   (S_AXI_RDATA),
    .S_AXI_RRESP   (S_AXI_RRESP),
    .S_AXI_RVALID  (S_AXI_RVALID),
    .S_AXI_RREADY  (S_AXI_RREADY)
  );

  // ----------------------------------------------------------------
  // Clock & reset
  // ----------------------------------------------------------------
  initial begin
    clk  = 1'b0;
    forever #5 clk = ~clk;   // 100 MHz
  end

  initial begin
    rst_n          = 1'b0;
    S_AXI_ARESETN  = 1'b0;

    // init AXI signals
    S_AXI_AWADDR   = '0;
    S_AXI_AWVALID  = 1'b0;
    S_AXI_WDATA    = '0;
    S_AXI_WSTRB    = 4'h0;
    S_AXI_WVALID   = 1'b0;
    S_AXI_BREADY   = 1'b0;
    S_AXI_ARADDR   = '0;
    S_AXI_ARVALID  = 1'b0;
    S_AXI_RREADY   = 1'b0;

    // waveform dump (optional)
    $dumpfile("aes_axi_lite_tb.vcd");
    $dumpvars(0);

    // hold reset for some cycles
    repeat (10) @(posedge clk);
    rst_n         = 1'b1;
    S_AXI_ARESETN = 1'b1;
  end

  // ----------------------------------------------------------------
  // Address map (must match aes_axi_lite)
  // ----------------------------------------------------------------
  localparam CTRL_ADDR       = 8'h00;
  localparam STATUS_ADDR     = 8'h04;

  localparam KEY0_ADDR       = 8'h10;
  localparam KEY1_ADDR       = 8'h14;
  localparam KEY2_ADDR       = 8'h18;
  localparam KEY3_ADDR       = 8'h1C;

  localparam PT_IN0_ADDR     = 8'h20;
  localparam PT_IN1_ADDR     = 8'h24;
  localparam PT_IN2_ADDR     = 8'h28;
  localparam PT_IN3_ADDR     = 8'h2C;

  localparam CT_IN0_ADDR     = 8'h30;
  localparam CT_IN1_ADDR     = 8'h34;
  localparam CT_IN2_ADDR     = 8'h38;
  localparam CT_IN3_ADDR     = 8'h3C;

  localparam CT_OUT0_ADDR    = 8'h40;
  localparam CT_OUT1_ADDR    = 8'h44;
  localparam CT_OUT2_ADDR    = 8'h48;
  localparam CT_OUT3_ADDR    = 8'h4C;

  localparam PT_OUT0_ADDR    = 8'h50;
  localparam PT_OUT1_ADDR    = 8'h54;
  localparam PT_OUT2_ADDR    = 8'h58;
  localparam PT_OUT3_ADDR    = 8'h5C;

  // ----------------------------------------------------------------
  // Simple AXI4-Lite master tasks
  // ----------------------------------------------------------------
  task automatic axi_write(
    input [ADDR_WIDTH-1:0] addr,
    input [DATA_WIDTH-1:0] data
  );
  begin
    @(posedge clk);
    S_AXI_AWADDR  <= addr;
    S_AXI_AWVALID <= 1'b1;
    S_AXI_WDATA   <= data;
    S_AXI_WSTRB   <= {DATA_WIDTH/8{1'b1}}; // all bytes valid
    S_AXI_WVALID  <= 1'b1;
    S_AXI_BREADY  <= 1'b1;

    // Wait for address & data handshake
    wait (S_AXI_AWREADY && S_AXI_WREADY);
    @(posedge clk);
    S_AXI_AWVALID <= 1'b0;
    S_AXI_WVALID  <= 1'b0;

    // Wait for write response
    wait (S_AXI_BVALID);
    @(posedge clk);
    S_AXI_BREADY  <= 1'b0;
  end
  endtask

  task automatic axi_read(
    input  [ADDR_WIDTH-1:0] addr,
    output [DATA_WIDTH-1:0] data
  );
  begin
    @(posedge clk);
    S_AXI_ARADDR  <= addr;
    S_AXI_ARVALID <= 1'b1;
    S_AXI_RREADY  <= 1'b1;

    // Wait for address handshake
    wait (S_AXI_ARREADY);
    @(posedge clk);
    S_AXI_ARVALID <= 1'b0;

    // Wait for read data
    wait (S_AXI_RVALID);
    data = S_AXI_RDATA;
    @(posedge clk);
    S_AXI_RREADY <= 1'b0;
  end
  endtask

  // ----------------------------------------------------------------
  // Test sequence: encrypt then decrypt
  // ----------------------------------------------------------------
  // Using standard NIST AES-128 test vector:
  // Key        = 000102030405060708090A0B0C0D0E0F
  // Plaintext  = 00112233445566778899AABBCCDDEEFF
  // Ciphertext = 69C4E0D86A7B0430D8CDB78070B4C55A
  // (Assuming your core implements AES-128 standard)
  // ----------------------------------------------------------------
  logic [127:0] key_128;
  logic [127:0] pt_128;
  logic [127:0] ct_exp_128;
  logic [127:0] ct_obs_128;
  logic [127:0] pt_dec_128;

  logic [31:0] status_reg;
  logic [31:0] w0, w1, w2, w3;

  initial begin
    // Wait for reset deassertion
    @(posedge rst_n);
    @(posedge clk);

    // Setup vectors
    key_128    = 128'h2b7e151628aed2a6abf7158809cf4f3c;
    pt_128     = 128'h3243f6a8885a308d313198a2e0370734;
    ct_exp_128 = 128'h3925841d02dc09fbdc118597196a0b32;

    $display("[%0t] Starting AES AXI-Lite test...", $time);

    // ------------------------------------------------------------
    // 1) Program key via AXI
    // ------------------------------------------------------------
    // key_reg[0] = [31:0], key_reg[1] = [63:32], key_reg[2] = [95:64], key_reg[3] = [127:96]
    axi_write(KEY0_ADDR, key_128[ 31:  0]);
    axi_write(KEY1_ADDR, key_128[ 63: 32]);
    axi_write(KEY2_ADDR, key_128[ 95: 64]);
    axi_write(KEY3_ADDR, key_128[127: 96]); // also triggers set_key pulse

    // ------------------------------------------------------------
    // 2) Program plaintext for encryption
    // ------------------------------------------------------------
    axi_write(PT_IN0_ADDR, pt_128[ 31:  0]);
    axi_write(PT_IN1_ADDR, pt_128[ 63: 32]);
    axi_write(PT_IN2_ADDR, pt_128[ 95: 64]);
    axi_write(PT_IN3_ADDR, pt_128[127: 96]); // triggers set_plain_text

    // ------------------------------------------------------------
    // 3) Start encryption: CTRL bit0 = START_ENC
    // ------------------------------------------------------------
    $display("[%0t] Starting encryption...", $time);
    axi_write(CTRL_ADDR, 32'h0000_0001);

    // Wait for ENC_BUSY to go 1 then back to 0
    // STATUS bit0 = ENC_BUSY
    // First wait until busy == 1 (started)
    repeat (1000) begin
      axi_read(STATUS_ADDR, status_reg);
      if (status_reg[0] == 1'b1) break;
      @(posedge clk);
    end

    // Then wait until busy == 0 (done)
    repeat (10000) begin
      axi_read(STATUS_ADDR, status_reg);
      if (status_reg[0] == 1'b0) break;
      @(posedge clk);
    end

    $display("[%0t] Encryption complete, STATUS = 0x%08x", $time, status_reg);

    // ------------------------------------------------------------
    // 4) Read ciphertext out
    // ------------------------------------------------------------
    axi_read(CT_OUT0_ADDR, w0);
    axi_read(CT_OUT1_ADDR, w1);
    axi_read(CT_OUT2_ADDR, w2);
    axi_read(CT_OUT3_ADDR, w3);

    ct_obs_128 = {w3, w2, w1, w0};

    $display("[%0t] Ciphertext observed = %032h", $time, ct_obs_128);
    $display("[%0t] Ciphertext expected = %032h", $time, ct_exp_128);

    if (ct_obs_128 !== ct_exp_128) begin
      $display("[%0t] **ERROR** Encryption mismatch!", $time);
    end else begin
      $display("[%0t] Encryption matches expected vector.", $time);
    end

    // ------------------------------------------------------------
    // 5) Decrypt: load ciphertext as CT_IN, then START_DEC
    // ------------------------------------------------------------
    $display("[%0t] Starting decryption...", $time);

    axi_write(CT_IN0_ADDR, ct_obs_128[ 31:  0]);
    axi_write(CT_IN1_ADDR, ct_obs_128[ 63: 32]);
    axi_write(CT_IN2_ADDR, ct_obs_128[ 95: 64]);
    axi_write(CT_IN3_ADDR, ct_obs_128[127: 96]); // triggers set_cipher_text

    // Start decryption: CTRL bit1 = START_DEC
    axi_write(CTRL_ADDR, 32'h0000_0002);

    // Wait for DEC_BUSY (STATUS bit2)
    repeat (1000) begin
      axi_read(STATUS_ADDR, status_reg);
      if (status_reg[2] == 1'b1) break;
      @(posedge clk);
    end

    repeat (10000) begin
      axi_read(STATUS_ADDR, status_reg);
      if (status_reg[2] == 1'b0) break;
      @(posedge clk);
    end

    $display("[%0t] Decryption complete, STATUS = 0x%08x", $time, status_reg);

    // ------------------------------------------------------------
    // 6) Read decrypted plaintext out and compare
    // ------------------------------------------------------------
    axi_read(PT_OUT0_ADDR, w0);
    axi_read(PT_OUT1_ADDR, w1);
    axi_read(PT_OUT2_ADDR, w2);
    axi_read(PT_OUT3_ADDR, w3);

    pt_dec_128 = {w3, w2, w1, w0};

    $display("[%0t] Decrypted plaintext = %032h", $time, pt_dec_128);
    $display("[%0t] Original  plaintext = %032h", $time, pt_128);

    if (pt_dec_128 !== pt_128) begin
      $display("[%0t] **ERROR** Decryption mismatch!", $time);
    end else begin
      $display("[%0t] Decryption matches original plaintext. ✅", $time);
    end

    $display("[%0t] Test completed.", $time);
    #100;
    $finish;
  end

endmodule
