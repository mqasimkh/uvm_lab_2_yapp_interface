class yap_env extends uvm_env;

    `uvm_component_utils(yap_env)

    function new (string name = "yap_env", uvm_component parent);
        super.new(name, parent);
    endfunction: new

    yapp_tx_agent agent;

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        agent = new("agent", this);
    endfunction: build_phase

endclass: yap_env