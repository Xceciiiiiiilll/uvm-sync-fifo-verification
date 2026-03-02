    `uvm_analysis_imp_decl(_wr)
	`uvm_analysis_imp_decl(_rd)

      class fifo_scoreboard extends uvm_scoreboard;
        `uvm_component_utils(fifo_scoreboard)

        
        // implementation ports  
        // Means this component implements the corresponding write function.
        uvm_analysis_imp_wr #(fifo_seq_item, fifo_scoreboard) wr_imp;
        uvm_analysis_imp_rd #(fifo_seq_item, fifo_scoreboard) rd_imp;
        
        virtual fifo_if vif;
        bit [7:0] model_q[$];
        bit [7:0] expected;
  		int DEPTH = 16;
        
        function new(string name = "fifo_scoreboard",uvm_component parent);
          super.new(name,parent);
        endfunction
        
        function void build_phase(uvm_phase phase);
          wr_imp = new("wr_imp",this);
          rd_imp = new("rd_imp",this);
          
          // we need to access the VIF to detect reset
          if (!uvm_config_db#(virtual fifo_if)::get(this,"","vif",vif)) 				`uvm_fatal("NO_VIF","No vif")
            
        endfunction
        
            // write function implementation for writes
        function void write_wr(fifo_seq_item txn);
              if (model_q.size() == DEPTH) begin
      			`uvm_error("MODEL_OVERFLOW","Model overflow")
              end
    	else begin
          model_q.push_back(txn.wr_data);
    	end
        endfunction
        
         // write function implementation for reads
        function void write_rd(fifo_seq_item txn);
          if(model_q.size() == 0) begin
            `uvm_error("MODEL_UNDERFLOW", "Model underflow")
            return;
          end
          
   		  expected = model_q.pop_front();
          
          if (txn.rd_data !== expected) begin
            `uvm_error("DATA_MISMATCH",$sformatf("Expected %0h Got %0h", expected, txn.rd_data))
		  end
    	  else begin
            `uvm_info("MATCH",$sformatf("Matched %0h", txn.rd_data), UVM_LOW)
    end
          
        endfunction
        
        
          // Reset handling
  task run_phase(uvm_phase phase);
    forever begin
      @(negedge vif.rst_n);
      model_q.delete();
      `uvm_info("RESET","Scoreboard model cleared", UVM_LOW)
    end
  endtask
        
        
      endclass