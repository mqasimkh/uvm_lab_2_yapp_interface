# UVM Transmit (TX) Agent - Lab Task

## Table of Contents
- [1. yapp_tx_driver](#1-yapp_tx_driver)

---

## 1. yapp_tx_driver

In this class implemented the TX driver by extending from `uvm_driver`, with `yapp_packet` as the sequence item type.  `yapp_packet` is already defined as a `uvm_sequence_item`.

`driver` is parameterized using the transaction class `yapp_packet`.

Registered in factory using:

`uvm_component_utils(yapp_tx_driver)`

 Constructor takes `name` and `parent` as arguments and passes them to the base class:

```systemverilog
function new(string name = "yapp_tx_driver", uvm_component parent);  
    super.new(name, parent);  
endfunction
```

In the run_phase, a `forever` loop is used to get a packet from the sequencer using `get_next_item`, then send it to the DUT using a helper task, and finally mark the item done using `item_done`.

task run_phase(uvm_phase phase);  
    forever begin  
        seq_item_port.get_next_item(req);  
        send_to_dut(req);  
        seq_item_port.item_done();  
    end  
endtask

The `send_to_dut` task is used to simulate data transmission. For now, it simply prints the packet using `uvm_info`:

```systemverilog
task send_to_dut(yapp_packet req);  
    #10ns;  
    `uvm_info("DRIVER", $sformatf("Packet is \n%s", req.sprint()), UVM_LOW);  
endtask
```

Now if this message is printed confirms that the driver receives packets from the sequencer.

---

## 2. yapp_tx_monitor

I implemented the TX monitor by extending from `uvm_monitor`.  Like `driver` , `monitor` is also parameterized using the transaction class `yapp_packet`.

registered it with the factory using:

`uvm_component_utils(yapp_tx_monitor)`

In the constructor, passed the `name` and `parent` arguments to the base class using `super.new`.

In the `run_phase`, I simply added a `uvm_info` message to confirm monitor activity during simulation:

task run_phase(uvm_phase phase);  
    `uvm_info("MONITOR", "You are in Monitor", UVM_LOW);  
endtask

Now if this message is printed confirms that the monitor is working and prints a message when active in the simulation.

---

