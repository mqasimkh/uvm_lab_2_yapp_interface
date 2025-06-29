class base_test extends uvm_test;

    `uvm_component_utils(base_test)

    function new (string name = "base_test", uvm_component parent);
        super.new(name, parent);
    endfunction

    router_tb tb;

    function void build_phase(uvm_phase phase);

         uvm_config_wrapper::set(this, "tb.uvc.agent.sequencer.run_phase",
            "default_sequence",
            yapp_5_packets::get_type());

        tb = new("tb", this);
        `uvm_info(get_type_name(), "Build phase of test is being executed", UVM_HIGH);
    endfunction: build_phase
    
    function void start_of_simulation_phase(uvm_phase phase);
        `uvm_info(get_type_name(), "Running Simulation ...", UVM_HIGH);
    endfunction: start_of_simulation_phase

    function void end_of_elaboration_phase(uvm_phase phase);
        uvm_top.print_topology();
    endfunction: end_of_elaboration_phase

endclass: base_test