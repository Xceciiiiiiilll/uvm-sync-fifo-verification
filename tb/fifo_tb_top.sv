`timescale 1ns / 1ps

// ───────────────────────────────────────────────
//   UVM imports and macros — MUST come first!
// ───────────────────────────────────────────────
import uvm_pkg::*;
`include "uvm_macros.svh"
`include "fifo_if.sv"
`include "fifo_seq_item.sv"
`include "fifo_base_sequence.sv"
`include "fifo_driver.sv"
`include "fifo_sequencer.sv"
`include "fifo_write_monitor.sv"
`include "fifo_read_monitor.sv"
`include "fifo_coverage.sv"
`include "fifo_agent.sv"
`include "fifo_scoreboard.sv"
`include "fifo_env.sv"
`include "fifo_base_test.sv"



// ───────────────────────────────────────────────
//   TOP MODULE
// ───────────────────────────────────────────────
module fifo_tb_top;

    parameter int DEPTH = 16;
    parameter int WIDTH = 8;

    logic clk = 0;
    logic rst_n = 0;

    always #5 clk = ~clk;

    fifo_if #(.DEPTH(DEPTH), .WIDTH(WIDTH)) fifo_if_inst (.clk(clk), .rst_n(rst_n));

    sync_fifo #(
        .DEPTH(DEPTH),
        .WIDTH(WIDTH)
    ) dut (
        .clk     (clk),
        .rst_n   (rst_n),
        .wr_en   (fifo_if_inst.wr_en),
        .wr_data (fifo_if_inst.wr_data),
        .rd_en   (fifo_if_inst.rd_en),
        .rd_data (fifo_if_inst.rd_data),
        .full    (fifo_if_inst.full),
        .empty   (fifo_if_inst.empty)
    );

    // Reset generation
    initial begin
        rst_n = 0;
        #10;
        rst_n = 1;
    end

    // UVM + waveform dump
    initial begin
        // Set interface for driver
        uvm_config_db #(virtual fifo_if.DRIVER)::set(
            null,
            "uvm_test_top.env.agent.drv",
            "vif",
            fifo_if_inst
        );
      uvm_config_db #(virtual fifo_if.MONITOR)::set(
            null,
            "uvm_test_top.env.agent.wr_mon",
            "vif",
            fifo_if_inst
        );
       uvm_config_db #(virtual fifo_if.MONITOR)::set(
            null,
            "uvm_test_top.env.agent.rd_mon",
            "vif",
            fifo_if_inst
        );
      // set interface for scoreboard
        uvm_config_db #(virtual fifo_if)::set(
            null,
            "uvm_test_top.env.scoreboard",
            "vif",
            fifo_if_inst
        );

        run_test("fifo_base_test");
    end

    // Use WLF format (recommended for Questa/ModelSim)
    initial begin
        $wlfdumpvars(0, fifo_tb_top);   // dumps everything
        // If you prefer VCD:
         $dumpfile("fifo_uvm.vcd");
         $dumpvars(0, fifo_tb_top);
    end

endmodule