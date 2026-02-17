# FIFO_Verification_SV

This repository contains a **SystemVerilog verification environment** for a **UART FIFO module**. The project is designed in a modular, UVM-inspired style without using the full UVM framework, making it easy to understand, extend, and reuse.
## 📝 Features

- **Transaction-based verification** using `transaction` class.  
- **Randomized operations** (read/write) using `rand` and `randc`.  
- **Generator, driver, and monitor** (GDM) architecture.  
- **Scoreboard** for automatic data comparison between driver and DUT.  
- **Event- and mailbox-driven synchronization**.  
- **Waveform generation** for easy debugging (`dump.vcd`).  
- Clean and modular design, making it easy to extend or integrate with UVM.
  # Prerequisites

- Any **SystemVerilog simulator** (e.g., **VCS**, **ModelSim/QuestaSim**, **Xcelium**, **Verilator**).  
- Basic familiarity with compiling and running SystemVerilog testbenches.

# Steps

1. **Compile design and testbench**

```bash
# Example using VCS
vcs -sverilog rtl/uart_top.sv \
           tb/interfaces/uart_if.sv \
           tb/transactions/transaction.sv \
           tb/agents/generator.sv \
           tb/agents/driver.sv \
           tb/agents/monitor.sv \
           tb/scoreboard/scoreboard.sv \
           tb/environment/environment.sv \
           tb/tb_top.sv -R
