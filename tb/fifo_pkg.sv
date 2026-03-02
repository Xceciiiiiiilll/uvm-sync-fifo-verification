// tb/fifo_pkg.sv
`ifndef FIFO_PKG_SV
`define FIFO_PKG_SV

package fifo_pkg;

    import uvm_pkg::*;
    `include "uvm_macros.svh"

    // Forward declarations (we'll fill these in next steps)
    typedef class fifo_seq_item;
    typedef class fifo_base_sequence;
    typedef class fifo_driver;
    typedef class fifo_read_monitor;
    typedef class fifo_write_monitor;
    typedef class fifo_scoreboard;
    typedef class fifo_agent;
    typedef class fifo_env;
    typedef class fifo_base_test;

    // Include files in order (we'll add them one by one)
    `include "fifo_seq_item.sv"
    `include "fifo_sequence.sv"
     `include "fifo_driver.sv" 
     `include "fifo_read_monitor.sv"
     `include "fifo_write_monitor.sv"  
     `include "fifo_scoreboard.sv" 
     `include "fifo_agent.sv"
     `include "fifo_env.sv"
     `include "fifo_base_test.sv"

endpackage

`endif
