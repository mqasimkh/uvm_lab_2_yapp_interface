# UVM Transmit (TX) Agent - Lab Task

## Table of Contents
- [1. yapp_tx_driver](#1-yapp_tx_driver)

---

## 1. yapp_tx_driver

In this class implemented the TX driver by extending from `uvm_driver` with the `yapp_packet` type parameter. `yapp_packet` is uvm_sequence_item already defined.

- **Factory Registration:**

  `uvm_component_utils(yapp_tx_driver)`

- **Constructor:**

  The constructor uses the standard `name` and `parent` arguments and passes them to the base class:

  function new(string name = "yapp_tx_driver", uvm_component parent);
      super.new(name, parent);
  endfunction

- **run_phase Task:**

  A `forever` loop is used to get items from the sequencer, send them to DUT, and mark them done:

  task run_phase(uvm_phase phase);
      forever begin
          seq_item_port.get_next_item(req);
          send_to_dut(req);
          seq_item_port.item_done();
      end
  endtask

- **send_to_dut Task:**

  A helper task to simulate sending data. Currently, it just prints the packet using `uvm_info`:

  task send_to_dut(yapp_packet req);
      #10ns;
      `uvm_info("DRIVER", $sformatf("Packet is \n%s", req.sprint()), UVM_LOW);
  endtask

This confirms that the driver receives the packet from the sequencer and performs basic debug output.

---