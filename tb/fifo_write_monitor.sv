class fifo_write_monitor extends uvm_monitor;
        `uvm_component_utils(fifo_write_monitor)
        
 		 uvm_analysis_port #(fifo_seq_item) ap;
         virtual fifo_if.MONITOR vif;
  
        function new(string name = "fifo_read_monitor", uvm_component parent);
          super.new(name,parent);
        endfunction
        
        function void build_phase(uvm_phase phase);
          ap = new("ap",this);
          
          if (!uvm_config_db#(virtual fifo_if.MONITOR)::get(this,"","vif",vif)) 			begin
 		     `uvm_fatal("NOVIF", "Virtual interface not set")
 			end
        endfunction
        
        task run_phase(uvm_phase phase);
          fifo_seq_item txn;
          
          forever begin
            @(vif.cb_mon);
            if(vif.cb_mon.wr_en && !vif.cb_mon.full) begin
            
            
         	 txn = fifo_seq_item::type_id::create("txn");
          	 txn.wr_en = vif.cb_mon.wr_en;
             txn.rd_en = vif.cb_mon.rd_en;
             txn.wr_data = vif.cb_mon.wr_data;
             txn.empty = vif.cb_mon.empty;
             txn.full = vif.cb_mon.full;
              
         	 ap.write(txn);
              
              `uvm_info("WRITE_MON", $sformatf("Write observed: %0h", txn.wr_data), UVM_LOW);
            end
          end
        endtask
        
        
        
endclass