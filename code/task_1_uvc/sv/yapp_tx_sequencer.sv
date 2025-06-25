class yapp_tx_sequencer extends uvm_sequencer;

    `uvm_component_utils(yapp_tx_sequencer)

    function new (string name = "yapp_tx_sequencer", uvm_component parent);
        super.new(name, parent);
    endfunction: new

endclass: yapp_tx_sequencer