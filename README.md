# UVM Lab # 2: Creating YAPP Interface UVC

## Table of Contents
- [1. yapp_tx_driver](#1-yapp_tx_driver)

---

## Task_1

### 1. yapp_tx_driver

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

```systemverilog
task run_phase(uvm_phase phase);  
    forever begin  
        seq_item_port.get_next_item(req);  
        send_to_dut(req);  
        seq_item_port.item_done();  
    end  
endtask
```

The `send_to_dut` task is used to simulate data transmission. For now, it simply prints the packet using `uvm_info`:

```systemverilog
task send_to_dut(yapp_packet req);  
    #10ns;  
    `uvm_info("DRIVER", $sformatf("Packet is \n%s", req.sprint()), UVM_LOW);  
endtask
```

Now if this message is printed confirms that the driver receives packets from the sequencer.

---

### 2. yapp_tx_monitor

I implemented the TX monitor by extending from `uvm_monitor`.  Like `driver` , `monitor` is also parameterized using the transaction class `yapp_packet`.

registered it with the factory using:

```systemverilog
`uvm_component_utils(yapp_tx_monitor)`
```

In the constructor, passed the `name` and `parent` arguments to the base class using `super.new`.

In the `run_phase`, I simply added a `uvm_info` message to confirm monitor activity during simulation:

```systemverilog
task run_phase(uvm_phase phase);  
    `uvm_info("MONITOR", "You are in Monitor", UVM_LOW);  
endtask
```

Now if this message is printed confirms that the monitor is working and prints a message when active in the simulation.

---

### 3. yapp_tx_sequencer

Created TX sequencer by extending from `uvm_sequencer`, parameterized with `yapp_packet`.

Sequencer control the flow of packets between the sequence and the driver using the TLM interface. driver uses the sequencer's built-in TLM methods — `get_next_item` and `item_done` — via `seq_item_port` to fetch and complete transactions.

Registered it with the factory using same macro as for above class. The constructor simply pass the `name` and `parent` to the base class using `super.new`.

---

### 4. yapp_tx_agent

Next created the TX agent by extending from `uvm_agent`. Just like the other components, registered it with the factory using the built-in macros.

Inside this agent, I declared handles for sequencer, monitor and driver. Agent can be either **active** or **passive**.  
An `active agent` includes all three components: sequencer, monitor and driver, but a `passive agent` only has the monitor.

To handle this, I used the `is_active` flag in the `build_phase`, which is already built-in in `uvm_agent`.

If the agent is active, then I construct all three components.   

If it’s passive, then only the monitor is created.

In the `connect_phase`, I connected the TLM interface between the driver and the sequencer,   but only if the agent is active.

This way agent can be reused in different simulation scenerios by just changing is_active.

---

### 5. yap_env

I created `yap_env` by extending from `uvm_env`.  
Inside it, I made a handle for the agent and created it in the `build_phase` using the `new` method.

`yap_env` acts like the container for the agent and is the top-level environment component in this setup.

After that, I edited the `router_tb` file where I created an object of `yap_env`.  

## Running Test

Updated yapp_pkg and added include for all the new files created for classes.

In the top module, I ran the simulation using `run_test` and passed `base_test` as the argument.

The topology printed if correct as per expectation. Screenshot below:

![screenshot-1](/screenshots/1.png)

---


