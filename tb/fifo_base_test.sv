// ───────────────────────────────────────────────
//   BASE TEST
// ───────────────────────────────────────────────
class fifo_base_test extends uvm_test;

    `uvm_component_utils(fifo_base_test)

    fifo_env env;

    function new(string name = "fifo_base_test", uvm_component parent = null);
        super.new(name, parent);
    endfunction

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        env = fifo_env::type_id::create("env", this);
    endfunction

    function void end_of_elaboration_phase(uvm_phase phase);
        super.end_of_elaboration_phase(phase);
        uvm_top.print_topology();
    endfunction

    task run_phase(uvm_phase phase);
        fifo_base_sequence seq;

        phase.raise_objection(this);

        `uvm_info(get_type_name(), "Starting fifo_base_sequence", UVM_LOW)

        seq = fifo_base_sequence::type_id::create("seq");
        seq.start(env.agent.sqr);

        #1000ns;   // give time to observe behavior

        phase.drop_objection(this);
    endtask

endclass
