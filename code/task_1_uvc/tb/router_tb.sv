class router_tb extends uvm_env;

    `uvm_component_utils(router_tb)

    yapp_env uvc;

    function new (string name = "router_tb", uvm_component parent);
        super.new(name, parent);
    endfunction

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        uvc = new ("uvc", this);
        `uvm_info("UVM_ENV", "Build phase of env is being executed", UVM_HIGH);
    endfunction: build_phase

endclass: uvm_env