# UVM Lab # 2: Creating YAPP Interface UVC
## Table of Contents
- [Task_1](#task_1)
  - [1. yapp_tx_driver](#1-yapp_tx_driver)
  - [2. yapp_tx_monitor](#2-yapp_tx_monitor)
  - [3. yapp_tx_sequencer](#3-yapp_tx_sequencer)
  - [4. yapp_tx_agent](#4-yapp_tx_agent)
  - [5. yapp_env](#5-yapp_env)
  - [Running Test - 1](#running-test---1)
  - [Running Test - 2](#running-test---2)
  - [Running Test - 3](#running-test---3)
- [Task_2](#task_2)
  - [1. create() instead of new()](#1-create-instead-of-new)
  - [2. Enabling Transaction Recording](#2-enabling-transaction-recording)
  - [3. Creating short_yapp_packet](#3-creating-short_yapp_packet)
  - [4. Creating short_packet_test](#4-creating-short_packet_test)
  - [5. Creating set_config_test](#5-creating-set_config_test)
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

### 5. yapp_env

I created `yapp_env` by extending from `uvm_env`.  
Inside it, I made a handle for the agent and created it in the `build_phase` using the `new` method.

`yapp_env` acts like the container for the agent and is the top-level environment component in this setup.

After that, I edited the `router_tb` file where I created an object of `yapp_env`.

---
## Running Tests

### Running Test - 1

Updated yapp_pkg and added include for all the new files created for classes.

In the top module, I ran the simulation using `run_test` and passed `base_test` as the argument.

The topology printed if correct as per expectation. Screenshot below:

![screenshot-1](/screenshots/1.png)

### Running Test - 2

Now added the `uvm_config_wrapper` code from `yapp_5_packets.sv` file as instructed in the manual, and re-ran the test.

The driver is receiving the packet as printed in terminal. Screenshot below:

![screenshot-2](/screenshots/2.png)

Also at the end, UVM Report Summary: Screenshot below:

![screenshot-3](/screenshots/3.png)

---

### Running Test - 3

By default `SVSEED = 1`, so passed `SVSEED=random` in command line when running test and now packet values are different.

Also added start_of_simulation_phase()

```systemverilog
    function void start_of_simulation_phase(uvm_phase phase);
        `uvm_info(get_type_name(), "Running Simulation ...", UVM_HIGH);
    endfunction: start_of_simulation_phase
```
Ran the test again and this time the initialization packet data is different.

Checking the UVM_INFO print messages, the tx_driver start_of_simulation method is called first, and in the `base_test` it is called last. Screenshot below:

![screenshot-4](/screenshots/4.png)

---

## Task_2

### 1. create() instead of new()

Replaced factory method i.e. `create()` to construct objects instead of `new()` in build phase. Now, this allow factory overides.

Re-ran the test to see if it works and gives same output as the end of task_1 and its same.

### 2. Enabling Transaction Recording

Next, to enable the transaction recording for all classes (driver, monitor, etc.) by adding following line in `router_test_lib.sv`

```systemverilog
uvm_config_int::set(this, "*", "recording_detail", 1);
```

`*` is a wildcard which means set `recording_detail` value = `1` everywhere inside the hierchy from where this is `set` which here is from `test`.

![screenshot-5](/screenshots/5.png)

### 3. Creating short_yapp_packet

Created a new short_yapp_packet which extends yapp_packet with edited constraints. Added it inside the `yapp_packet.sv` file.

```systemverilog
class short_yapp_packet extends yapp_packet;
    `uvm_object_utils(short_yapp_packet)

    function new (string name = "short_yapp_packet");
        super.new(name);
    endfunction: new

    constraint c_1 {
        addr inside {[0:1]};
        length inside {[1:15]};
    }

endclass: short_yapp_packet
```
With above code there was issue. The payload array was not created. Here's why! I named the cosntraint same i.e. `c_1` which is same name of constraint in parent class.

So with same name, but trying to override only 2 constraints, the rest constraints were ignored.

Solution

1. If going with same name, add all constraint and change the value of constraint I need to override.
2. Give the constraint different name in child class, and then only write constraints you want to ovverride.

I opted for 2. So updated `short_yapp_packet` code:

```systemverilog
class short_yapp_packet extends yapp_packet;
    `uvm_object_utils(short_yapp_packet)

    function new (string name = "short_yapp_packet");
        super.new(name);
    endfunction: new

    constraint c_2 {
        addr inside {[0:1]};
        length inside {[1:15]};
    }


endclass: short_yapp_packet
```

### 4. Creating short_packet_test

In the `router_test_lib` created a new test named `short_packet_test` which extends the `base_test`.

Using factory override, using `set_type_override_by_type` method in the build phase:

```systemverilog
set_type_override_by_type(yapp_packet::get_type(), short_yapp_packet::get_type());
```

Now `run_test()` passed `short_yapp_packet` as argument to run short_yapp_packet test instead of base_test. 

Results as expected - now generating short_yapp_packet and topology also showing correct hierchy. Screenshow below:

`Topology`

![screenshot-6](/screenshots/6.png)

`Packets` Before Fix (Payload Array Not Created)

![screenshot-7](/screenshots/7.png)

`Packets` After Fix

![screenshot-7b](/screenshots/7b.png)

### 5. Creating set_config_test

In the `router_test_lib` created a new test named `set_config_test` which extends the `base_test`.

Set `is_active` flag of `agent` class to `UVM_PASSIVE` which means now only monitor object will be created.

```systemverilog
uvm_config_int::set(this, "tb.uvc.agent", "is_active", UVM_PASSIVE);
```
Now `run_test()` passed `set_config_test` as argument to run this new config test.

Results as expected - is_active is now `UVM_PASSIVE` as confirmed from topology as well, and no packets are generated because `driver` & `sequencer` are not constructed.

Screenshow below:

![screenshot-8](/screenshots/8.png)