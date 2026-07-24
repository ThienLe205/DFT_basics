`timescale 1ns / 1ps

module tb_mbist();

    reg clk;
    reg rst_n;
    reg en;
    reg [1:0] fault_ctrl;
    wire d;
    wire f;

    mbist_top dut (
        .clk(clk),
        .rst_n(rst_n),
        .test_en(en),
        .fault(fault_ctrl),
        .done(d),
        .fail(f)
    );

    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

    initial begin
        rst_n = 0; 
        en = 0;
        fault_ctrl = 2'b11; // 2'b11: No Fault
        #15;
        rst_n = 1;
        #10;

        $display("=== TEST 1: NORMAL RUN ===");
        en = 1;
        wait(d == 1);
        #10;
        en = 0;
        
        if(!f) $display("-> PASS!");
        else $display("-> FAIL!");

        #30;
        
        $display("=== TEST 2: FAULT INJECTION (Stuck-at Fault) ===");
        // Inject fault directly via backdoor
        fault_ctrl = 2'b00; // 2'b00: Stuck-at
        
        en = 1;
        wait(d == 1);
        #10;
        en = 0;
        
        if(f) $display("-> TEST OK (Fault caught)!");
        else $display("-> TEST FAILED (Fault missed)!");

        #50;
        $finish;
    end
    
    initial begin
        $dumpfile("wave.vcd");
        $dumpvars(0, tb_mbist); 
    end

endmodule