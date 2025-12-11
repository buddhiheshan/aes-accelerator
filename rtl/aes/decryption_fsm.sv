module decryption_fsm (
    input logic clk, reset_n, start,
    output logic mux_sel, 
    output logic req_key, done
    // input logic [127:0] plain_text,
    // output logic [127:0] cipher_text
);
timeunit 1ns/1ps;
 //import the package
import fsm4_pkg::*;

 //create two variables called "state" and "next" of enum type
state_e state, next_state;


logic [3:0] round_count, round_count_next;
logic [1:0] round_cycle_count, round_cycle_count_next;

assign req_key = (round_cycle_count===1) ? 1 : 0;

 //Start your procedural blocks from here
always_ff @( posedge clk, negedge reset_n ) begin
    if (!reset_n) begin
        state <= IDLE;
        round_cycle_count <= 0;
        round_count <= 10;
        //mux_sel <= 0;
    end
    else begin
        state <= next_state;
        round_cycle_count <= round_cycle_count_next;
        round_count <= round_count_next;
    end
end

always_comb begin
    next_state = IDLE;
    round_count_next = round_count;
    round_cycle_count_next = 0;
    mux_sel = 0;
    done = 1'b0;

    case (state)
        IDLE: begin
                if (start) begin
                    next_state = INITIAL_ROUND;
                    round_cycle_count_next = 0;
                    round_count_next = 10;
                end
                else next_state = IDLE;
            end

        INITIAL_ROUND: begin
                next_state = MID_ROUND;
                round_count_next = round_count - 1;
                round_cycle_count_next = 1;
            end

        MID_ROUND: begin
                mux_sel = 1;
                if (round_count === 9 && round_cycle_count !== 0) begin
                    mux_sel = 0;
                end
                if (round_count === 0 && round_cycle_count === 0) begin
                    done = 1'b1;
                    next_state = IDLE;
                end
                else if (round_cycle_count === 0) begin
                    next_state = MID_ROUND;
                    round_count_next = round_count - 1;
                    round_cycle_count_next = 2;
                end
                else begin
                    next_state = MID_ROUND;
                    round_cycle_count_next = round_cycle_count - 1;
                end
            end

        // LAST_ROUND: begin
        //         mux_sel = 1;
        //         if(round_cycle_count === 0) begin
        //             next_state = IDLE;
        //         end
        //         else begin
        //             next_state = LAST_ROUND;
        //             round_cycle_count_next = round_cycle_count - 1;
        //             done = 1'b1;
        //         end
        //     end

    endcase
end  
endmodule
