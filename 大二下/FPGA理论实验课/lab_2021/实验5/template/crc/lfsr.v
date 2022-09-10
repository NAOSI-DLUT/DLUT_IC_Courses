`timescale 1ns/1ps

//Galois LFSR for CRC32
module lfsr#(
           parameter BITWIDTH = 8,
           parameter LFSR_WIDTH = 32,
           parameter LFSR_POLY = 32'h04C11DB7,
           parameter LFSR_REVERSE = 1
       )(
           input wire [BITWIDTH - 1: 0] data_i,
           input wire [LFSR_WIDTH - 1: 0] state_i,
           output wire [BITWIDTH - 1: 0] data_o,
           output wire [LFSR_WIDTH - 1: 0] state_o
       );

reg [LFSR_WIDTH - 1: 0] lfsr_mask_state [LFSR_WIDTH - 1: 0];
reg [BITWIDTH - 1: 0] lfsr_mask_data [LFSR_WIDTH - 1: 0];

reg [LFSR_WIDTH - 1: 0] output_mask_state [BITWIDTH - 1: 0];
reg [BITWIDTH - 1: 0] output_mask_data [BITWIDTH - 1: 0];

reg [LFSR_WIDTH - 1: 0] state_val = 0;
reg [BITWIDTH - 1: 0] data_val = 0;

integer i, j, k;
initial begin
    // init bit masks
    for (i = 0; i < LFSR_WIDTH; i = i + 1) begin
        lfsr_mask_state[i] = {LFSR_WIDTH{1'b0}};
        lfsr_mask_state[i][i] = 1'b1;
        lfsr_mask_data[i] = {BITWIDTH{1'b0}};
    end
    for (i = 0; i < BITWIDTH; i = i + 1) begin
        output_mask_state[i] = {LFSR_WIDTH{1'b0}};
        if (i < LFSR_WIDTH) begin
            output_mask_state[i][i] = 1'b1;
        end
        output_mask_data[i] = {BITWIDTH{1'b0}};
    end

    // Galois configuration
    for (i = BITWIDTH - 1; i >= 0; i = i - 1) begin
        // determine shift in value
        // current value in last FF, XOR with input data bit (MSB first)
        state_val = lfsr_mask_state[LFSR_WIDTH - 1];
        data_val = lfsr_mask_data[LFSR_WIDTH - 1];
        data_val = data_val ^ (1 << i);

        // shift
        for (j = LFSR_WIDTH - 1; j > 0; j = j - 1) begin
            lfsr_mask_state[j] = lfsr_mask_state[j - 1];
            lfsr_mask_data[j] = lfsr_mask_data[j - 1];
        end
        for (j = BITWIDTH - 1; j > 0; j = j - 1) begin
            output_mask_state[j] = output_mask_state[j - 1];
            output_mask_data[j] = output_mask_data[j - 1];
        end

        output_mask_state[0] = state_val;
        output_mask_data[0] = data_val;
        lfsr_mask_state[0] = state_val;
        lfsr_mask_data[0] = data_val;

        // add XOR inputs at correct indicies
        for (j = 1; j < LFSR_WIDTH; j = j + 1) begin
            if (LFSR_POLY & (1 << j)) begin
                lfsr_mask_state[j] = lfsr_mask_state[j] ^ state_val;
                lfsr_mask_data[j] = lfsr_mask_data[j] ^ data_val;
            end
        end
    end

    // reverse bits if selected
    if (LFSR_REVERSE) begin
        // reverse order
        for (i = 0; i < LFSR_WIDTH / 2; i = i + 1) begin
            state_val = lfsr_mask_state[i];
            data_val = lfsr_mask_data[i];
            lfsr_mask_state[i] = lfsr_mask_state[LFSR_WIDTH - i - 1];
            lfsr_mask_data[i] = lfsr_mask_data[LFSR_WIDTH - i - 1];
            lfsr_mask_state[LFSR_WIDTH - i - 1] = state_val;
            lfsr_mask_data[LFSR_WIDTH - i - 1] = data_val;
        end
        for (i = 0; i < BITWIDTH / 2; i = i + 1) begin
            state_val = output_mask_state[i];
            data_val = output_mask_data[i];
            output_mask_state[i] = output_mask_state[BITWIDTH - i - 1];
            output_mask_data[i] = output_mask_data[BITWIDTH - i - 1];
            output_mask_state[BITWIDTH - i - 1] = state_val;
            output_mask_data[BITWIDTH - i - 1] = data_val;
        end

        // reverse bits
        for (i = 0; i < LFSR_WIDTH; i = i + 1) begin
            state_val = 0;
            for (j = 0; j < LFSR_WIDTH; j = j + 1) begin
                state_val[j] = lfsr_mask_state[i][LFSR_WIDTH - j - 1];
            end
            lfsr_mask_state[i] = state_val;

            data_val = 0;
            for (j = 0; j < BITWIDTH; j = j + 1) begin
                data_val[j] = lfsr_mask_data[i][BITWIDTH - j - 1];
            end
            lfsr_mask_data[i] = data_val;
        end
        for (i = 0; i < BITWIDTH; i = i + 1) begin
            state_val = 0;
            for (j = 0; j < LFSR_WIDTH; j = j + 1) begin
                state_val[j] = output_mask_state[i][LFSR_WIDTH - j - 1];
            end
            output_mask_state[i] = state_val;

            data_val = 0;
            for (j = 0; j < BITWIDTH; j = j + 1) begin
                data_val[j] = output_mask_data[i][BITWIDTH - j - 1];
            end
            output_mask_data[i] = data_val;
        end
    end
end

genvar n;
generate
    for (n = 0; n < LFSR_WIDTH; n = n + 1) begin : loop1
        assign state_o[n] = ^ {(state_i & lfsr_mask_state[n]), (data_i & lfsr_mask_data[n])};
    end
    for (n = 0; n < BITWIDTH; n = n + 1) begin : loop2
        assign data_o[n] = ^ {(state_i & output_mask_state[n]), (data_i & output_mask_data[n])};
    end
endgenerate

endmodule
