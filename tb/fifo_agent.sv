// ───────────────────────────────────────────────
//   AGENT
// ───────────────────────────────────────────────
class fifo_agent extends uvm_agent;

    `uvm_component_utils(fifo_agent)

    fifo_sequencer  sqr;
    fifo_driver     drv;
	fifo_write_monitor wr_mon;
    fifo_read_monitor rd_mon;
  	fifo_coverage coverage;
  
  uvm_analysis_port #(fifo_seq_item) write_ap;
  uvm_analysis_port #(fifo_seq_item) read_ap;
  
    uvm_active_passive_enum is_active = UVM_ACTIVE;

    function new(string name = "fifo_agent", uvm_component parent = null);
        super.new(name, parent);
    endfunction

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        sqr = fifo_sequencer::type_id::create("sqr", this);
        if (is_active == UVM_ACTIVE) begin
        	drv = fifo_driver::type_id::create("drv", this);
        end
        wr_mon = fifo_write_monitor::type_id::create("wr_mon", this);
        rd_mon = fifo_read_monitor::type_id::create("rd_mon", this);
        write_ap = new("write_ap", this);
  		read_ap  = new("read_ap",  this);
        coverage  = fifo_coverage::type_id::create("coverage", this);
      
    endfunction

    function void connect_phase(uvm_phase phase);
        super.connect_phase(phase);
        if (is_active == UVM_ACTIVE) begin
            drv.seq_item_port.connect(sqr.seq_item_export);
        end
      
         wr_mon.ap.connect(write_ap);
  		 rd_mon.ap.connect(read_ap);
      wr_mon.ap.connect(coverage.analysis_export);
      rd_mon.ap.connect(coverage.analysis_export);
      
    endfunction

endclass

