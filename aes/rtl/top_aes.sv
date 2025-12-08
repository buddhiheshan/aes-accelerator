// aes_axi_lite.sv
module top_aes #(
    parameter ADDR_WIDTH = 8,
    parameter DATA_WIDTH = 32
)(
    // AXI4-Lite clock & reset
    input  logic                     S_AXI_ACLK,
    input  logic                     S_AXI_ARESETN,

    // Write address channel
    input  logic [ADDR_WIDTH-1:0]    S_AXI_AWADDR,
    input  logic                     S_AXI_AWVALID,
    output logic                     S_AXI_AWREADY,

    // Write data channel
    input  logic [DATA_WIDTH-1:0]    S_AXI_WDATA,
    input  logic [(DATA_WIDTH/8)-1:0] S_AXI_WSTRB,
    input  logic                     S_AXI_WVALID,
    output logic                     S_AXI_WREADY,

    // Write response channel
    output logic [1:0]               S_AXI_BRESP,
    output logic                     S_AXI_BVALID,
    input  logic                     S_AXI_BREADY,

    // Read address channel
    input  logic [ADDR_WIDTH-1:0]    S_AXI_ARADDR,
    input  logic                     S_AXI_ARVALID,
    output logic                     S_AXI_ARREADY,

    // Read data channel
    output logic [DATA_WIDTH-1:0]    S_AXI_RDATA,
    output logic [1:0]               S_AXI_RRESP,
    output logic                     S_AXI_RVALID,
    input  logic                     S_AXI_RREADY
);

    timeunit 1ns/1ps;
    timeprecision 1ps;

    // -----------------------------------------
    // Address map
    // -----------------------------------------
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

    // -----------------------------------------
    // Internal register file (inputs + control)
    // -----------------------------------------
    logic [31:0] key_reg    [0:3];
    logic [31:0] pt_in_reg  [0:3];
    logic [31:0] ct_in_reg  [0:3];

    logic [31:0] reg_ctrl;
    logic [31:0] reg_status;

    // -----------------------------------------
    // Signals to AES core
    // -----------------------------------------
    logic         set_plain_text;
    logic         set_cipher_text;
    logic         set_key;
    logic         start_enc;
    logic         start_dec;

    logic [127:0] plain_text_in;
    logic [127:0] plain_text_out;
    logic [127:0] cipher_text_in;
    logic [127:0] cipher_text_out;
    logic [127:0] key_in;

    logic         done_enc;
    logic         done_dec;

    // Pack inputs to AES core
    assign key_in = {
        key_reg[3], key_reg[2], key_reg[1], key_reg[0]
    };

    assign plain_text_in = {
        pt_in_reg[3], pt_in_reg[2], pt_in_reg[1], pt_in_reg[0]
    };

    assign cipher_text_in = {
        ct_in_reg[3], ct_in_reg[2], ct_in_reg[1], ct_in_reg[0]
    };

    // -----------------------------------------
    // Instantiate AES core
    // -----------------------------------------
    aes_core u_aes_core (
        .clk             (S_AXI_ACLK),
        .reset_n         (S_AXI_ARESETN),

        .set_plain_text  (set_plain_text),
        .plain_text_in   (plain_text_in),
        .plain_text_out  (plain_text_out),

        .set_cipher_text (set_cipher_text),
        .cipher_text_in  (cipher_text_in),
        .cipher_text_out (cipher_text_out),

        .set_key         (set_key),
        .key             (key_in),

        .start_enc       (start_enc),
        .start_dec       (start_dec),

        .done_enc        (done_enc),
        .done_dec        (done_dec)
    );

    // -----------------------------------------
    // Busy & status bits (based on start/done)
    // -----------------------------------------
    logic enc_busy, dec_busy;

    always_ff @(posedge S_AXI_ACLK or negedge S_AXI_ARESETN) begin
        if (!S_AXI_ARESETN) begin
            enc_busy <= 1'b0;
            dec_busy <= 1'b0;
        end else begin
            if (start_enc) enc_busy <= 1'b1;
            if (done_enc)  enc_busy <= 1'b0;

            if (start_dec) dec_busy <= 1'b1;
            if (done_dec)  dec_busy <= 1'b0;
        end
    end

    always_ff @(posedge S_AXI_ACLK or negedge S_AXI_ARESETN) begin
        if (!S_AXI_ARESETN) begin
            reg_status <= '0;
        end else begin
            reg_status[0]     <= enc_busy;   // ENC_BUSY
            reg_status[1]     <= done_enc;   // ENC_DONE
            reg_status[2]     <= dec_busy;   // DEC_BUSY
            reg_status[3]     <= done_dec;   // DEC_DONE
            reg_status[31:4]  <= '0;
        end
    end

    // -----------------------------------------
    // AXI-Lite: always-ready handshake
    // -----------------------------------------
    // Write side
    assign S_AXI_AWREADY = 1'b1;
    assign S_AXI_WREADY  = 1'b1;

    wire write_en = S_AXI_AWVALID && S_AXI_WVALID;

    // Write response
    always_ff @(posedge S_AXI_ACLK or negedge S_AXI_ARESETN) begin
        if (!S_AXI_ARESETN) begin
            S_AXI_BVALID <= 1'b0;
            S_AXI_BRESP  <= 2'b00; // OKAY
        end else begin
            if (write_en && !S_AXI_BVALID) begin
                S_AXI_BVALID <= 1'b1;
                S_AXI_BRESP  <= 2'b00;
            end else if (S_AXI_BVALID && S_AXI_BREADY) begin
                S_AXI_BVALID <= 1'b0;
            end
        end
    end

    // -----------------------------------------
    // Register writes + AES control pulses
    // -----------------------------------------
    integer i;
    always_ff @(posedge S_AXI_ACLK or negedge S_AXI_ARESETN) begin
        if (!S_AXI_ARESETN) begin
            reg_ctrl <= '0;
            for (i = 0; i < 4; i++) begin
                key_reg[i]   <= '0;
                pt_in_reg[i] <= '0;
                ct_in_reg[i] <= '0;
            end

            set_key         <= 1'b0;
            set_plain_text  <= 1'b0;
            set_cipher_text <= 1'b0;
            start_enc       <= 1'b0;
            start_dec       <= 1'b0;
        end else begin
            // default pulses low
            set_key         <= 1'b0;
            set_plain_text  <= 1'b0;
            set_cipher_text <= 1'b0;
            start_enc       <= 1'b0;
            start_dec       <= 1'b0;

            if (write_en) begin
                unique case (S_AXI_AWADDR[7:0])

                    // CTRL: bit0 = START_ENC, bit1 = START_DEC
                    CTRL_ADDR: begin
                        for (int b = 0; b < 4; b++) begin
                            if (S_AXI_WSTRB[b])
                                reg_ctrl[b*8 +: 8] <= S_AXI_WDATA[b*8 +: 8];
                        end
                        if (S_AXI_WDATA[0]) start_enc <= 1'b1;
                        if (S_AXI_WDATA[1]) start_dec <= 1'b1;
                    end

                    // KEY (128-bit)
                    KEY0_ADDR: if (S_AXI_WSTRB != 4'b0000) key_reg[0] <= S_AXI_WDATA;
                    KEY1_ADDR: if (S_AXI_WSTRB != 4'b0000) key_reg[1] <= S_AXI_WDATA;
                    KEY2_ADDR: if (S_AXI_WSTRB != 4'b0000) key_reg[2] <= S_AXI_WDATA;
                    KEY3_ADDR: if (S_AXI_WSTRB != 4'b0000) begin
                        key_reg[3] <= S_AXI_WDATA;
                        set_key    <= 1'b1;   // pulse when last word written
                    end

                    // PLAINTEXT_IN (encryption input)
                    PT_IN0_ADDR: if (S_AXI_WSTRB != 4'b0000) pt_in_reg[0] <= S_AXI_WDATA;
                    PT_IN1_ADDR: if (S_AXI_WSTRB != 4'b0000) pt_in_reg[1] <= S_AXI_WDATA;
                    PT_IN2_ADDR: if (S_AXI_WSTRB != 4'b0000) pt_in_reg[2] <= S_AXI_WDATA;
                    PT_IN3_ADDR: if (S_AXI_WSTRB != 4'b0000) begin
                        pt_in_reg[3] <= S_AXI_WDATA;
                        set_plain_text <= 1'b1; // pulse on last word
                    end

                    // CIPHERTEXT_IN (decryption input)
                    CT_IN0_ADDR: if (S_AXI_WSTRB != 4'b0000) ct_in_reg[0] <= S_AXI_WDATA;
                    CT_IN1_ADDR: if (S_AXI_WSTRB != 4'b0000) ct_in_reg[1] <= S_AXI_WDATA;
                    CT_IN2_ADDR: if (S_AXI_WSTRB != 4'b0000) ct_in_reg[2] <= S_AXI_WDATA;
                    CT_IN3_ADDR: if (S_AXI_WSTRB != 4'b0000) begin
                        ct_in_reg[3] <= S_AXI_WDATA;
                        set_cipher_text <= 1'b1; // pulse on last word
                    end

                    default: ;
                endcase
            end
        end
    end

    // -----------------------------------------
    // AXI-Lite read channel (always-ready AR)
    // -----------------------------------------
    assign S_AXI_ARREADY = 1'b1;

    wire read_en = S_AXI_ARVALID;

    always_ff @(posedge S_AXI_ACLK or negedge S_AXI_ARESETN) begin
        if (!S_AXI_ARESETN) begin
            S_AXI_RVALID <= 1'b0;
            S_AXI_RRESP  <= 2'b00;
            S_AXI_RDATA  <= '0;
        end else begin
            if (read_en && !S_AXI_RVALID) begin
                S_AXI_RVALID <= 1'b1;
                S_AXI_RRESP  <= 2'b00; // OKAY

                unique case (S_AXI_ARADDR[7:0])
                    CTRL_ADDR:    S_AXI_RDATA <= reg_ctrl;
                    STATUS_ADDR:  S_AXI_RDATA <= reg_status;

                    KEY0_ADDR:    S_AXI_RDATA <= key_reg[0];
                    KEY1_ADDR:    S_AXI_RDATA <= key_reg[1];
                    KEY2_ADDR:    S_AXI_RDATA <= key_reg[2];
                    KEY3_ADDR:    S_AXI_RDATA <= key_reg[3];

                    PT_IN0_ADDR:  S_AXI_RDATA <= pt_in_reg[0];
                    PT_IN1_ADDR:  S_AXI_RDATA <= pt_in_reg[1];
                    PT_IN2_ADDR:  S_AXI_RDATA <= pt_in_reg[2];
                    PT_IN3_ADDR:  S_AXI_RDATA <= pt_in_reg[3];

                    CT_IN0_ADDR:  S_AXI_RDATA <= ct_in_reg[0];
                    CT_IN1_ADDR:  S_AXI_RDATA <= ct_in_reg[1];
                    CT_IN2_ADDR:  S_AXI_RDATA <= ct_in_reg[2];
                    CT_IN3_ADDR:  S_AXI_RDATA <= ct_in_reg[3];

                    // **Directly expose AES core outputs here**
                    CT_OUT0_ADDR: S_AXI_RDATA <= cipher_text_out[ 31:  0];
                    CT_OUT1_ADDR: S_AXI_RDATA <= cipher_text_out[ 63: 32];
                    CT_OUT2_ADDR: S_AXI_RDATA <= cipher_text_out[ 95: 64];
                    CT_OUT3_ADDR: S_AXI_RDATA <= cipher_text_out[127: 96];

                    PT_OUT0_ADDR: S_AXI_RDATA <= plain_text_out[ 31:  0];
                    PT_OUT1_ADDR: S_AXI_RDATA <= plain_text_out[ 63: 32];
                    PT_OUT2_ADDR: S_AXI_RDATA <= plain_text_out[ 95: 64];
                    PT_OUT3_ADDR: S_AXI_RDATA <= plain_text_out[127: 96];

                    default:      S_AXI_RDATA <= '0;
                endcase
            end else if (S_AXI_RVALID && S_AXI_RREADY) begin
                S_AXI_RVALID <= 1'b0;
            end
        end
    end

endmodule
