class yapp_tx_monitor extends uvm_monitor #(yapp_packet);

    `uvm_component_utils(yapp_tx_monitor)

    function new (string name = "yapp_tx_monitor", uvm_component parent);
        super.new(name, parent);
    endfunction: new

    task run_phase(uvm_phase phase);
        `uvm_info("MONITOR", "You are in Monitor", UVM_LOW);
    endtask: run_phase

endclass: yapp_tx_monitor