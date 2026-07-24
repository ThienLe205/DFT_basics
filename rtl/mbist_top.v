module mbist_top (
    input clk,
    input rst_n,
    input test_en,
    input wire [1:0] fault,
    output done,
    output fail
);

    wire w_en;
    wire [3:0] a_bus;
    wire [7:0] d_to_mem;
    wire [7:0] d_from_mem;

    sram_16x8 sram_inst(
        .clk(clk),
        .we(w_en),
        .adr(a_bus),
        .din(d_to_mem),
        .dout(d_from_mem),
        .fault(fault)
    );

    mbist_fsm ctrl(
        .clk(clk),
        .rst_n(rst_n),
        .start_test(test_en),
        .we_out(w_en),
        .addr_out(a_bus),
        .data_out(d_to_mem),
        .data_in(d_from_mem),
        .done_flag(done),
        .err_flag(fail)
    );

endmodule